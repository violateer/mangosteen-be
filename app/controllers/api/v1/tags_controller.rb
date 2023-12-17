class Api::V1::TagsController < ApplicationController
  def index
    current_user = User.find request.env["current_user_id"]
    return render status 404 if current_user.nil?
    tags = Tag.where(user_id: current_user.id)
              .page(params[:page])
              .per(params[:per])
    render json: {
      resources: tags,
      pager: {
        page: params[:page] || 1,
        per_page: Item.default_per_page,
        count: Item.count,
      },
    }
  end
end
