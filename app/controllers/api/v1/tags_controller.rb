class Api::V1::TagsController < ApplicationController
  def index
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    tags = Tag.where(user_id: current_user.id)
              .page(params[:page])
              .per(params[:per])
    render json: {
      resources: tags,
      pager: {
        page: params[:page] || 1,
        per_page: Tag.default_per_page,
        count: Tag.count,
      },
    }
  end

  def create
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?

    tag = Tag.new user_id: current_user.id, name: params[:name], sign: params[:sign]
    if tag.save
      render json: { resource: tag }, status: :ok
    else
      render json: { errors: tag.errors }, status: :unprocessable_entity # 422
    end
  end
end
