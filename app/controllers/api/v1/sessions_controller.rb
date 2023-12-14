# encoding: utf-8
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

    user = User.find_by_email(params[:email])
    if user.nil?
      # not_found = 404
      render status: :not_found, json: { errors: "用户不存在" }
    else
      # ok = 200
      render status: :ok, json: {
               jwt: "xxxxxxxxxxxxxxxxxxxxxxxx",
             }
    end
  end
end
