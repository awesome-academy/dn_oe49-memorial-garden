class MemorialsController < ApplicationController
  before_action only: :index, if: :user_mode? do
    logged_in_user
    load :user
  end
  before_action :logged_in_user, only: %i(new create)
  before_action ->{load :memorial}, only: :show

  def index
    @memorials = Memorial.includes(:placetimes).find_user(@user)
                         .search_by_name(search_params).by_name_asc
                         .page(params[:page]).per(Settings.per_page.digit_5)
  end

  def show; end

  def new
    @memorial = current_user.memorials.build
    @memorial.build_placetimes
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

  private

  def user_mode?
    able = params[:user_id].present?
    @title = t("memorial.#{able ? 'title' : 'hall'}")
    able
  end

  def load name
    model = name.to_s.capitalize.constantize
    id = name.eql?(:memorial) ? :id : "#{name}_id"
    return if instance_variable_set("@#{name}", model.find_by(id: params[id]))

    flash[:danger] = t("flash.show.#{name}.failed")
    redirect_to root_path
  end

  def search_params
    params.permit(:query).values.pop
  end

  def memorial_params
    params.require(:memorial)
          .permit(Memorial::ATR_PERMIT,
                  placetimes_attributes: Placetime::ATR_PERMIT)
  end
end
