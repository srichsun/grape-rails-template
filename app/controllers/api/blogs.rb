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
      desc "獲取blog詳情"
      params do
        requires :id, type: Integer
      end
      get ':id', requirements: { id: /\d+/} do# 如果不對id做限制，下面blogs/hot永遠讀不到
        "id #{params[:id]}"
      end

      desc "create a blog" # desc 用來生成文檔用
      params do # 定義params，當post下面時，會檢查是不是符合這邊條件
        requires :title, type: String, desc: "博客标题" # requires表示必要參數
        requires :content, type: String, desc: "博客内容", as: :body

        optional :tags, type: Array, desc: "博客标签", allow_blank: false # optional表示可選參數
        optional :state, type: Symbol, default: :pending, values: [:pending, :done]
        # 參數其實只有string，symbol是說grape會幫轉為symbol
        # 當沒傳值就用default的值
        # values表示進來的值只能是這些

        optional :meta_name, type: { value: String, message: "meta_name比必须为字符串" },
        regexp: /^s\-/
        # 當校驗不是string，返回message，方便做i18n用的
        # 如果type過了，還要檢查是不是符合regexp
        # 如果想要對regexp做i18n，可寫成 regexp: { value: /^s\-/, message: '不合法' }

        optional :cover, type: File
        given :cover do #given表示如果cover有提供值
          requires :weight, type: Integer, values: { value: ->(v) { v >= -1 }, message: "weight必须大于等于-1" } #自定義proc來檢查
        end

        # 一個array，裡面都是hash
        optional :comments, type: Array do
          requires :content, type: String, allow_blank: false # 代表array裡面每一個object都要有content這個參數
        end

        optional :category, type: Hash do
          requires :id, type: Integer
        end
      end
      post do
        params
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
