
require "aws-sdk-sqs"
require "aws-sdk-sts"

def consume_messages(sqs_client, queue_url)
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
  region = "ap-northeast-1"
  queue_name = "ogasawara-sample-standard"
  max_number_of_messages = 10

  sts_client = Aws::STS::Client.new(region: region)

  queue_url = "https://sqs." + region + ".amazonaws.com/" +
    sts_client.get_caller_identity.account + "/" + queue_name

  sqs_client = Aws::SQS::Client.new(region: region)

  consume_messages(sqs_client, queue_url)
end

# 1秒ごとにrun_meを実行
# どうやらSQSにはポーリングが必要らしい…
loop do
  main
  sleep 1
end
