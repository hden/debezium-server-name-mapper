
require "aws-sdk-sqs"
require "aws-sdk-sts"

def consume_message(sqs_client, queue_url)
  response = sqs_client.receive_message(
    queue_url: queue_url,
    max_number_of_messages: 1
  )
  return if response.messages.count.zero?

  response.messages.each do |message|
    received_at = Time.now # 他の処理で時間がかかると結果がブレるのでlistenしたら即時間を計測
    parsed_body = JSON.parse(message.body)
    created_at = parsed_body["payload"]["after"]["created_at"]
    created_at_parsed_utc = Time.parse(created_at)
    created_at_parsed_jtc = created_at_parsed_utc.getlocal("+09:00")
    create_receive_duration = received_at - created_at_parsed_jtc
    puts "#{created_at_parsed_jtc},#{received_at},#{(create_receive_duration * 1000).to_i}"
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

  sts_client = Aws::STS::Client.new(region: region)
  queue_url = "https://sqs." + region + ".amazonaws.com/" +
    sts_client.get_caller_identity.account + "/" + queue_name

  sqs_client = Aws::SQS::Client.new(region: region)
  consume_message(sqs_client, queue_url)
end

puts "commited at, received at, create to receive duration(ms)"
# 1秒ごとにrun_meを実行
# どうやらSQSにはポーリングが必要らしい…
loop do
  main
  sleep 1
end
