# frozen_string_literal: true

require "rails_helper"

RSpec.describe SchoolsController, type: :request do
  fixtures :all

  let(:admin_teacher) { teachers(:admin) }

  before(:all) do
    @create_school_name = "University of California, Berkeley"
    @fail_flash_error_text = "An error occurred: "
    @success_flash_alert = Regexp.new("Created #{@create_school_name} successfully.")
  end

  context "for a regular teacher" do
    it "denies teacher to create" do
      expect(School.find_by(name: @create_school_name)).to be_nil
      post schools_path, params: {
          school: {
              name: @create_school_name,
              city: "Berkeley",
              state: "CA",
              website: "www.berkeley.edu",
              school_type: "public",
              grade_level: "university",
              tags: [],
              nces_id: 123456789000
          }
      }
      expect(School.find_by(name: @create_school_name)).to be_nil
    end
  end

  context "for an admin" do
    before do
      log_in(admin_teacher)
    end

    it "allows admin to create" do
      expect(School.find_by(name: @create_school_name)).to be_nil
      post schools_path, params: {
          school: {
              name: @create_school_name,
              city: "Berkeley",
              country: "US",
              state: "CA",
              website: "www.berkeley.edu",
              school_type: "public",
              grade_level: "university",
              tags: [],
              nces_id: 123456789000
          }
      }
      expect(School.find_by(name: @create_school_name)).not_to be_nil
      expect(@success_flash_alert).to match flash[:success]
    end

    it "requires all fields filled" do
      expect(School.find_by(name: @create_school_name)).to be_nil
      post schools_path, params: {
        school: {
          name: @create_school_name,
          # missing city
          country: "US",
          state: "CA",
          website: "www.berkeley.edu",
          school_type: "public",
          grade_level: "university",
          tags: [],
          nces_id: 123456789000
        }
      }
      expect(School.find_by(name: @create_school_name)).to be_nil
      error = @fail_flash_error_text + "City can't be blank"
      expect(flash[:alert]).to match error

      post schools_path, params: {
        school: {
            name: @create_school_name,
            country: "US",
            city: "Berkeley",
            state: "CA",
            # missing website
            school_type: "public",
            grade_level: "university",
            tags: [],
            nces_id: 123456789000
        }
      }
      expect(School.find_by(name: @create_school_name)).to be_nil
      error = @fail_flash_error_text + "Website can't be blank, Website is invalid"
      expect(flash[:alert]).to match error

      post schools_path, params: {
        school: {
          # missing name
          country: "US",
          city: "Berkeley",
          state: "CA",
          website: "www.berkeley.edu",
          school_type: "public",
          grade_level: "university",
          tags: [],
          nces_id: 123456789000
        }
      }
      expect(School.find_by(name: @create_school_name)).to be_nil
      error = @fail_flash_error_text + "Name can't be blank"
      expect(flash[:alert]).to match error
    end

    it "requires proper inputs for fields" do
      expect(School.find_by(name: @create_school_name)).to be_nil
      # Incorrect state (not chosen from enum list)
      post schools_path, params: {
        school: {
          name: @create_school_name,
          country: "US",
          city: "Berkeley",
          state: "DISTRESS",
          website: "www.berkeley.edu",
          school_type: "public",
          grade_level: "university",
          tags: [],
          nces_id: 123456789000
        }
      }
      expect(School.find_by(name: @create_school_name)).to be_nil
      error = @fail_flash_error_text + "State is not included in the list"
      expect(flash[:alert]).to match error

      post schools_path, params: {
        school: {
          name: @create_school_name,
          country: "US",
          city: "Berkeley",
          state: "CA",
          website: "wwwberkeleyedu",
          school_type: "public",
          grade_level: "university",
          tags: [],
          nces_id: 123456789000
        }
      }
      expect(School.find_by(name: @create_school_name)).to be_nil
      error = @fail_flash_error_text + "Website is invalid"
      expect(flash[:alert]).to match error

      # Incorrect school type
      expect { post schools_path, params: {
        school: {
            name: @create_school_name,
            country: "US",
            city: "Berkeley",
            state: "CA",
            website: "www.berkeley.edu",
            school_type: -1,
            grade_level: "university",
            tags: [],
            nces_id: 123456789000
        }
    }
      }.to raise_error(ArgumentError)
      expect(School.find_by(name: @create_school_name)).to be_nil

      # Incorrect grade_level
      expect { post schools_path, {
              params: {
                  school: {
                      name: @create_school_name,
                      country: "US",
                      city: "Berkeley",
                      state: "CA",
                      website: "www.berkeley.edu",
                      school_type: "public",
                      grade_level: -4,
                      tags: [],
                      nces_id: 123456789000
                  }
              }
          }
      }.to raise_error(ArgumentError)
      expect(School.find_by(name: @create_school_name)).to be_nil
    end

    it "does not allow invalid country" do
      post schools_path, params: {
        school: {
          name: @create_school_name,
          city: "Test City",
          country: "XX", # invalid country
          state: "CA",
          website: "www.berkeley.edu",
          school_type: "public",
          grade_level: "university",
          tags: [],
          nces_id: 123456789000
        }
      }
      expect(School.find_by(name: @create_school_name)).to be_nil
      error = @fail_flash_error_text + "Country XX is not a valid country"
      expect(flash[:alert]).to match error
    end

    it "allows any state when country is not US" do
      post schools_path, params: {
        school: {
          name: @create_school_name,
          city: "Ottawa",
          country: "CA", # Canada
          state: "Ontario",
          website: "www.berkeley.edu",
          school_type: "public",
          grade_level: "university",
          tags: [],
          nces_id: 123456789000
        }
      }
      expect(School.find_by(name: @create_school_name)).not_to be_nil
      expect(@success_flash_alert).to match flash[:success]
    end

    it "does not create duplicate schools in the same city" do
      expect(School.where(name: @create_school_name).count).to eq 0

      post schools_path, params: {
        school: {
          name: @create_school_name,
          country: "US",
          city: "Berkeley",
          state: "CA",
          website: "www.berkeley.edu",
          school_type: "public",
          grade_level: "middle_school",
        }
      }
      expect(School.where(name: @create_school_name).count).to eq 1

      post schools_path, params: {
        school: {
          name: @create_school_name,
          country: "US",
          city: "Berkeley",
          state: "CA",
          website: "www.berkeley.edu",
          school_type: "public",
          grade_level: "university",
        }
      }
      expect(School.where(name: @create_school_name).count).to eq 1
    end
  end
end
