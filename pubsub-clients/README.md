# これは何

GCPのcloud pub/subにmessageをpublishしたりsubscribeしたりするくんです。
一旦rubyクライアントで動くものを用意しました。遊ぶのに使いました。

## 使い方

```sh
# gcloud cliの認証
gcloud auth application-default login

cd pubsub-clients
bundle install --path=vendor/bundle
bundle exec ruby publish.rb
bundle exec ruby subscribe.rb
```
