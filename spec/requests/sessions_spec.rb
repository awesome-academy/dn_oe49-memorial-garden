require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user){create :user}
  describe "POST /create" do

    context "email isn't valid" do
      before do
        post login_path,
          params: {session: {email: "thanh", password: ""}}
      end
      it "display flash message" do
        expect(flash.now[:danger]).to eq I18n.t("flash.login.invalid_email")
      end
      it "render new" do
        expect(response).to render_template :new
      end
    end

    context "password isn't valid" do
      before do
        post login_path,
          params: {session: {email: user.email, password: ""}}
      end
      it "display flash message" do
        expect(flash.now[:danger]).to eq I18n.t("flash.login.invalid_password")
      end
      it "render new" do
        expect(response).to render_template :new
      end
    end

    context "user's valid" do
      before do
        post login_path,
          params: {session: {email: user.email, password: user.password}}
      end
      it "login" do
        expect(session[:user_id]).to eq assigns(:user).id
      end
      it "display flash message" do
        expect(flash[:success]).to eq I18n.t("flash.login.successed")
      end
      it "redirect to user's page" do
        should redirect_to(assigns(:user))
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      delete logout_path
    end
    it "logout" do
      expect(session[:user_id]).to eq nil
      expect(assigns(:current_user)).to eq nil
    end
    it "display flash message" do
      expect(flash[:success]).to eq I18n.t("flash.logout")
    end
    it "redirect to user's page" do
      should redirect_to(root_url)
    end
  end
end
