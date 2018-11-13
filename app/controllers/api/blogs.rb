# api/blogs.rb 所以慣例就是
# module API
#   class Blogs

module API
  class Blogs < Grape::API

    default_format :json

    get '/' do
      'blogs/index'
    end
    # curl 'http://localhost:3000/api' 就是訪問
    # 會回'blogs/index'
    # 加-i 查看更多訊息，grape會依照副檔名回對應格式
    # curl -i 'http://localhost:3000/api.txt'
  end
end
