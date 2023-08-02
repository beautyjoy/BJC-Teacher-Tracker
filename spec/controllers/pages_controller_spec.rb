# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagesController, type: :request, focus: true do
  fixtures :all

  before(:all) do
    @pages_slug = "basic_slug_1"
    @pages_title = "Test Page Title 1"
    @fail_flash_alert = /Failed to submit information :\(/
    @success_flash_alert = Regexp.new("Created #{@pages_title} page successfully.")
  end

  describe "#index" do
    it "redirects to the default page" do
      expect(Page).to receive(:where)
      get '/pages'
      expect(response).to redirect_to page_path('about')
    end
  end

  describe "#destroy" do
    it "successfully deletes a page" do
      ApplicationController.any_instance.stub(:require_admin).and_return(true)
      ApplicationController.any_instance.stub(:is_admin?).and_return(true)
      long_app = Page.find_by(url_slug: "basic_slug")
      delete page_path("basic_slug")
      expect(Page.find_by(url_slug: "basic_slug")).to be_nil
    end

    it "doesn't allow teacher to delete a page" do
      ApplicationController.any_instance.stub(:is_admin?).and_return(false)
      long_app = Page.find_by(url_slug: "basic_slug")
      delete page_path(long_app.url_slug)
      expect(Page.find_by(url_slug: "basic_slug")).not_to be_nil
    end
  end

  describe "#create" do
    it "allows admin to create", :focus do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
      post page_path(@pages_slug), {
          params: {
              page: {
                  title: @pages_title,
                  html: "<p>Test page body.</p>",
                  viewer_permissions: "Admin",
              }
          },
          session: {
            user_id: 0
          }
      }
      expect(Page.find_by(url_slug: @pages_slug)).not_to be_nil
      expect(@success_flash_alert).to match flash[:success]
    end

    it "denies teacher to create" do
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
      post page_path, {
          params: {
            page: {
              url_slug: @pages_slug,
              title: @pages_title,
              html: "<p>Test page body.</p>",
              viewer_permissions: "Admin",
            }
          },
          session: {
            user_id: 0
          }
      }
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
    end

    it "requires slug to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
      post page_path, {
        params: {
          page: {
            title: @pages_title,
            html: "<p>Test page body.</p>",
            viewer_permissions: "Admin",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
    end

    it "requires title to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
      post :create, {
        params: {
          page: {
            url_slug: @pages_slug,
            html: "<p>Test page body.</p>",
            viewer_permissions: "Admin",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
    end

    it "requires permissions to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
      post :create, {
        params: {
          page: {
            title: @pages_title,
            url_slug: @pages_slug,
            html: "<p>Test page body.</p>",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
    end

    it "prevents submitting multiple pages with same slug" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(Page.find_by(url_slug: "basic_slug_2")).not_to be_nil
      post :create, {
        params: {
          page: {
            url_slug: "basic_slug_2",
            title: "Test Page Title 2",
            html: "<p>Test page body.</p>",
            viewer_permissions: "Admin",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(flash[:alert]).to include "URL slug"
    end
  end

  describe "#edit" do
    it "should allow admin to edit page" do
      ApplicationController.any_instance.stub(:require_admin).and_return(true)
      ApplicationController.any_instance.stub(:is_admin?).and_return(true)
      thetest = Page.find_by(url_slug: "basic_slug")
      post :update,
            params: {
              url_slug: thetest.url_slug,
              page: {
                viewer_permissions: "Verified Teacher",
                title: "title",
                url_slug: thetest.url_slug,
                html: "Test content"
              }
            },
            session: { user_id: 0 }
      thetest = Page.find_by(url_slug: "basic_slug")
      expect(thetest.title).to eq("title")
    end
  end
end
