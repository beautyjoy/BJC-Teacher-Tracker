module SeedData
  def self.emails
    [
      id: 1,
      body: "Hi <%= @teacher.first_name %>, Thanks for your feedback. Works",
      path: "teacher_mailer/welcome_email",
      locale: nil,
      handler: "erb",
      partial: false,
      format: "html"
    ]
  end
end
