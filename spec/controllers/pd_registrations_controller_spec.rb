# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PdRegistrations", type: :request do
  fixtures :all

  let(:admin_user) { teachers(:admin) }
  let(:regular_user) { teachers(:validated_teacher) }
  let(:professional_development) { ProfessionalDevelopment.create!(name: "Effective Teaching Strategies", city: "City", state: "State", country: "Country", start_date: Date.today, end_date: Date.tomorrow, grade_level: "university") }
  let(:teacher1) { teachers(:bob) }
  let(:teacher2) { teachers(:long) }
  let(:valid_registration_attributes) {
    {
      teacher_id: teacher1.id,
      professional_development_id: professional_development.id,
      attended: true,
      role: "attendee"
    }
  }
  let(:valid_registration_attributes2) {
    {
      teacher_id: teacher2.id,
      professional_development_id: professional_development.id,
      attended: true,
      role: "attendee"
    }
  }
  let(:invalid_registration_attributes) {
    {
      teacher_id: nil,
      professional_development_id: nil,
      attended: false,
      role: ""
    }
  }
  let!(:pd_registration) { PdRegistration.create!(valid_registration_attributes) }

  shared_examples "admin access" do
    it "allows operation" do
      action
      expect(flash[:notice]).to match(/successfully/)
    end
  end

  shared_examples "regular user denied" do
    it "denies operation" do
      action
      expect(flash[:danger]).to be_present
    end
  end

  describe "CRUD operations for PD Registrations" do
    describe "CREATE" do
      let(:action) { post professional_development_pd_registrations_path(
                          professional_development_id: professional_development.id),
                          params: { pd_registration: valid_registration_attributes2 } }

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
        let(:action) { patch professional_development_pd_registration_path(
                               professional_development_id: professional_development.id, id: pd_registration.id),
                               params: { pd_registration: { role: "leader" } } }

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
        let(:action) { patch professional_development_pd_registration_path(
                                professional_development_id: professional_development.id, id: pd_registration.id),
                                params: { pd_registration: invalid_registration_attributes } }

        it "fails to update and redirects for admin" do
          log_in(admin_user)
          action
          expect(response).to render_template(:show)
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "DELETE" do
      let(:action) { delete professional_development_pd_registration_path(
                          professional_development_id: professional_development.id, id: pd_registration.id) }

      context "as an admin" do
        before { log_in(admin_user) }
        it "deletes the PD registration" do
          expect { action }.to change(PdRegistration, :count).by(-1)
          expect(response).to redirect_to(professional_development_path(professional_development))
          expect(flash[:notice]).to match(/successfully cancelled/)
        end
      end

      context "as a regular user" do
        before { log_in(regular_user) }
        include_examples "regular user denied"
      end
    end
  end
end
