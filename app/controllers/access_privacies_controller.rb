class AccessPrivaciesController < ApplicationController
  before_action :logged_in_user
  before_action only: :create do
    load :memorial, :memorial_id
    load_user_by_email params[:access_privacy][:query]
  end
  before_action :load_access_privacy, only: :destroy
  before_action :authorize_user
  def create
    implement :share
  end

  def destroy
    implement :unshare
  end

  private

  def load_access_privacy
    @memorial = AccessPrivacy.find_by(id: params[:id]).memorial
    @user = AccessPrivacy.find_by(id: params[:id]).user
    return if @memorial && @user

    flash[:danger] = t("flash.show.memorial.invalid_privacy")
    redirect_to root_url
  end

  def implement action
    @members = @memorial.shared_users
    @memorial.send(action.to_s, @user)
    flash.now[:success] = t("flash.#{action}.successed")
    respond_to do |format|
      format.html{render "memorials/privacy_settings"}
      format.js
    end
  end

  def authorize_user
    return if @memorial.user_id.eql? current_user.id

    flash[:danger] = t("flash.show.memorial.invalid_authorized")
    redirect_to root_url
  end
end
