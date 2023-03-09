# frozen_string_literal: true

require "rails_helper"

RSpec.describe TeachersController, type: :controller do
  fixtures :all

  before(:each) do
    Rails.application.load_seed
    ApplicationController.any_instance.stub(:require_login).and_return(true)
  end

  it "able to deny an application" do
    ApplicationController.any_instance.stub(:require_admin).and_return(true)
    long_app = Teacher.find_by(first_name: "Short")
    post :deny, params: { id: long_app.id }
    long_app = Teacher.find_by(first_name: "Short")
    expect(long_app.display_application_status).to eq "Denied"
  end

  it "able to accept an application" do
    ApplicationController.any_instance.stub(:require_admin).and_return(true)
    long_app = Teacher.find_by(first_name: "Short")
    post :validate, params: { id: long_app.id }
    long_app = Teacher.find_by(first_name: "Short")
    expect(long_app.display_application_status).to eq "Validated"
  end

  it "able to delete an application" do
    ApplicationController.any_instance.stub(:require_admin).and_return(true)
    ApplicationController.any_instance.stub(:is_admin?).and_return(true)
    long_app = Teacher.find_by(first_name: "Short")
    delete :destroy, params: { id: long_app.id }
    expect(Teacher.find_by(first_name: "Short")).to be_nil
  end

  it "doesn't allow teacher to delete an application" do
    long_app = Teacher.find_by(first_name: "Short")
    delete :destroy, params: { id: long_app.id }
    expect(Teacher.find_by(first_name: "Short")).not_to be_nil
  end

  it "appends ip address when teacher update info for themselves without repetition" do
    ApplicationController.any_instance.stub(:is_admin?).and_return(false)
    ApplicationController.any_instance.stub(:current_user).and_return(Teacher.find_by(first_name: "Short"))
    short_app = Teacher.find_by(first_name: "Short")
    ip_count = short_app.ip_history.count()
    post :update, params: { id: short_app.id, teacher: { id: short_app.id, more_info: "changed", school_id: short_app.school_id } }
    short_app = Teacher.find_by(first_name: "Short")
    expect(short_app.more_info).to eq "changed"
    ip_count_now = short_app.ip_history.count()
    expect(ip_count_now).to eq ip_count + 1
    expect(short_app.ip_history.last).to eq request.remote_ip
    # now we post to update again (with the same ip address) and ip count shouldn't increase
    ip_count = ip_count_now
    post :update, params: { id: short_app.id, teacher: { id: short_app.id, more_info: "changed again", school_id: short_app.school_id } }
    short_app = Teacher.find_by(first_name: "Short")
    expect(short_app.more_info).to eq "changed again"
    ip_count_now = short_app.ip_history.count()
    expect(ip_count_now).to eq ip_count
    expect(short_app.ip_history.last).to eq request.remote_ip
  end

  it "doesn't appends ip address when admin updates teacher's info" do
    ApplicationController.any_instance.stub(:is_admin?).and_return(true)
    ApplicationController.any_instance.stub(:current_user).and_return(Teacher.find_by(first_name: "Short"))
    short_app = Teacher.find_by(first_name: "Short")
    ip_count = short_app.ip_history.count()
    post :update, params: { id: short_app.id, teacher: { id: short_app.id, snap: "foobar", school_id: short_app.school_id } }
    short_app = Teacher.find_by(first_name: "Short")
    expect(short_app.snap).to eq "foobar"
    expect(short_app.ip_history.count()).to eq ip_count
  end

  it "doesn't allow teacher to change their snap or email" do
    ApplicationController.any_instance.stub(:require_edit_permission).and_return(true)
    ApplicationController.any_instance.stub(:is_admin?).and_return(false)
    ApplicationController.any_instance.stub(:current_user).and_return(Teacher.find_by(first_name: "Short"))
    short_app = Teacher.find_by(first_name: "Short")
    post :update, params: { id: short_app.id, teacher: { id: short_app.id, email: "wrong@berkeley.edu", school_id: short_app.school_id } }
    post :update, params: { id: short_app.id, teacher: { id: short_app.id, snap: "wrong", school_id: short_app.school_id } }
    short_app = Teacher.find_by(first_name: "Short")
    expect(short_app.email).to eq "short@long.com"
    expect(short_app.snap).to eq "song"
  end

  it "resend a welcome_email for validated teacher" do
    ApplicationController.any_instance.stub(:current_user).and_return(Teacher.find_by(first_name: "Ye"))
    short_app = Teacher.find_by(first_name: "Ye")
    post :resend_welcome_email, params: { id: short_app.id }
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.subject).to eq "Welcome to The Beauty and Joy of Computing!"
  end

  it "denied and pending teacher can not request welcome email" do
    ApplicationController.any_instance.stub(:current_user).and_return(Teacher.find_by(first_name: "Bob"))
    bob_app = Teacher.find_by(first_name: "Bob")
    post :resend_welcome_email, params: { id: bob_app.id }
    expect(ActionMailer::Base.deliveries).to be_empty
    ApplicationController.any_instance.stub(:current_user).and_return(Teacher.find_by(first_name: "Short"))
    short_app = Teacher.find_by(first_name: "Short")
    post :resend_welcome_email, params: { id: short_app.id }
    expect(ActionMailer::Base.deliveries).to be_empty
  end
end
