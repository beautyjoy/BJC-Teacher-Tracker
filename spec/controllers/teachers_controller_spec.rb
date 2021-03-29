require 'rails_helper'

RSpec.describe TeachersController, type: :controller do
    fixtures :all

    before(:each) do
        ApplicationController.any_instance.stub(:require_login).and_return(true)
    end

    it "able to deny an application" do
        ApplicationController.any_instance.stub(:require_admin).and_return(true)
        long_app = Teacher.find_by(first_name: "Short")
        post :deny, :params => { :id => long_app.id }
        long_app = Teacher.find_by(first_name: "Short")
        expect(long_app.display_application_status).to eq "Denied"
    end

    it "able to accept an application" do
        ApplicationController.any_instance.stub(:require_admin).and_return(true)
        long_app = Teacher.find_by(first_name: "Short")
        post :validate, :params => { :id => long_app.id }
        long_app = Teacher.find_by(first_name: "Short")
        expect(long_app.display_application_status).to eq "Validated"
    end

    it "doesn't allow teacher to change their snap or email" do
      ApplicationController.any_instance.stub(:require_edit_permission).and_return(true)
      ApplicationController.any_instance.stub(:is_admin?).and_return(false)
      ApplicationController.any_instance.stub(:current_user).and_return(Teacher.find_by(first_name: "Short"))
      short_app = Teacher.find_by(first_name: "Short")
      post :update, :params => { :id => short_app.id, :teacher => {:id => short_app.id, :email => "wrong@berkeley.edu"} }
      post :update, :params => { :id => short_app.id, :teacher => {:id => short_app.id, :snap => "wrong"} }
      short_app = Teacher.find_by(first_name: "Short")
      expect(short_app.email).to eq 'short@long.com'
      expect(short_app.snap).to eq 'song'
    end
end
