require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  fixtures :all

  describe "#destroy" do
    subject { delete :destroy }

    it "should get to root" do
      expect(subject).to redirect_to(root_path)
      expect(session[:logged_in]).to be false
      expect(session[:user_id]).to be_nil
    end

  end
end
