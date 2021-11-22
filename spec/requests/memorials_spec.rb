require 'rails_helper'
require "shared/share_examples"

RSpec.describe "Memorials", type: :request do
  let!(:memorial_1){create :memorial, name: "C"}
  let!(:memorial_2){create :memorial, name: "B"}
  let!(:memorial_3){create :memorial, name: "A"}
  let!(:user){create :user}

  describe "GET /index" do
    it "return memorials for guest mode" do
      get memorials_path
      expect(assigns(:memorials)).to eq [memorial_3, memorial_2, memorial_1]
    end
    it_should_behave_like "logged in user", :memorial, :index
    it_should_behave_like "load object in model for action", :memorial, :index
    it "return user's memorial in user mode" do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      get user_memorials_path(user_id: memorial_1.user.id)
      expect(assigns(:memorials)).to eq [memorial_1]
    end
  end

  describe "GET /show" do
    it_should_behave_like "load object in model for action", :memorial, :show
    it_should_behave_like "check authorize access privacy", :show

    context "already pass all before action" do
      let!(:contribution){create :contribution_with_tribute, user: user,
        memorial: memorial_1}
      it "return contribution, tribute, tributes if logged in" do
        post login_path,
          params: {session: {email: user.email, password: user.password}}
        get memorial_path(id: memorial_1.id)
        expect(assigns(:tribute).new_record? && assigns(:contribution)
          .new_record? && (assigns(:tributes) == [contribution.tribute]))
          .to eq true
      end
      it "return tributes and store request if not logged in" do
        get memorial_path(id: memorial_1.id)
        expect(assigns(:tributes) == [contribution.tribute] &&
          session[:forwarding_url] == request.original_url).to eq true
      end
    end
  end

  describe "GET /new" do
    it_should_behave_like "logged in user", :memorial, :new
    it "create new  memorial record" do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      get new_memorial_path, params: {name: "hai"}
      expect(assigns(:memorial).new_record?).to eq true
      expect(assigns(:memorial).placetimes.size).to eq 2
      expect(assigns(:memorial).name.eql? "hai").to eq true
    end
  end

  describe "POST /create" do
    let!(:memorial_attributes) do
      {name: Faker::Name.name_with_middle,
        user: user,
        relationship: "father"}
    end
    it_should_behave_like "logged in user", :memorial, :create
    it_should_behave_like "validate object", :memorial, :create
  end

  describe "GET /privacy_settings" do
    it_should_behave_like "logged in user", :memorial, :privacy_settings_for_get
    it_should_behave_like "load object in model for action", :memorial,
      :privacy_settings_for_get
    it_should_behave_like "authorize access", :memorial,
      :privacy_settings_for_get
    it "return list of shared member" do
      owner = memorial_1.user
      post login_path,
        params: {session: {email: owner.email, password: owner.password}}
      get privacy_settings_memorial_path(id: memorial_1.id)
      expect(assigns(:members)).to eq assigns(:memorial).shared_users
    end
  end

  describe "PATCH /privacy_settings" do
    it_should_behave_like "logged in user", :memorial,
      :privacy_settings_for_patch
    it_should_behave_like "load object in model for action", :memorial,
      :privacy_settings_for_patch
    it_should_behave_like "authorize access", :memorial,
      :privacy_settings_for_patch

    context "update privacy successed" do
      before do
        owner = memorial_1.user
        post login_path,
          params: {session: {email: owner.email, password: owner.password}}
        patch privacy_settings_memorial_path(id: memorial_1.id),
          params: {memorial: {privacy_type: :private}}
      end
      it "update privacy type" do
        expect(assigns(:memorial).privacy_type).to eq "private"
      end
      it "render privacy_settings" do
        expect(response).to render_template :privacy_settings
      end
    end

    context "update privacy failed" do
      before do
        owner = memorial_1.user
        post login_path,
          params: {session: {email: owner.email, password: owner.password}}
        patch privacy_settings_memorial_path(id: memorial_1.id),
          params: {memorial: {privacy_type: :unknow}}
      end
      it "display flash message" do
        expect(flash[:danger]).to eq I18n.t("memorial.update.failed")
      end
      it "render privacy_settings" do
        expect(response).to render_template :privacy_settings
      end
    end
  end

  describe "GET /search_unshared_member" do
    it_should_behave_like "logged in user", :memorial, :search_unshared_member
    it_should_behave_like "authorize access", :memorial, :search_unshared_member
    it "return list of shared member by name and email" do
        other_user = create(:user, name: "thanh", email: "thanh@gmail.com")
        owner = memorial_1.user
        post login_path,
          params: {session: {email: owner.email, password: owner.password}}
        get search_unshared_member_memorial_path(id: memorial_1.id),
          params: {query: "thanh"}, xhr: true
        expect(assigns(:users_by_name)).to eq [other_user]
        expect(assigns(:users_by_email)).to eq [other_user]
    end
  end


  describe "GET /show_biography" do
    it_should_behave_like "load object in model for action",
      :memorial, :show_biography
    it_should_behave_like "check authorize access privacy", :show_biography
  end
end
