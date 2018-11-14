Rails.application.routes.draw do

  mount API::Base, at: '/api' # 因為base.rb是所有API入口，要改成API::Base
  # 把api/blogs.rb掛載到/api這個路徑
  # 所以當訪問 localhost:3000/api
  # 就是去跑 blogs.rb的 get '/' do

  mount GrapeSwaggerRails::Engine => '/api/doc'
end
