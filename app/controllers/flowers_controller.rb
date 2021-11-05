class FlowersController < ApplicationController
  before_action ->{load :memorial, :memorial_id}

  def index
    @contribution = @memorial.contributions.build
    @flower = @contribution.build_flower
    @flowers = Flower.search_by_memorial(@memorial, :flower)
                     .includes(flower_detail: [image_attachment: :blob],
                        contribution: :user)
                     .newest.page(params[:page]).per(Settings.per_page.digit_3)
  end
end
