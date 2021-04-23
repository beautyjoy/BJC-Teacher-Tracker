module SeedData
  @welcome_email = %Q(
    <p>
      Hi {{teacher_first_name}},<br><br>
      Thanks for teaching with BJC!<br>
    </p>
    <p>
      <b>Accessing the teacher's guide:</b><br>

      To view the teacher's {{"guide" | link_to("guide", "https://bjc.edc.org/teacher")}}, you will need the username: <code>bjcteacher</code> and the case-sensitive password: <code>{{bjc_password}}</code><br>
      <br>
      After you enter the password once it will be stored in a cookie for that browser; if you delete your browser cookies, you will need to reenter it. If you use this password on a computer that students also use, they will have access to these pages until you clear the cookies. <br>
      <br>
      Please note that only the Teacher Guide <em>solutions</em> pages are affected by this. Students will still be able to see the Teacher Guide course overview page, the Teacher Resources page, and the Teacher Guide unit overview pages.
    </p>
    <p>
      <b>Piazza:</b>
      <br>
      We have a teacher's forum on {{"Piazza" | link_to('Piazza', 'https://piazza.com' ) }}, where we will share updates and you can get your questions answered. If you have not been added to Piazza, you can add yourself using this email address. Go to our {{'BJC Teachers Forum' | link_to('BJC Teachers Forum', 'https://piazza.com/cs10k/other/bjcteachers') }}: https://piazza.com/cs10k/other/bjcteachers/home. Then enter the code <code>{{piazza_password}}</code> to get access. Please do not share this login information with anyone!
      <br>
    </p>
    <p>
      <b>Snap<em>!</em></b><br>

      We encourage you to check out the {{'Snap! Forum' | link_to('Snap! Forum', 'https://forum.snap.berkeley.edu') }}. If you have Snap<em>!</em>-specific questions, you can reach out to the Snap<em>!</em> team at {{"contact@snap.berkeley.edu" | mail_to('contact@snap.berkeley.edu')}}.
    </p>
    <p>
      Thank you!
      <br>
      — The BJC Team
    </p>
  )
  @teals_confirmation_email = %Q(
    <p>
      Hi,<br><br>

      Can you please verify that {{teacher_first_name}} {{teacher_last_name}} is a TEALS Volunteer?<br>
      They have signed up to access the BJC Teacher Solutions with the following details:<br>
      Name: {{teacher_first_name}} {{teacher_last_name}} <br>
      Email: {{teacher_email}}<br>
      School: {{teacher_school_name}}<br>
      More Info: {{teacher_more_info}}<br><br>

      Thank You,<br>
      - The BJC Team
    </p>
  )
  @form_submission = %Q(
    <p>
      Here is the information that was submitted: <br>
      Name: {{teacher_first_name}} {{teacher_last_name}} <br>
      Email: {{teacher_email}} <br>
      Snap Username: {{teacher_snap | link_to(teacher_snap, "https://snap.berkeley.edu/user?user=" + teacher_snap )}} <br>
      School: {{teacher_school_name}} <br>
      Location: {{teacher_school_city}}, {{teacher_school_state}} <br>
      Website: {{ teacher_school_website | link_to(nil, teacher_school_website) }}
    </p>
  )
  @deny_email = %Q(
    <p>
      {{ reason | strip_tags }}
    </p>
  )
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
        id: 2,
        body: @teals_confirmation_email,
        path: "teacher_mailer/teals_confirmation_email",
        locale: nil,
        handler: "liquid",
        partial: false,
        format: "html",
        title: "TEALS Confirmation Email",
        subject: "TEALS Confirmation Email"
      },
      {
        id: 3,
        body: @form_submission,
        path: "teacher_mailer/form_submission",
        locale: nil,
        handler: "liquid",
        partial: false,
        format: "html",
        title: "Form Submission Email",
        subject: "Form Submission Email"
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
      }
    ]

  end

  def self.teachers
      [
          {
              first_name: 'Michael',
              last_name: 'Ball',
              email: 'michael.ball@berkeley.edu',
              admin: true,
              status: 0,
              application_status: 'Validated'
          },

          {
              first_name: 'Christopher',
              last_name: 'Hou',
              email: 'chris.hou@berkeley.edu',
              admin: true,
              status: 0,
              application_status: 'Validated'
          },

          {
              first_name: 'Justin',
              last_name: 'Phyo',
              email: 'justinphyo@berkeley.edu',
              admin: true,
              status: 0,
              application_status: 'Validated'
          },

          {
              first_name: 'Richard',
              last_name: 'Liu',
              email: 'richardliu2000@berkeley.edu',
              admin: true,
              status: 0,
              application_status: 'Validated'
          },

          {
              first_name: 'Tommy',
              last_name: 'Wei',
              email: 'tommywei110@berkeley.edu',
              admin: true,
              status: 0,
              application_status: 'Validated'
          },

          {
              first_name: 'Steven',
              last_name: 'Yu',
              email: 'steven.yu@berkeley.edu',
              admin: true,
              status: 0,
              application_status: 'Validated'
          },

          {
              first_name: 'Long',
              last_name: 'Tong',
              email: 'longhtong@berkeley.edu',
              admin: true,
              status: 0,
              application_status: 'Validated'
          }
      ]
  end
end
