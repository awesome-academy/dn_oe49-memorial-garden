class MemorialsController < ApplicationController
  before_action only: :index, if: :user_mode? do
    logged_in_user
    load :user, :user_id
  end
  before_action :logged_in_user, only: %i(new create privacy_settings
                                          search_unshared_member)
  before_action ->{load :memorial, :id},
                only: %i(show privacy_settings
                         search_unshared_member show_biography)
  before_action :check_authorize_access, only: %i(show show_biography)
  before_action ->{correct_user @memorial.user},
                only: %i(privacy_settings search_unshared_member)

  def index
    @memorials = Memorial.includes(:placetimes, :avatar_attachment)
                         .type_of_index(@user)
                         .search_by(:name, search_params).by_name_asc
                         .page(params[:page]).per(Settings.per_page.digit_5)
  end

  def show
    if logged_in?
      @contribution = @memorial.contributions
                               .build(user_id: current_user.id,
                                  contribution_type: :tribute)
      @tribute = @contribution.build_tribute
    else
      store_location
    end
    @tributes = Tribute.search_by_memorial(@memorial, :tribute)
                       .includes(contribution: :user).newest
                       .page(params[:page]).per(Settings.per_page.digit_3)
  end

  def new
    @memorial = current_user.memorials.build
    @memorial.build_placetimes
    @memorial.name = params[:name]
  end

  def create
    build_memorial_through_params
    if @memorial.save
      flash[:success] = t("memorial.create.successed")
      redirect_to @memorial
    else
      flash.now[:danger] = t("memorial.create.failed")
      respond_to do |format|
        format.html{render :new}
        format.js{render :create}
      end
    end
  end

  def privacy_settings
    @members = @memorial.shared_users
                        .includes(:memorial_relations, avatar_attachment: :blob)
    return if params[:memorial].blank?

    begin
      @memorial.update(privacy_params)
      flash.now[:success] = t("memorial.update.successed")
    rescue ArgumentError
      flash.now[:danger] = t("memorial.update.failed")
    end
    respond_to do |format|
      format.html{render "privacy_settings"}
      format.js
    end
  end

  def search_unshared_member
    @users_by_name = User.unshared_member(@memorial)
                         .search_by(:name, search_params)
    @users_by_email = User.unshared_member(@memorial)
                          .search_by(:email, search_params)
    respond_to do |format|
      format.json {}
    end
  end

  def show_biography; end

  private

  def build_memorial_through_params
    @memorial = current_user.memorials.build(memorial_params)
    avatar = params[:memorial][:avatar]
    @memorial.avatar.attach(avatar) if avatar.present?
  end

  def user_mode?
    able = params[:user_id].present?
    @title = t("memorial.#{able ? 'title' : 'hall'}")
    able
  end

  def search_params
    params.permit(:query).values.pop
  end

  def memorial_params
    params.require(:memorial)
          .permit(Memorial::ATR_PERMIT,
                  placetimes_attributes: Placetime::ATR_PERMIT)
  end

  def privacy_params
    params.require(:memorial).permit(:privacy_type)
  end

  def check_authorize_access
    return if current_user? @memorial.user

    case @memorial.privacy_type
    when "private"
      correct_user @memorial.user
    when "shared"
      correct_member
    end
  end
end
