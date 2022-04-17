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
                website: "www.berkeley.edu",
                school_type: 0,
                grade_level: 4,
                tags: [],
                nces_id: 123456789000
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
                website: "www.berkeley.edu",
                school_type: 0,
                grade_level: 4,
                tags: [],
                nces_id: 123456789000
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
                website: "www.berkeley.edu",
                school_type: 0,
                grade_level: 4,
                tags: [],
                nces_id: 123456789000
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
                school_type: 0,
                grade_level: 4,
                tags: [],
                nces_id: 123456789000
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
                website: "www.berkeley.edu",
                school_type: 0,
                grade_level: 4,
                tags: [],
                nces_id: 123456789000
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
                website: "www.berkeley.edu",
                school_type: 0,
                grade_level: 4,
                tags: [],
                nces_id: 123456789000
            }
        }
    }
    expect(School.find_by(name: @create_school_name)).to be_nil
    expect(@fail_flash_alert).to match flash[:alert]

    # Incorrect website format
    post :create, {
        params: {
            school: {
                name: @create_school_name,
                city: "Berkeley",
                state: "CA",
                website: "wwwberkeleyedu",
                school_type: 0,
                grade_level: 4,
                tags: [],
                nces_id: 123456789000
            }
        }
    }
    expect(School.find_by(name: @create_school_name)).to be_nil
    expect(@fail_flash_alert).to match flash[:alert]

    # Incorrect school type
    expect { post :create, {
            params: {
                school: {
                    name: @create_school_name,
                    city: "Berkeley",
                    state: "CA",
                    website: "www.berkeley.edu",
                    school_type: -1,
                    grade_level: 4,
                    tags: [],
                    nces_id: 123456789000
                }
            }
        }
    }.to raise_error(ArgumentError)
    expect(School.find_by(name: @create_school_name)).to be_nil

    # Incorrect grade_level
    expect { post :create, {
            params: {
                school: {
                    name: @create_school_name,
                    city: "Berkeley",
                    state: "CA",
                    website: "www.berkeley.edu",
                    school_type: 0,
                    grade_level: -4,
                    tags: [],
                    nces_id: 123456789000
                }
            }
        }
    }.to raise_error(ArgumentError)
    expect(School.find_by(name: @create_school_name)).to be_nil

    # Out of bounds nces_id
    expect { post :create, {
            params: {
                school: {
                    name: @create_school_name,
                    city: "Berkeley",
                    state: "CA",
                    website: "www.berkeley.edu",
                    school_type: 0,
                    grade_level: -4,
                    tags: [],
                    nces_id: 999999999999 + 1 # max val + 1
                }
            }
        }
    }.to raise_error(ArgumentError)
    expect(School.find_by(name: @create_school_name)).to be_nil

    expect { post :create, {
            params: {
                school: {
                    name: @create_school_name,
                    city: "Berkeley",
                    state: "CA",
                    website: "www.berkeley.edu",
                    school_type: 0,
                    grade_level: -4,
                    tags: [],
                    nces_id: 0 - 1 # min val - 1
                }
            }
        }
    }.to raise_error(ArgumentError)
    expect(School.find_by(name: @create_school_name)).to be_nil
  end
end
