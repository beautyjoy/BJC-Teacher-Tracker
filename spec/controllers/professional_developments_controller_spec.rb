# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ProfessionalDevelopments", type: :request do
  fixtures :all

  let(:admin_user) { teachers(:admin) }
  let(:regular_user) { teachers(:validated_teacher) }
  let(:valid_attributes) {
    {
      name: "Effective Teaching Strategies",
      city: "City",
      state: "State",
      country: "Country",
      start_date: Date.today,
      end_date: Date.tomorrow,
      grade_level: "university",
    }
  }
  let(:valid_attributes2) {
    {
      name: "PD2",
      city: "City",
      state: "State",
      country: "Country",
      start_date: Date.today,
      end_date: Date.tomorrow,
      grade_level: "university",
    }
  }
  let(:invalid_attributes) {
    {
      name: "",
      city: "",
      state: "",
      country: "",
      start_date: Date.tomorrow,
      end_date: Date.today - 1.day,
      grade_level: ""
    }
  }
  let!(:professional_development) { ProfessionalDevelopment.create!(valid_attributes) }

  shared_examples "admin access" do
    it "allows operation" do
      action
      expect(flash[:notice]).to match(/successfully/)
    end
  end

  shared_examples "regular user denied" do
    it "denies operation and redirects" do
      action
      expect(flash[:danger]).to be_present
    end
  end

  describe "CRUD operations" do
    describe "CREATE" do
      let(:action) { post professional_developments_path, params: { professional_development: valid_attributes2 } }

      context "as an admin" do
        before { log_in(admin_user) }
        include_examples "admin access"
      end

      context "as a regular user" do
        before { log_in(regular_user) }
        include_examples "regular user denied"
      end
    end

    describe "UPDATE" do
      context "with valid attributes" do
        let(:action) { patch professional_development_path(professional_development), params: { professional_development: { name: "Updated PD Name" } } }

        context "as an admin" do
          before { log_in(admin_user) }
          include_examples "admin access"
        end

        context "as a regular user" do
          before { log_in(regular_user) }
          include_examples "regular user denied"
        end
      end

      context "with invalid attributes" do
        let(:action) { patch professional_development_path(professional_development), params: { professional_development: invalid_attributes } }

        it "fails to update and re-renders edit for admin" do
          log_in(admin_user)
          action
          expect(response).to render_template(:edit)
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "DELETE" do
      let(:action) { delete professional_development_path(professional_development) }

      context "as an admin" do
        before { log_in(admin_user) }
        it "deletes the professional development" do
          expect { action }.to change(ProfessionalDevelopment, :count).by(-1)
          expect(response).to redirect_to(professional_developments_path)
          expect(flash[:notice]).to match(/deleted successfully/)
        end
      end

      context "as a regular user" do
        before { log_in(regular_user) }
        include_examples "regular user denied"
      end
    end
  end
end
