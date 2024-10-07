
require "aws-sdk-sqs"
require "aws-sdk-sts"

def consume_message(sqs_client, queue_url)
  response = sqs_client.receive_message(
    queue_url: queue_url,
    max_number_of_messages: 1
  )
  return if response.messages.count.zero?

  response.messages.each do |message|
    puts "-" * 20
    puts "Message body: #{message.body}"
    puts "Message ID:   #{message.message_id}"
    sqs_client.delete_message(
      queue_url: queue_url,
      receipt_handle: message.receipt_handle
    )
  end

rescue StandardError => e
  puts "Error receiving messages: #{e.message}"
end

def main
  region = "us-east-1"
  endpoint = "http://sqs.#{region}.localhost.localstack.cloud:4566"
  Aws.config.update(
    endpoint:  endpoint, # update with localstack endpoint
    access_key_id: 'test', # update with localstack credentials
    secret_access_key: 'test', # update with localstack credentials
    region: region,
  )
  queue_name = "localstack-queue"
  queue_url = endpoint + "/000000000000" + "/" + queue_name

  sqs_client = Aws::SQS::Client.new(region: region)
  consume_message(sqs_client, queue_url)
end

# 1秒ごとにrun_meを実行
# どうやらSQSにはポーリングが必要らしい…
loop do
  main
  sleep 1
end
