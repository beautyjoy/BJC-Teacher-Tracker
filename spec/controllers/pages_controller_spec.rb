# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagesController, type: :controller do
  fixtures :all

  before(:all) do
    @pages_slug = "test_slug_1"
    @pages_title = "Test Page Title 1"
    @fail_flash_alert = /Failed to submit information :\(/
    @slug_exists_flash_alert = "An error occurred! [\"Slug has already been taken\"]"
    @success_flash_alert = Regexp.new("Created #{@pages_title} page successfully.")
  end

  describe "#index" do
    it "renders the index template" do
      expect(Page).to receive(:where)
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "#destroy" do
    it "successfully deletes a page" do
      ApplicationController.any_instance.stub(:require_admin).and_return(true)
      ApplicationController.any_instance.stub(:is_admin?).and_return(true)
      long_app = Page.find_by(slug: "Test_slug")
      delete :destroy, params: { slug: long_app.slug }
      expect(Page.find_by(slug: "Test_slug")).to be_nil
    end

    it "doesn't allow teacher to delete a page" do
      ApplicationController.any_instance.stub(:is_admin?).and_return(false)
      long_app = Page.find_by(slug: "Test_slug")
      delete :destroy, params: { slug: long_app.slug }
      expect(Page.find_by(slug: "Test_slug")).not_to be_nil
    end
  end

  describe "#create" do
    it "allows admin to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(slug: @pages_slug)).to be_nil
      post :create, {
          params: {
              page: {
                  slug: @pages_slug,
                  title: @pages_title,
                  html: "<p>Test page body.</p>",
                  permissions: "Admin",
              }
          },
          session: {
            user_id: 0
          }
      }
      expect(Page.find_by(slug: @pages_slug)).not_to be_nil
      expect(@success_flash_alert).to match flash[:success]
    end

    it "denies teacher to create" do
      expect(Page.find_by(slug: @pages_slug)).to be_nil
      post :create, {
          params: {
            page: {
              slug: @pages_slug,
              title: @pages_title,
              html: "<p>Test page body.</p>",
              permissions: "Admin",
            }
          },
          session: {
            user_id: 0
          }
      }
      expect(Page.find_by(slug: @pages_slug)).to be_nil
    end

    it "requires slug to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(slug: @pages_slug)).to be_nil
      post :create, {
        params: {
          page: {
            title: @pages_title,
            html: "<p>Test page body.</p>",
            permissions: "Admin",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(Page.find_by(slug: @pages_slug)).to be_nil
    end

    it "requires title to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(slug: @pages_slug)).to be_nil
      post :create, {
        params: {
          page: {
            slug: @pages_slug,
            html: "<p>Test page body.</p>",
            permissions: "Admin",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(Page.find_by(slug: @pages_slug)).to be_nil
    end

    it "requires permissions to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(slug: @pages_slug)).to be_nil
      post :create, {
        params: {
          page: {
            title: @pages_title,
            slug: @pages_slug,
            html: "<p>Test page body.</p>",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(Page.find_by(slug: @pages_slug)).to be_nil
    end

    it "prevents submitting multiple pages with same slug" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(slug: "test_slug_2")).not_to be_nil
      post :create, {
        params: {
          page: {
            slug: "test_slug_2",
            title: "Test Page Title 2",
            html: "<p>Test page body.</p>",
            permissions: "Admin",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(@slug_exists_flash_alert).to match flash[:alert]
    end
  end

  describe "#edit" do
    it "should allow admin to edit page" do
      ApplicationController.any_instance.stub(:require_admin).and_return(true)
      ApplicationController.any_instance.stub(:is_admin?).and_return(true)
      thetest = Page.find_by(slug: "Test_slug")
      post :update,
            params: {
              slug: thetest.slug,
              page: {
                permissions: "Verified Teacher",
                title: "title",
                slug: thetest.slug,
                html: 'Test content'
              }
            },
            session: { user_id: 0 }
      thetest = Page.find_by(slug: "Test_slug")
      expect(thetest.title).to eq("title")
    end
  end
end
