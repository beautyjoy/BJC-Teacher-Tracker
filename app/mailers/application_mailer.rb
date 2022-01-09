# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  BJC_CONTACT = "BJC <contact@bjc.berkeley.edu>"
  default from: BJC_CONTACT, reply_to: BJC_CONTACT
  layout "mailer"
end
