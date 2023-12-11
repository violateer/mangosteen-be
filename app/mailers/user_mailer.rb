class UserMailer < ApplicationMailer
  def welcome_email(code)
    @code = code
    mail(to: "1828257089@qq.com", subject: "Welcome to My Awesome Site")
  end
end
