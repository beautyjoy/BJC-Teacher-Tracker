# frozen_string_literal: true

require "rails_helper"

RSpec.describe TeachersController, type: :controller do
  fixtures :all
  it "rejects invalid signup information" do
    previous_count = Teacher.count
    post :create, {
        params: {
            school: {
                name: "invalid",
                city: "Berkeley",
                state: "CA",
                website: "invalid.com"
            },
            teacher: {
                first_name: "",
                last_name: "invalid",
                email: "invalid@invalid.edu",
                status: "invalid",
                snap: "invalid"
            }
        }
    }
    expect(Teacher.count).to eq(previous_count)
    assert_match(/An error occurred while trying to submit teacher information/, flash[:alert])
    assert_match(/First name can't be blank/, flash[:alert])
  end

  it "rejects invalid signup school information" do
    previous_count = Teacher.count
    post :create, {
        params: {
            school: {
                city: "Berkeley",
                state: "CA",
            },
            teacher: {
                first_name: "invalid",
                last_name: "invalid",
                email: "invalid@invalid.edu",
                status: "invalid",
                snap: "invalid"
            }
        }
    }
    expect(Teacher.count).to eq(previous_count)
    assert_match(/An error occurred/, flash[:alert])
    assert_match(/Name can't be blank/, flash[:alert])
  end

  it "accepts valid signup information" do
    previous_count = Teacher.count
    post :create, {
        params: {
            school: {
                name: "valid_example",
                city: "Berkeley",
                state: "CA",
                website: "valid_example.com"
            },
            teacher: {
                first_name: "valid_example",
                last_name: "valid_example",
                email: "valid_example@valid_example.edu",
                status: 0,
                snap: "valid_example"
            }
        }
    }
    expect(Teacher.count).to eq(previous_count + 1)
    assert_match(/Thanks for signing up for BJC/, flash[:success])
  end
end
