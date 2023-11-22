FROM ruby:3.0.0

ENV RAILS_ENV production
RUN mkdir /mangosteen
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com
WORKDIR /mangosteen
ADD Gemfile /mangosteen
ADD Gemfile.lock /mangosteen
ADD vendor/cache /mangosteen/vendor/cache
RUN bundle config set --local without 'development test'
## 使用cache中的包安装 则 在 bundle install 后面加上 --local
RUN bundle install --local

ADD mangosteen-*.tar.gz ./
# docker run 时才会执行ENTRYPOINT
# docker build 不会执行ENTRYPOINT
ENTRYPOINT bundle exec puma