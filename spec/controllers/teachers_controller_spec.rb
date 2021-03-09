require 'rails_helper'

RSpec.describe TeachersController, type: :controller do
    fixtures :all

    before(:each) do
        ApplicationController.any_instance.stub(:require_admin).and_return(true)
        ApplicationController.any_instance.stub(:require_login).and_return(true)
    end

    it "able to deny an application" do
        long_app = Teacher.find_by(first_name: "Short")
        post :deny, :params => { :id => long_app.id }
        long_app = Teacher.find_by(first_name: "Short")
        expect(long_app.display_application_status).to eq "Denied"
    end

    it "able to accept an application" do
        long_app = Teacher.find_by(first_name: "Short")
        post :validate, :params => { :id => long_app.id }
        long_app = Teacher.find_by(first_name: "Short")
        expect(long_app.display_application_status).to eq "Validated"
    end
end
