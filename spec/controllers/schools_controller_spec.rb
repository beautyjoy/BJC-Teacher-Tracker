# frozen_string_literal: true

require "rails_helper"

RSpec.describe SchoolsController, type: :controller do
  fixtures :all

  before(:all) do
    @create_school_name = "University of California, Berkeley"
    @fail_flash_alert = /Failed to submit information :\(/
    @success_flash_alert = Regexp.new("Created #{@create_school_name} successfully.")
  end

  it "allows admin to create" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(School.find_by(name: @create_school_name)).to be_nil
    post :create, {
        params: {
            school: {
                name: @create_school_name,
                city: "Berkeley",
                state: "CA",
                website: "www.berkeley.edu"
            }
        }
    }
    expect(School.find_by(name: @create_school_name)).not_to be_nil
    expect(@success_flash_alert).to match flash[:success]
  end

  it "denies teacher to create" do
    expect(School.find_by(name: @create_school_name)).to be_nil
    post :create, {
        params: {
            school: {
                name: @create_school_name,
                city: "Berkeley",
                state: "CA",
                website: "www.berkeley.edu"
            }
        }
    }
    expect(School.find_by(name: @create_school_name)).to be_nil
  end

  it "requires all fields filled" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(School.find_by(name: @create_school_name)).to be_nil
    post :create, {
        params: {
            school: {
                name: @create_school_name,
                state: "CA",
                website: "www.berkeley.edu"
            }
        }
    }
    expect(School.find_by(name: @create_school_name)).to be_nil
    expect(@fail_flash_alert).to match flash[:alert]

    post :create, {
        params: {
            school: {
                name: @create_school_name,
                city: "Berkeley",
                state: "CA",
            }
        }
    }
    expect(School.find_by(name: @create_school_name)).to be_nil
    expect(@fail_flash_alert).to match flash[:alert]

    post :create, {
        params: {
            school: {
                city: "Berkeley",
                state: "CA",
                website: "www.berkeley.edu"
            }
        }
    }
    expect(School.find_by(name: @create_school_name)).to be_nil
    expect(@fail_flash_alert).to match flash[:alert]
  end

  it "requires proper inputs for fields" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(School.find_by(name: @create_school_name)).to be_nil
    # Incorrect state (not chosen from enum list)
    post :create, {
        params: {
            school: {
                name: @create_school_name,
                city: "Berkeley",
                state: "DISTRESS",
                website: "www.berkeley.edu"
            }
        }
    }
    expect(School.find_by(name: @create_school_name)).to be_nil
    expect(@fail_flash_alert).to match flash[:alert]

    post :create, {
        params: {
            school: {
                name: @create_school_name,
                city: "Berkeley",
                state: "CA",
                website: "wwwberkeleyedu"
            }
        }
    }
    expect(School.find_by(name: @create_school_name)).to be_nil
    expect(@fail_flash_alert).to match flash[:alert]
  end

  it "doesnt creation of the same school" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    post :create, {
        params: {
            school: {
                name: @create_school_name,
                city: "Berkeley",
                state: "CA",
                website: "www.berkeley.edu"
            }
        }
    }
    expect(School.where(name: @create_school_name).count).to be 1
    post :create, {
        params: {
            school: {
                name: @create_school_name,
                city: "Berkeley",
                state: "CA",
                website: "www.berkeley.edu"
            }
        }
    }
    expect(School.where(name: @create_school_name).count).to be 1
  end
end
