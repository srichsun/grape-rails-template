Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount API::Blogs, at: '/api'
  # 把api/blogs.rb掛載到/api這個路徑
  # 所以當訪問 localhost:3000/api
  # 就是去跑 blogs.rb的 get '/' do
end
