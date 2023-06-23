# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create; end

  def destroy
    reset_session
    redirect_to root_url
  end

  def omniauth_callback
    omniauth_data = omniauth_info
    user = Teacher.user_from_omniauth(omniauth_data)
    if user.present?
      user.last_session_at = Time.zone.now
      user.try_append_ip(request.remote_ip)
      user.session_count += 1
      user.save!
      log_in(user)
    else
      Sentry.capture_message("OAuth Login Failure")
      session[:auth_data] = omniauth_data
      flash[:alert] = "We couldn't find an account for #{omniauth_data.email}. Please submit a new request."
      redirect_to new_teacher_path
    end
  end

  def omniauth_info
    request.env["omniauth.auth"].info
  end

  def omniauth_failure
    redirect_to root_url,
                alert: "Login failed unexpectedly. Please reach out to contact@bjc.berkeley.edu"
  end

  ###### PULLED FROM DISCOURSE
  # Redirect to a configured SSO PROVIDER (e.g. Snap!)
  def sso
    # raise NotFound unless ENV['DISCOURSE_CONNECT_URL'].present?

    destination_url = cookies[:destination_url] || session[:destination_url]
    return_path = params[:return_path] || root_url

    if destination_url && return_path == root_url
      uri = URI.parse(destination_url)
      return_path = "#{uri.path}#{uri.query ? "?#{uri.query}" : ""}"
    end

    session.delete(:destination_url)
    cookies.delete(:destination_url)

    sso = DiscourseConnect.generate_sso(return_path, secure_session: SecureRandom.hex)
    # connect_verbose_warn { "Verbose SSO log: Started SSO process\n\n#{sso.diagnostics}" }
    redirect_to sso_url(sso), allow_other_host: true
  end

  def sso_login
    params.require(:sso)
    params.require(:sig)

    # begin
      sso = DiscourseConnect.parse(request.query_string, secure_session: nil)
    # rescue => e
    #   # connect_verbose_warn do
    #   #   "Verbose SSO log: Signature parse error\n\n#{e.message}\n\n#{sso&.diagnostics}"
    #   # end

    #   # Do NOT pass the error text to the client, it would give them the correct signature
    #   return plain: (text: I18n.t("discourse_connect.login_error"), status: 422)
    # end

    if !sso.nonce_valid?
      # connect_verbose_warn { "Verbose SSO log: #{sso.nonce_error}\n\n#{sso.diagnostics}" }
      return render_sso_error(text: I18n.t("discourse_connect.timeout_expired"), status: 419)
    end

    return_path = sso.return_path
    sso.expire_nonce!

    begin
      # invite = validate_invitiation!(sso)

      if user = sso.lookup_or_create_user(request.remote_ip)
        # raise Discourse::ReadOnly if staff_writes_only_mode? && !user&.staff?

        if user.suspended?
          render_sso_error(text: failed_to_login(user)[:error], status: 403)
          return
        end

        if SiteSetting.must_approve_users? && !user.approved?
          redeem_invitation(invite, sso, user) if invite.present? && user.invited_user.blank?

          if SiteSetting.discourse_connect_not_approved_url.present?
            redirect_to SiteSetting.discourse_connect_not_approved_url, allow_other_host: true
          else
            render_sso_error(text: I18n.t("discourse_connect.account_not_approved"), status: 403)
          end
          return

          # we only want to redeem the invite if
          # the user has not already redeemed an invite
          # (covers the same SSO user visiting an invite link)
        elsif true && user.invited_user.blank?
          # redeem_invitation(invite, sso, user)

          # we directly call user.activate here instead of going
          # through the UserActivator path because we assume the account
          # is valid from the SSO provider's POV and do not need to
          # send an activation email to the user
          user.activate
          login_sso_user(sso, user)

          topic = invite.topics.first
          return_path = topic.present? ? path(topic.relative_url) : path("/")
        elsif !user.active?
          activation = UserActivator.new(user, request, session, cookies)
          activation.finish
          session["user_created_message"] = activation.message
          return redirect_to(users_account_created_path)
        else
          login_sso_user(sso, user)
        end

        # If it's not a relative URL check the host
        if return_path !~ %r{\A/[^/]}
          begin
            uri = URI(return_path)
            if (uri.hostname == Discourse.current_hostname)
              return_path = uri.to_s
            elsif !domain_redirect_allowed?(uri.hostname)
              return_path = root_url
            end
          rescue StandardError
            return_path = root_url
          end
        end

        # this can be done more surgically with a regex
        # but it the edge case of never supporting redirects back to
        # any url with `/session/sso` in it anywhere is reasonable
        return_path = path("/") if return_path.include?(path("/session/sso"))

        redirect_to return_path, allow_other_host: true
      else
        render_sso_error(text: "not found error", status: 500)
      end
    rescue ActiveRecord::RecordInvalid => e
      text = <<~TEXT
        Verbose SSO log: Record was invalid: #{e.record.class.name} #{e.record.id}
        #{e.record.errors.to_h}

        Attributes:
        #{e.record.attributes.slice(*DiscourseConnectBase::ACCESSORS.map(&:to_s))}

        SSO Diagnostics:
        #{sso.diagnostics}
      TEXT

      # text = nil

      # If there's a problem with the email we can explain that
      if e.record.is_a?(User) && e.record.errors[:primary_email].present?
        if e.record.email.blank?
          text = I18n.t("discourse_connect.no_email")
        else
          text =
            I18n.t("discourse_connect.email_error", email: ERB::Util.html_escape(e.record.email))
        end
      end

      render_sso_error(text: text, status: 500)
    # rescue DiscourseConnect::BlankExternalId
    #   render_sso_error(text: I18n.t("discourse_connect.blank_id_error"), status: 500)
    # rescue Invite::ValidationFailed => e
    #   render_sso_error(text: e.message, status: 400)
    # rescue Invite::RedemptionFailed => e
    #   render_sso_error(text: I18n.t("discourse_connect.invite_redeem_failed"), status: 412)
    # rescue Invite::UserExists => e
    #   render_sso_error(text: e.message, status: 412)
    rescue => e
      message = +"Failed to create or lookup user: #{e}."
      message << "  "
      message << "  #{sso.diagnostics}"
      message << "  "
      message << "  #{e.backtrace.join("\n")}"

      Rails.logger.error(message)

      render_sso_error(text: message, status: 500)
    end
  end

  def login_sso_user(sso, user)
    # connect_verbose_warn do
    #   "Verbose SSO log: User was logged on #{user.username}\n\n#{sso.diagnostics}"
    # end
    log_on_user(user) if user.id != current_user&.id
  end

  def render_sso_error(status:, text:)
    @sso_error = text
    render status: status, plain: text
  end

  # extension to allow plugins to customize the SSO URL
  def sso_url(sso)
    sso.to_url
  end

end
