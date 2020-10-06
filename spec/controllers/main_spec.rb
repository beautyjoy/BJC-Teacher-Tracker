require "rails_helper"

RSpec.describe MainController, type: :controller do

  describe "#index" do
    subject { get :index }

    it "should get to root" do
      expect(subject).to redirect_to(new_teacher_path)
    end
  end
end
