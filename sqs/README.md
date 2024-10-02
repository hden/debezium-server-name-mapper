# 事前準備


```sh
brew install localstack/tap/localstack-cli
pip install awscli-local
```

## 起動


```sh
cd sqs
docker compose up
```

## debezium-serverの起動

.envなどで以下の設定を行なう

```sh
export DEBEZIUM_VERSION=2.7
export AWS_ENDPOINT_URL=http://localhost:4567
export AWS_PROFILE=localstack
```

~/.aws/credentials に localstackという名前でdummyのクレデンシャルを設定する

```
[localstack]
aws_access_key_id = dummy
aws_secret_access_key = dummy
region = us-east-1
```

アプリを起動する

```sh
mvn clean install
java -jar target/quarkus-app/quarkus-run.jar
```

## awslocalコマンドでの操作

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
