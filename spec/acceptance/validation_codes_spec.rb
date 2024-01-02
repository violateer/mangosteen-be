# encoding: utf-8
require "rails_helper"
require "rspec_api_documentation/dsl"

resource "验证码" do
  post "/api/v1/validation_codes" do
    parameter :email, type: :string
    parameter :kind, type: :string
    let(:email) { "1828257089@qq.com" }
    let(:kind) { "sign_in" }

    example "请求发送验证码" do
      expect(UserMailer).to receive(:welcome_email).with(email).and_call_original
      do_request
      expect(status).to eq 200
      expect(response_body).to eq " "
    end
  end
end
