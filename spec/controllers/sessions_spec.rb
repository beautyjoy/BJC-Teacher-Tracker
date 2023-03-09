# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  fixtures :all

  describe "#destroy" do
    subject { delete :destroy }

    it "should get to root" do
      expect(subject).to redirect_to(root_path)
      expect(session[:logged_in]).to be_nil
      expect(session[:user_id]).to be_nil
    end
  end

  describe "#omniauth_callback" do
    fixtures :all

    let(:omniauth_data) { Teacher.find_by(first_name: "Short") }
    let(:provider) { "google_oauth2" }

    subject { get :omniauth_callback, params: { provider: provider } }

    it "should increase session count by 1 when teacher logs in" do
      SessionsController.any_instance.stub(:omniauth_info).and_return(omniauth_data)
      session_count = Teacher.find_by(first_name: "Short").session_count
      subject
      expect(Teacher.find_by(first_name: "Short").session_count).to eq(session_count + 1)
    end

    it "should append current ip address when teacher logs in" do
      SessionsController.any_instance.stub(:omniauth_info).and_return(omniauth_data)
      ip_addresses = Teacher.find_by(first_name: "Short").ip_history
      subject
      expect(Teacher.find_by(first_name: "Short").ip_history).to include(request.remote_ip)
    end
  end
end
