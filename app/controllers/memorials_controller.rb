class MemorialsController < ApplicationController
  before_action :logged_in_user, :load_user, if: :user_mode?, only: :index

  def index
    @memorials = Memorial.includes(:placetimes).find_user(@user).by_name_asc
                         .page(params[:page]).per(Settings.per_page.digit_5)
  end

  private

  def user_mode?
    params[:user_id].present?
  end

  def load_user
    @user = User.find_by id: params[:user_id]
    return if @user

    flash[:danger] = t("flash.show.failed")
    redirect_to new_user_path
  end
end
