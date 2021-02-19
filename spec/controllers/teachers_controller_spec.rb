require 'rails_helper'

RSpec.describe TeachersController, type: :controller do
    fixtures :all
    
    before(:each) do
        ApplicationController.any_instance.stub(:is_admin?).and_return(@is_admin = true)
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
