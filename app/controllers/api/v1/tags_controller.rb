class Api::V1::TagsController < ApplicationController
  def index
    current_user = User.find request.env["current_user_id"]
    return render status :unauthorized if current_user.nil?
    tags = Tag.where(user_id: current_user.id, deleted_at: nil)
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

  def show
    tags = Tag.where(id: params[:id], deleted_at: nil)
    return render status: :not_found if tags.empty?
    return render status: :forbidden unless tags[0].user_id == request.env["current_user_id"]
    render json: {
      resource: tags[0],
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

  def update
    tag = Tag.find params[:id]

    #params.permit 取非空值
    tag.update params.permit(:name, :sign)

    if tag.errors.empty?
      render json: { resource: tag }, status: :ok
    else
      render json: { errors: tag.errors }, status: :unprocessable_entity # 422
    end
  end

  def destroy
    tag = Tag.find params[:id]
    return render status: :forbidden unless tag.user_id == request.env["current_user_id"]
    tag.deleted_at = Time.now
    if tag.save
      render json: { resource: tag }, status: :ok
    else
      render json: { errors: tag.errors }, status: :unprocessable_entity # 422
    end
  end
end
