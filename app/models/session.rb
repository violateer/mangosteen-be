# encoding: utf-8
class Session
  include ActiveModel::Model
  attr_accessor :email, :code
  validates :email, :code, presence: { message: "必填" }
  validates :email, format: { with: /\A.+@.+\z/, message: "请输入正确的邮箱格式" }

  validate :check_validation_code

  def check_validation_code
    return if Rails.env.test? and self.code == "123456"
    return if self.code.nil? or self.code.empty?
    self.errors.add :email, :notfound unless
      ValidationCode.exists? email: self.email, code: self.code, used_at: nil
  end
end
