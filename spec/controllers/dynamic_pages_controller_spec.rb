# frozen_string_literal: true

require "rails_helper"

RSpec.describe DynamicPagesController, type: :controller do
  fixtures :all

  before(:all) do
    @dynamic_page_slug = "test_slug_1"
    @dynamic_page_title = "Test Page Title 1"
    @fail_flash_alert = /Failed to submit information :\(/
    @slug_exists_flash_alert = "An error occurred! [\"Slug has already been taken\"]"
    @success_flash_alert = Regexp.new("Created #{@dynamic_page_title} page successfully.")
  end

  describe "#index" do
    it "renders the index template" do
      expect(DynamicPage).to receive(:where)
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "#delete" do
    it "deletes the page" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      id_to_delete = DynamicPage.find_by(slug: "test_slug_2").id
      expect(DynamicPage).to receive(:destroy)
      delete :delete, { params: { id: id_to_delete } }
      expect(response).to redirect_to(dynamic_pages_path)
    end

    it "able to delete a page" do
      ApplicationController.any_instance.stub(:require_admin).and_return(true)
      ApplicationController.any_instance.stub(:is_admin?).and_return(true)
      long_app = DynamicPage.find_by(slug: "Test_slug")
      post :delete, params: { id: long_app.id }
      expect(DynamicPage.find_by(slug: "Test_slug")).to be_nil
    end

    it "doesn't allow teacher to delete a page" do
      ApplicationController.any_instance.stub(:is_admin?).and_return(false)
      long_app = DynamicPage.find_by(slug: "Test_slug")
      post :delete, params: { id: long_app.id }
      expect(DynamicPage.find_by(slug: "Test_slug")).not_to be_nil
    end
  end

  describe "#create" do
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
              }
          },
          session: {
            user_id: 0
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
            }
          },
          session: {
            user_id: 0
          }
      }
      expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    end

    it "requires slug to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
      post :create, {
        params: {
          dynamic_page: {
            title: @dynamic_page_title,
            body: "<p>Test page body.</p>",
            permissions: "Admin",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    end

    it "requires title to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
      post :create, {
        params: {
          dynamic_page: {
            slug: @dynamic_page_slug,
            body: "<p>Test page body.</p>",
            permissions: "Admin",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    end

    it "requires permissions to create" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
      post :create, {
        params: {
          dynamic_page: {
            title: @dynamic_page_title,
            slug: @dynamic_page_slug,
            body: "<p>Test page body.</p>",
          }
        },
        session: {
          user_id: 0
        }
      }
      expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    end

    it "requires :user_id in session to assign creator_id and last_editor" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
      expect { post :create, {
          params: {
            dynamic_page: {
              title: @dynamic_page_title,
              slug: @dynamic_page_slug,
              body: "<p>Test page body.</p>",
              permissions: "Admin",
            }
          } # No user_id in the session
        }
      }.to raise_error(NoMethodError) # b/c current_user.id => null has no method id
      expect(DynamicPage.find_by(slug: @dynamic_page_slug)).to be_nil
    end

    it "prevents submitting multiple pages with same slug" do
      allow_any_instance_of(ApplicationController).to receive(:require_admin).and_return(true)
      expect(DynamicPage.find_by(slug: "test_slug_2")).not_to be_nil
      post :create, {
        params: {
          dynamic_page: {
            slug: "test_slug_2",
            title: "Test Page Title 2",
            body: "<p>Test page body.</p>",
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
      thetest = DynamicPage.find_by(slug: "Test_slug")
      post :update, params: { id: thetest.id, dynamic_page: { permissions: "Verified Teacher", title: "title", slug: thetest.slug, creator_id: 2, last_editor: 2 } }, session: { user_id: 2 }
      thetest = DynamicPage.find_by(slug: "Test_slug")
      expect(thetest.title).to eq("title")
    end
  end
end
