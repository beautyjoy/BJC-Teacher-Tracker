# frozen_string_literal: true

EmailTemplate.where(
    title:
    ["Welcome Email", "Form Submission",
     "Deny Email", "Request Info Email"]).update_all(required: true)
