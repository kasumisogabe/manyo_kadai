### taskモデル  
|column|date|  
|:-------|:-----|  
|title|string|  
|content|string|  
|limit|date|  
|status|string|  
|priority|string|  

### userモデル  
|column|date|  
|:-------|:-----|  
|name|string|  
|email|string|  
|password_digest|string|  

### labelモデル  
|column|date|  
|:-------|:-----|  
|label_name|string|  

### Herokuへのデプロイ方法  
*heroku createコマンドでHerokuに新しいアプリケーションを作成  
*Gemfileに以下のgemを追加し、bundle installを実行  
  *gem 'net-smtp'  
  *gem 'net-imap'  
  *gem 'net-pop  
*git add .とgit commit -m "init"を使ってコミットする  
*heroku stack:set heroku-20コマンドでバージョンの変更  
*git push heroku masterコマンドでデプロイ  
*heroku run rails db:migrateコマンドでマイグレーションを行う  
*heroku openコマンドでアプリケーションにアクセスする