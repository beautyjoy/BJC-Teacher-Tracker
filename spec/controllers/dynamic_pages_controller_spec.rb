# frozen_string_literal: true

require "rails_helper"

RSpec.describe DynamicPagesController, type: :controller do
  fixtures :all

  before(:all) do
    @dynamic_page_slug = "test_slug_1"
    @dynamic_page_title = "Test Page Title 1"
    @fail_flash_alert = /Failed to submit information :\(/
    @slug_exists_flash_alert = /That slug already exists :\(/
    @success_flash_alert = Regexp.new("Created #{@dynamic_page_title} page successfully.")
  end

  it "allows admin to create" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    post :create, {
        params: {
            dynamic_page: {
                slug: @dynamic_page_slug,
                title: @dynamic_page_title,
                body: "<p>Test page body.</p>",
                permissions: "Admin",
                creator_id: 0,
                last_editor: 0
            }
        }
    }
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).not_to be_nil
    expect(@success_flash_alert).to match flash[:success]
  end

  it "denies teacher to create" do
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    post :create, {
        params: {
          dynamic_page: {
            slug: @dynamic_page_slug,
            title: @dynamic_page_title,
            body: "<p>Test page body.</p>",
            permissions: "Admin",
            creator_id: 0,
            last_editor: 0
          }
        }
    }
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
  end

  it "requires slug to create" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    expect { post :create, {
        params: {
          dynamic_page: {
            title: @dynamic_page_title,
            body: "<p>Test page body.</p>",
            permissions: "Admin",
            creator_id: 0,
            last_editor: 0
          }
        }
      }
    }.to raise_error(ActionController::ParameterMissing)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
  end

  it "requires title to create" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    expect { post :create, {
        params: {
          dynamic_page: {
            slug: @dynamic_page_slug,
            body: "<p>Test page body.</p>",
            permissions: "Admin",
            creator_id: 0,
            last_editor: 0
          }
        }
      }
    }.to raise_error(ActionController::ParameterMissing)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
  end

  it "requires permissions to create" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    expect { post :create, {
        params: {
          dynamic_page: {
            title: @dynamic_page_title,
            slug: @dynamic_page_slug,
            body: "<p>Test page body.</p>",
            creator_id: 0,
            last_editor: 0
          }
        }
      }
    }.to raise_error(ActionController::ParameterMissing)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
  end

  it "requires creator_id to create" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    expect { post :create, {
        params: {
          dynamic_page: {
            title: @dynamic_page_title,
            slug: @dynamic_page_slug,
            body: "<p>Test page body.</p>",
            permissions: "Admin",
            last_editor: 0
          }
        }
      }
    }.to raise_error(ActionController::ParameterMissing)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
  end

  it "requires last_editor to create" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    expect { post :create, {
        params: {
          dynamic_page: {
            title: @dynamic_page_title,
            slug: @dynamic_page_slug,
            body: "<p>Test page body.</p>",
            permissions: "Admin",
            last_editor: 0
          }
        }
      }
    }.to raise_error(ActionController::ParameterMissing)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
  end

  it "prevents submitting multiple pages with same slug" do
    allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    post :create, {
        params: {
            dynamic_page: {
                slug: @dynamic_page_slug,
                title: @dynamic_page_title,
                body: "<p>Test page body.</p>",
                permissions: "Admin",
                creator_id: 0,
                last_editor: 0
            }
        }
    }
    expect(DynamicPage.find_by(slug: @dynamic_page_slug)).not_to be_nil
    expect(@success_flash_alert).to match flash[:success]

    post :create, {
        params: {
            dynamic_page: {
                slug: @dynamic_page_slug,
                title: @dynamic_page_title,
                body: "<p>Test page body.</p>",
                permissions: "Admin",
                creator_id: 0,
                last_editor: 0
            }
        }
    }
    expect(@slug_exists_flash_alert).to match flash[:alert]
  end
end
