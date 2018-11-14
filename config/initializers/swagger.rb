GrapeSwaggerRails.options.tap do |o|
  o.app_name       = 'GrapeRailsTemplate'
  o.url            = '/api/doc/swagger' # 取回文檔的路徑
  o.app_url        = '' # 網站地址

  # 客戶取用API要不校驗
  o.api_auth       = 'basic'
  o.api_key_name   = 'Authorization'
  o.api_key_type   = 'header'

  o.hide_url_input = true
  o.before_filter do |request| # before_filter 用瀏覽器打開文檔時候要不要校驗
    unless Rails.env.development?
      authenticate_or_request_with_http_basic do |username, password|
        username == 'ab' && password == 'ac'
      end
    end
  end
end
