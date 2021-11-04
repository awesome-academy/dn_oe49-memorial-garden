class ContributionsController < ApplicationController
  before_action :logged_in_user

  def create
    @contribution = current_user.contributions.build(contribution_params)
    if @contribution.save
      flash.now[:success] = t("tribute.create.successed")
      path_js = "create_tribute_successed"
    else
      flash.now[:danger] = t("tribute.create.failed")
      path_js = "create_tribute_failed"
    end
    respond_to do |format|
      format.html{render "memorials/show"}
      format.js{render path_js}
    end
  end

  private

  def contribution_params
    params.require(:contribution)
          .permit(tribute_attributes: Tribute::ATR_PERMIT)
          .merge(memorial_id: params[:memorial_id],
            contribution_type: params[:contribution_type])
  end
end
