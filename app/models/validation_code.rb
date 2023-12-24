# encoding: utf-8
class ValidationCode < ApplicationRecord
  validates :email, presence: true
  validates :email, format: { with: /\A.+@.+\z/, message: "请输入正确的邮箱格式" }

  before_create :generate_code
  after_create :send_email

  # 枚举
  enum kind: { sign_in: 0, reset_password: 1 }

  def generate_code
    self.code = SecureRandom.random_number.to_s[2..7]
  end

  def send_email
    UserMailer.welcome_email(self.email).deliver
  end
end
