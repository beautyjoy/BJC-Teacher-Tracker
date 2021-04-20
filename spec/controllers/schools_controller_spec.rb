require 'rails_helper'

RSpec.describe SchoolsController, type: :controller do
    fixtures :all

    before(:all) do
        @create_school_name = "University of California, Berkeley"
        @fail_flash_alert = /Failed to submit information :\(/
        @success_flash_alert = Regexp.new("Created #{@create_school_name} successfully.")
    end

    it "allows admin to create" do
        ApplicationController.any_instance.stub(:require_admin).and_return(true)
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
        assert_match(@success_flash_alert, flash[:success])
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
        ApplicationController.any_instance.stub(:require_admin).and_return(true)
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
        assert_match(@fail_flash_alert, flash[:alert])

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
        assert_match(@fail_flash_alert, flash[:alert])

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
        assert_match(@fail_flash_alert, flash[:alert])
    end

    it "requires proper inputs for fields" do
        ApplicationController.any_instance.stub(:require_admin).and_return(true)
        expect(School.find_by(name: @create_school_name)).to be_nil
        #Incorrect state (not chosen from enum list)
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
        assert_match(@fail_flash_alert, flash[:alert])

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
        assert_match(@fail_flash_alert, flash[:alert])
    end
end
