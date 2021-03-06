# api/blogs.rb 所以慣例就是
# module API
#   class Blogs

module API
  module V1 # 新增這層
  class Blogs < Grape::API
    include Default # 完成初始化準備工作，把下面這些都收到裡面去

    # 收到api/v1/default.rb
    # default_format :json
    #
    # # Grape的helper是說讓下面API的block可以用
    # helpers do
    #   # 默認接收兩個參數code: 0 代表成功，1代表失敗, data代表API有意義返回值
    #   def build_response code: 0, data: nil
    #     { code: code, data: data }
    #   end
    #
    #   params :id_validator do
    #     requires :id, type: Integer
    #   end
    #   # params :id_validator do |options| 以可以像這樣接收參數
    #   # use :id_validator, a: 1 像這樣傳一個hash進去
    # end

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!({code: 1, error: 'not fould'}, 404)
    end

    rescue_from NoMethodError do |e|
      error!({code: 1, error: 'system error'}, 422)
    end
    # rescue_from :all 抓對全部api的例外

    # grape提供基於HTTP的認證，但這少用
    # http_basic do |username, password|
    #   username == 'test' and password == 'hello'
    # end
    # 沒提供帳密，從postman測試，會看到401 unauthorized
    # 要去authorization那邊輸入

    # postman 那邊header KEY VALUE要加 'X-Api-Secret-Key', 'api_secret_key'
    # grape會把-分隔的第一個字母變大寫，所以Postman key寫x-api-secret-key也會過
    before do
      # byebug去看進來參數
      unless request.headers['X-Api-Secret-Key'] == 'api_secret_key'
        # error!表示直接返回錯誤
        # error! 'forbidden', 403
        error!({code: 1, message: 'forbidden'}, 403)
      end
    end

    # 請求之前或之後處理
    before do
      @variable = nil
      # 在filter的實例變數，下面所有action都可以拿到
    end
    after do
    end

    # 在params校驗之前處理
    before_validation do
    end
    after_validation do
    end

    # 順序：
    # before
    # before_validation
    # params
    # after_validation
    # api方法
    # after
    # 不一定會每個都執行，譬如如果params校驗就失敗，就不會再執行after_validation跟after

    # 只針對部分api路徑加上版本
    version 'v10', using: :path do
      get '/test/filter' do
        raise NoMethodError
      end
    end

    # grape 裡面resources只是給命名空間/blogs，沒有自動生成路由
    # namespace, resource, group, segment 功能都一樣，給命名空間
    resources :blogs do
      # 如果filter寫在namespace, resource(s), group, segment作用域裡面
      # 就只有在這裡面的action會用到

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

      get 'latest', hidden: true do
        redirect '/api/blogs/popular' #redirect會把path返回瀏覽器，要給完整URL，前面杳有/api/
      end

      get 'popular' do
        status 400 #POSTMAN 就會看到status 400
        build_response(data: 'popular')
      end
    end

    # 收到base.rb
    # # 要寫在所有API的後面
    # add_swagger_documentation(
    #   info: {
    #     title: 'GrapeRailsTemplate API Documentation',
    #     contact_email: 'service@eggman.tv'
    #   },
    #
    #   # 添加API路由，
    #   # 因為其實整個API是掛在/api上，(在route: mount API::Blogs, at: '/api')
    #   # 實際路徑是 api/doc/swagger
    #   # 這邊要跟swagger.rb o.url = '/api/doc/swagger' 設置的相同
    #   mount_path: '/doc/swagger',
    #   doc_version: '0.1.0'
    # )
    end
  end
end
