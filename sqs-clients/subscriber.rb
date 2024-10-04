
require "aws-sdk-sqs"

def consume_message(sqs_client, queue_url)
  response = nil
  measure_time do
    response = sqs_client.receive_message(
      queue_url: queue_url,
      max_number_of_messages: 10 # なるべく一気にたくさんのmesasgeを取得させたい（最大10）
    )
  end
  return if response.messages.count.zero?

  received_at = Time.now # 他の処理で時間がかかると結果がブレるのでlistenしたら即時間を計測
  response.messages.each do |message|
    parsed_body = JSON.parse(message.body)
    created_at = parsed_body["payload"]["after"]["created_at"]
    created_at_parsed_utc = Time.parse(created_at)
    created_at_parsed_jtc = created_at_parsed_utc.getlocal("+09:00")
    create_receive_duration = received_at - created_at_parsed_jtc
    puts "#{created_at_parsed_jtc},#{received_at},#{(create_receive_duration * 1000).to_i}"

    sleep 0.3 # 本処理として 300ms かかるとしよう

    measure_time do
      sqs_client.delete_message(
        queue_url: queue_url,
        receipt_handle: message.receipt_handle
      )
    end
  end

rescue StandardError => e
  puts "Error receiving messages: #{e.message}"
end

def main
  queue_name = "ogasawara-sample.fifo"
  region = "ap-northeast-1"
  queue_url = "https://sqs.#{region}.amazonaws.com/356585129680/" + queue_name
  sqs_client = Aws::SQS::Client.new(region: region)

  puts "commited at, received at, create to receive duration(ms)"

  # SQSはポーリングが必要なので短い時間角で処理を実行させる
  loop do
    consume_message(sqs_client, queue_url)
    sleep 0.01 # 10ms
  end
end

def measure_time
  start_time = Time.now
  yield  # ブロック内の処理を実行
  end_time = Time.now
  elapsed_time = (end_time - start_time)*1000 # ミリ秒

  if ENV['DEBUG'] == 'true'
    puts "Processing time: #{elapsed_time} milliseconds"
  end
end

main
