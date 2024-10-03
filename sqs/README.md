
# 概要

sqsを開発するための諸々が入っているディレクトリです。

# ローカル開発環境

## 事前準備

以下を入れておく

```sh
brew install localstack/tap/localstack-cli
pip install awscli-local
```

## DBとlocalstackの起動

```sh
cd sqs
docker compose up
```

## localstackの初期化

```sh
cd sqs-clients
bundle install --path=vendor/bundle
bundle exec ruby initializer_local.rb
```

これでlocalstackにキューが生成されます。このキューにmessageをpublishしたり、それをconsumeします。

## debezium-serverの起動

環境変数を設定する

```sh
cd sqs
touch .envrc
echo <<EOF > .envrc
export DEBEZIUM_VERSION=2.7
export AWS_ENDPOINT_URL=http://localhost:4567
export AWS_PROFILE=localstack
EOF
direnv allow
```

また、 ~/.aws/credentials に localstackという名前で以下のクレデンシャルを設定する

```
[localstack]
aws_access_key_id = dummy
aws_secret_access_key = dummy
region = us-east-1
```

この状態でアプリを起動するとdebeziumがlocalstackに接続できるようになります。

```sh
mvn clean install
java -jar target/quarkus-app/quarkus-run.jar
```

## Tips

dockerで立ち上げたlocalstackのSQSに対してawslocalコマンドでの操作が可能です。デバッグに利用しましょう

https://docs.localstack.cloud/user-guide/aws/sqs/

- キューの作成

```sh
awslocal sqs create-queue --queue-name localstack-queue
awslocal sqs list-queues
```

- メッセージの送受信

```sh
awslocal sqs send-message --queue-url http://sqs.us-east-1.localhost.localstack.cloud:4566/000000000000/localstack-queue --message-body "Hello World"
awslocal sqs receive-message --queue-url http://sqs.us-east-1.localhost.localstack.cloud:4566/000000000000/localstack-queue
awslocal sqs delete-message --queue-url http://sqs.us-east-1.localhost.localstack.cloud:4566/000000000000/localstack-queue --receipt-handle <receipt-handle>
```

# CloudのSQSとの接続

まずapplication.propertiesを入れ替えてください。

TODO: add properties

次にDBを起動してください

```sh
cd sqs
docker compose up db
```

次に以下の手順でdebezium-serverを起動してください。

```sh
cd sqs
mvn clean install
AWS_PROFILE=sms-xuan-dev java -jar target/quarkus-app/quarkus-run.jar # dev環境のAWSアカウントを向けるようにprofile（sms-xuan-dev）をあらかじめ用意しておく必要があるので注意
```

これでdebeziumのsinkをAWS上のSQSに向けることができます。

あとはsqlを実行するとmessageがSQSにpublishされます。

なお、subscriberは以下で起動できます。

```sh
cd sqs-clients
bundle install --path=vendor/bundle
bundle exec ruby subscriber.rb
```
