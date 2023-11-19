class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.page(params[:page]).per(params[:per])
    render json: { resources: items, pager: {
      page: params[:page] || 1,
      per_page: params[:per] || 10,
      count: Item.count,
    } }
  end

  def create
    item = Item.new amount: params[:amount]
    if item.save
      render json: { resource: item }
    else
      render json: { errors: item.errors }
    end
  end
end
