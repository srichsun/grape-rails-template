# api/blogs.rb 所以慣例就是
# module API
#   class Blogs

module API
  class Blogs < Grape::API

    default_format :json

    #grape 裡面resources只是給命名空間/blogs，沒有自動生成路由
    # namespace, resource, group, segment 功能都一樣，給命名空間
    resources :blogs do

      # /blogs/3/comments
      route_param :id do
        resources :comments do
          get do
            " blog #{params[:id]} comments"
          end
        end
      end

      get do # 就是 get '/' /api/blogs
        {blogs: []}
      end

      # /api/blogs/2
      # 如果不對id做限制，下面blogs/hot永遠讀不到
      get ':id', requirements: { id: /\d+/} do
        "id #{params[:id]}"
      end

      # 在body的 form-data加key value就可以加表單數據
      post do
        "post #{params}"
      end

      put ':id' do
        "put #{params[:id]}"
      end

      # delete /api/blogs/4
      delete ':id' do
        "delete #{params[:id]}"
      end

      # blogs/hot/pop/3， /pop/3是可選參數，（）代表可有可無
      get 'hot(/pop/(:id))' do
        "hot #{params[:id]}"
      end
    end
  end
end
