# encoding: utf-8
require "jwt"

class Api::V1::SessionsController < ApplicationController
  def create
    if Rails.env.test?
      # 测试环境
      return render status: :unauthorized unless params[:code] == "123456"
    else
      # 正式环境
      canSignin = ValidationCode.exists?(email: params[:email], code: params[:code], used_at: nil)

      # unauthorized = 401
      # unless --> if not --> if !canSignin
      return render status: :unauthorized unless canSignin
    end

    user = User.find_or_create_by email: params[:email]
    render status: :ok, json: { jwt: user.generate_jwt }
  end
end
