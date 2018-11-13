# api/blogs.rb 所以慣例就是
# module API
#   class Blogs

module API
  class Blogs < Grape::API

    default_format :json

    get '/' do
      'blogs/index'
    end
    # 從Console測試
    # curl 'http://localhost:3000/api' 就是訪問
    # 會回'blogs/index'
    # 加-i 查看更多訊息，grape會依照副檔名回對應格式
    # curl -i 'http://localhost:3000/api.txt'

    # 如果是從瀏覽器測試
    # 要手動指定請求格式，讓Grape知道 http://localhost:3000/api.json 或api.text
    # 如果輸入http://localhost:3000/api 會error
    # 從Network ->Headers -> Request Headers 可以看到accept的是application/xml等

    # 用Postman測試
    # 如果Request Headers 有加KEY VALUE是 Accept text/plain
    # 回來的Headers可以看到Content-type就會變成text/plain
  end
end
