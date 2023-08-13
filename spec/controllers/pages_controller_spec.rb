# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagesController, type: :request do
  fixtures :all

  let(:admin_teacher) { Teacher.where(admin: true).first }
  let(:validated_teacher) { Teacher.validated.first }

  before(:all) do
    @pages_slug = "basic_slug_1"
    @pages_title = "Test Page Title 1"
    @fail_flash_alert = /Failed to submit information :\(/
  end

  context "for an admin teacher" do
    before do
      log_in(admin_teacher)
    end

    it "#destroy successfully deletes a page" do
      Page.find_by(url_slug: "basic_slug")
      delete page_path("basic_slug")
      expect(Page.find_by(url_slug: "basic_slug")).to be_nil
    end

    describe "#create" do
      it "allows creating a valid page" do
        expect(Page.find_by(url_slug: "admin_create_test")).to be_nil
        post pages_path, params: {
          page: {
            url_slug: "admin_create_test",
            title: @pages_title,
            html: "<p>Test page body.</p>",
            viewer_permissions: "Admin",
          }
        }
        expect(Page.find_by(url_slug: "admin_create_test")).not_to be_nil
        expect(flash[:success]).to match(/Created #{@pages_title} page successfully./)
      end

      it "requires slug to create" do
        expect(Page.find_by(url_slug: @pages_slug)).to be_nil
        post pages_path, params: {
          page: {
            title: @pages_title,
            html: "<p>Test page body.</p>",
            viewer_permissions: "Admin",
          }
        }
        expect(flash[:alert]).to match(/URL slug/)
        expect(Page.find_by(url_slug: @pages_slug)).to be_nil
      end

      it "requires title to create" do
        expect(Page.find_by(url_slug: @pages_slug)).to be_nil
        post pages_path, params: {
          page: {
            url_slug: @pages_slug,
            html: "<p>Test page body.</p>",
            viewer_permissions: "Admin",
          }
        }
        expect(Page.find_by(url_slug: @pages_slug)).to be_nil
      end

      it "requires viewer permissions to create" do
        expect(Page.find_by(url_slug: @pages_slug)).to be_nil
        post pages_path, params: {
          page: {
            title: @pages_title,
            url_slug: @pages_slug,
            html: "<p>Test page body.</p>",
          }
        }
        expect(Page.find_by(url_slug: @pages_slug)).to be_nil
        expect(flash[:alert]).to match(/Viewer permissions/)
      end

      it "prevents submitting multiple pages with same slug" do
        expect(Page.find_by(url_slug: "basic_slug_2")).not_to be_nil
        post pages_path, params: {
          page: {
            url_slug: "basic_slug_2",
            title: "Test Page Title 2",
            html: "<p>Test page body.</p>",
            viewer_permissions: "Admin",
          }
        }
        expect(flash[:alert]).to include("URL slug")
      end
    end

    it "#edit allows updates" do
      thetest = Page.find_by(url_slug: "basic_slug")
      patch page_path(url_slug: thetest.url_slug), params: {
        page: {
          viewer_permissions: "Verified Teacher",
          title: "title",
          url_slug: thetest.url_slug,
          html: "Test content"
        }
      }
      thetest = Page.find_by(url_slug: "basic_slug")
      expect(thetest.title).to eq("title")
    end
  end

  describe "for a validated teacher" do
    before do
      log_in(validated_teacher)
    end

    it "#destroy doesn't allow teacher to delete a page" do
      delete page_path("basic_slug")
      expect(Page.find_by(url_slug: "basic_slug")).not_to be_nil
    end

    it "#create denies teacher to create" do
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
      post pages_path, params: {
        page: {
          url_slug: @pages_slug,
          title: @pages_title,
          html: "<p>Test page body.</p>",
          viewer_permissions: "Admin",
        }
      }
      expect(Page.find_by(url_slug: @pages_slug)).to be_nil
    end
  end

  describe "#index" do
    it "redirects to the default page" do
      expect(Page).to receive(:where)
      get "/pages"
      expect(response).to redirect_to page_path("about")
    end
  end
end
