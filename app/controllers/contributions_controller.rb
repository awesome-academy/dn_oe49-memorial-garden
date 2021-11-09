class ContributionsController < ApplicationController
  before_action :logged_in_user
  before_action ->{load :memorial, :memorial_id}
  before_action ->{load :contribution, :id}, only: %i(edit update destroy)
  before_action ->{correct_user @contribution.user}, unless: :owner?,
                only: %i(edit update destroy)

  def create
    @contribution = current_user.contributions.build(contribution_params)
    case @contribution.contribution_type
    when "tribute"
      save_depend_type :tribute
    when "flower"
      save_depend_type :flower
    end
  end

  def edit
    respond_to do |format|
      format.html{render "memorials/show"}
      format.js{render "create_tribute_failed"}
    end
  end

  def update
    if @contribution.update(contribution_params)
      flash.now[:success] = t("tribute.update.successed")
      path_js = "create_tribute_successed"
    else
      flash.now[:danger] = t("tribute.update.failed")
      path_js = "create_tribute_failed"
    end
    respond_to do |format|
      format.html{render "memorials/show"}
      format.js{render path_js}
    end
  end

  def destroy
    if @contribution.destroy
      flash[:success] = t("tribute.destroy.successed")
    else
      flash[:danger] = t("tribute.destroy.failed")
    end
    redirect_to @memorial
  end

  private

  def contribution_params
    params.require(:contribution)
          .permit(tribute_attributes: Tribute::ATR_PERMIT,
                  flower_attributes: Flower::ATR_PERMIT)
          .merge(memorial_id: params[:memorial_id],
            contribution_type: params[:contribution_type])
  end

  def owner?
    @contribution.memorial.user.eql?(current_user)
  end

  def save_depend_type type
    if @contribution.save
      flash.now[:success] = t("#{type}.create.successed")
      path_js = "create_#{type}_successed"
    else
      flash.now[:danger] = t("#{type}.create.failed")
      path_js = "create_#{type}_failed"
    end
    respond_to do |format|
      format.js{render path_js}
    end
  end
end
