class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.authenticate(params[:session][:password])
      flash[:success] = t("flash.login.successed")
      log_in @user
      redirect_to @user
    else
      flash.now[:danger] = t("flash.login.invalid_password")
      render :new
    end
  end

  def destroy
    flash[:success] = t("flash.logout")
    log_out
    redirect_to root_url
  end

  private

  def load_user
    @user = User.find_by(email: params[:session][:email].downcase)
    return if @user

    flash.now[:danger] = t("flash.login.invalid_email")
    render :new
  end
end
