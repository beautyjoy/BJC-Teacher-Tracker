# frozen_string_literal: true

# == Schema Information
#
# Table name: email_templates
#
#  id         :bigint           not null, primary key
#  body       :text
#  format     :string
#  handler    :string
#  locale     :string
#  partial    :boolean
#  path       :string
#  required   :boolean          default(FALSE)
#  subject    :string
#  title      :string
#  to         :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class EmailTemplate < ApplicationRecord
  validates :title,
            inclusion: TeacherMailer.instance_methods(false).map { |method| method.to_s.titlecase },
            if: -> { self.required? }
  validates :body, presence: true
  validates :to, presence: true

  before_destroy :prevent_deleting_required_emails

  def accepts_custom_reason?
    # search for 'reason' in a liquid template, e.g. denial_reason or request_reason
    body.match?(/\{\{.*_reason.*\}\}/)
  end

  private
  def prevent_deleting_required_emails
    if self.required?
      errors.add("Cannot delete a required email template")
      throw :abort
    end
  end
end
