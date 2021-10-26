class MemorialsController < ApplicationController
  before_action :logged_in_user, only: %i(new create index)
  before_action :load_user, only: :index

  def new
    @memorial = current_user.memorials.build
    @memorial.name = params[:name]
  end

  def create
    @memorial = current_user.memorials.build(memorial_params)
    @memorial.avatar.attach(params[:memorial][:avatar])
    if @memorial.save
      flash[:success] = t("memorial.create.successed")
      redirect_to root_url
    else
      flash.now[:danger] = t("memorial.create.failed")
      render :new
    end
  end

  def list
    @memorials = Memorial.includes(:placetimes).search(search_params).alphabet
                         .page(params[:page]).per(Settings.per_page.digit_5)
  end

  def index
    @user = User.find_by id: params[:user_id]
    @memorials = Memorial.includes(:placetimes).where(user_id: @user.id)
                         .search(search_params).alphabet
                         .page(params[:page]).per(Settings.per_page.digit_5)
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("flash.login.warning_user")
    redirect_to login_url
  end

  def load_user
    @user = User.find_by id: params[:user_id]
    return if @user

    flash[:danger] = t("flash.show.failed")
    redirect_to new_user_path
  end

  def memorial_params
    params.require(:memorial).permit(Memorial::ATR_PERMIT)
  end

  def search_params
    params.permit(:q).values[0]
  end
end
