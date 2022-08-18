# frozen_string_literal: true

require "rails_helper"

RSpec.describe MainController, type: :controller do
  fixtures :all
  describe "#index" do
    subject { get :index }

    it "should get to root" do
      expect(subject).to redirect_to(new_teacher_path)
    end
  end

  describe "dashboard" do
    before(:each) do
      @controller_stub = MainController.new
      @controller_stub.dashboard
    end

    it "counts correct number of validated (accepted) teachers" do
      # TODO: Create a non-validated admin teacher
      expect(@controller_stub.instance_variable_get(:@validated_teachers).size).to equal 0
    end

    it "shows correct course statistics" do
      # only validated (accepted) teachers are accounted for in statuses.
      statuses = @controller_stub.instance_variable_get(:@statuses)
      schools = @controller_stub.instance_variable_get(:@schools)
      expect(statuses.size).to equal 0
      expect(statuses["other"]).to be_nil
      expect(schools.size).to equal 1b
      expect(schools.find_by(name: "$tanfurd").name).to eq("$tanfurd")
    end
  end
end
