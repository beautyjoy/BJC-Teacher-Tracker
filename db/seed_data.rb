# frozen_string_literal: true

module SeedData
  @welcome_email = <<-WELCOME_EMAIL
    <p>Hi {{teacher_first_name}},<br /><br />Thanks for teaching with BJC!</p>

    <p><strong>Accessing the teacher's guide:</strong><br />To view the <a title="teacher's guide" href="https://bjc.edc.org/teacher" target="_blank" rel="noopener">teacher's guide</a>, you will need the username: <code>bjcteacher</code> and the case-sensitive password: <code>{{bjc_password}}</code><br /><br />After you enter the password once it will be stored in a cookie for that browser; if you delete your browser cookies, you will need to reenter it. If you use this password on a computer that students also use, they will have access to these pages until you clear the cookies. <br /><br />Please note that only the Teacher Guide <em>solutions</em> pages are affected by this. Students will still be able to see the Teacher Guide course overview page, the Teacher Resources page, and the Teacher Guide unit overview pages.</p>

    <p><strong>Piazza:</strong> <br />We have a teacher's forum on <a href="https://piazza.com" target="_blank" rel="noopener">Piazza</a>, where we will share updates and you can get your questions answered. If you have not been added to Piazza, you can add yourself using this email address. Go to our <a href="https://piazza.com/cs10k/other/bjcteachers" target="_blank" rel="noopener">BJC Teachers Forum</a>&nbsp;(<a href="https://piazza.com/cs10k/other/bjcteachers" target="_blank" rel="noopener">https://piazza.com/cs10k/other/bjcteachers/home</a>). Then enter the code <code>{{piazza_password}}</code> to get access. Please do not share this login information with anyone!</p>

    <p><strong>Snap<em>!</em></strong><br />We encourage you to check out the <a href="https://forum.snap.berkeley.edu'" target="_blank" rel="noopener">Snap<em>!</em> Forum</a>. If you have Snap<em>!</em>-specific questions, you can reach out to the Snap<em>!</em> team at <a href="mailto:contact@snap.berkeley.edu" target="_blank" rel="noopener">contact@snap.berkeley.edu</a>.</p>

    <p>Thank you! <br />&mdash; The BJC Team</p>
  WELCOME_EMAIL

  @form_submission = <<-FORM_SUBMISSION
    <p>
      Here is the information that was submitted: <br>
      Name: {{teacher_first_name}} {{teacher_last_name}} <br>
      Email: {{teacher_email}} <br>
      Snap Username: {{teacher_snap | link_to(teacher_snap, "https://snap.berkeley.edu/user?user=" + teacher_snap )}} <br>
      School: {{teacher_school_name}} <br>
      Location: {{teacher_school_city}}, {{teacher_school_state}} <br>
      Website: {{ teacher_school_website | link_to(nil, teacher_school_website) }}
    </p>
  FORM_SUBMISSION

  @deny_email = <<-DENY_EMAIL
    <p>
      {{ reason | strip_tags }}
    </p>
  DENY_EMAIL

  @request_info_email = <<-REQUEST_INFO_EMAIL
    <p>
      Here is an update to your application to BJC: <br>
      We need more information from you: <br>
      {{ reason | strip_tags }} <br>
      To update your application, please login to your account and update your application.
    </p>
  REQUEST_INFO_EMAIL

  def self.emails
    [
      {
        id: 1,
        body: @welcome_email,
        path: "teacher_mailer/welcome_email",
        locale: nil,
        handler: "liquid",
        partial: false,
        format: "html",
        title: "Welcome Email",
        subject: "Welcome to The Beauty and Joy of Computing!"
      },
      {
        id: 3,
        body: @form_submission,
        path: "teacher_mailer/form_submission",
        locale: nil,
        handler: "liquid",
        partial: false,
        format: "html",
        title: "Form Submission",
        subject: "Form Submission"
      },
      {
        id: 4,
        body: @deny_email,
        path: "teacher_mailer/deny_email",
        locale: nil,
        handler: "liquid",
        partial: false,
        format: "html",
        title: "Deny Email",
        subject: "Deny Email"
      },
      {
        id: 5,
        body: @request_info_email,
        path: "teacher_mailer/request_info_email",
        locale: nil,
        handler: "liquid",
        partial: false,
        format: "html",
        title: "Request Info Email",
        subject: "Request Info Email"
      }
    ]
  end

  def self.create_schools
    School.find_or_create_by(
      name: "UC Berkeley",
      city: "Berkeley",
      state: "CA",
      website: "https://bjc.berkeley.edu"
    )
  end

  def self.teachers
    [
        {
            first_name: "Michael",
            last_name: "Ball",
            email: "ball@berkeley.edu",
            admin: true,
            status: 0,
            application_status: "Validated",
            school: School.find_by(name: "UC Berkeley")
        },
        {
            first_name: "Lauren",
            last_name: "Mock",
            email: "lmock@berkeley.edu",
            admin: true,
            status: 0,
            application_status: "Validated",
            school: School.find_by(name: "UC Berkeley")
        }
    ]
  end
end
