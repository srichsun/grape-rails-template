# api/blogs.rb 所以慣例就是
# module API
#   class Blogs

module API
  class Blogs < Grape::API

    default_format :json

    # Grape的helper是說讓下面API的block可以用
    helpers do
      # 默認接收兩個參數code: 0 代表成功，1代表失敗, data代表API有意義返回值
      def build_response code: 0, data: nil
        { code: code, data: data }
      end

      params :id_validator do
        requires :id, type: Integer
      end
      # params :id_validator do |options| 以可以像這樣接收參數
      # use :id_validator, a: 1 像這樣傳一個hash進去
    end

    # grape 裡面resources只是給命名空間/blogs，沒有自動生成路由
    # namespace, resource, group, segment 功能都一樣，給命名空間
    resources :blogs do

      # /blogs/3/comments
      route_param :id do
        resources :comments do
          get do
            build_response(data: " blog #{params[:id]} comments")
          end
        end
      end

      get do # 就是 get '/' /api/blogs
        build_response(data: {blogs: []})
      end

      # /api/blogs/2
      desc "獲取blog詳情"
      params do
        use :id_validator
      end
      get ':id', requirements: { id: /\d+/} do# 如果不對id做限制，下面blogs/hot永遠讀不到
        build_response(data: "id #{params[:id]}")
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

      # 在body的 form-data加key value就可以加表單數據
      post do
        build_response(data: "post #{params}")
      end

      desc 'blog修改'
      params do
        use :id_validator
      end

      put ':id' do
        build_response(data: "put #{params[:id]}")
      end

      desc 'blog刪除'
      params do
        use :id_validator
      end

      # delete /api/blogs/4
      delete ':id' do
        build_response(data: "delete #{params[:id]}")
      end

      # blogs/hot/pop/3， /pop/3是可選參數，（）代表可有可無
      get 'hot(/pop/(:id))' do
        build_response(data: "hot #{params[:id]}")
      end

      get 'latest' do
        redirect '/api/blogs/popular' #redirect會把path返回瀏覽器，要給完整URL，前面杳有/api/
      end

      get 'popular' do
        status 400 #POSTMAN 就會看到status 400
        build_response(data: 'popular')
      end
    end
  end
end
