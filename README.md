# README

初始建專案
---
``rails new grape-rails-template --skip-bundle --skip-puma --skipturbolinks --database=mysql``

API目錄
---
API目錄一般有兩種放置方式：

1. 放在app/api，然後記得命名規則class名稱要跟檔案要一樣，接著因為手動建立，要去application.rb把這資料夾加到auto load path.

2. 放在app/controller/api，因為其實api code邏輯上也是controller一部分，然後api下面的檔案名稱跟class名稱也要一致。

API軟知識
---
除了最後一個流量控制，Grape都可以做到

- 權限控制Scope：scope（namespace）
- 版本：version
- 驗證：authentication
- 格式：request/response payload
- 狀態碼：status code
- 文檔：documentation
- 流量控制：access flow control（業務層面）
