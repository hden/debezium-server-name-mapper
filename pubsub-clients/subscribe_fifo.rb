require "google/cloud/pubsub"
require 'pry'
subscription_id = "baz-fifo" # fifoなsubscription

pubsub = Google::Cloud::Pubsub.new(
  project_id: "prj-dev-xuan-cloud-pubsub-poc",
)

puts "commited at, published at, received at, create to receive duration(ms)"

subscription = pubsub.subscription subscription_id
subscriber   = subscription.listen do |received_message|
  received_at = Time.now # 他の処理で時間がかかると結果がブレるのでlistenしたら即時間を計測
  parsed_message = JSON.parse(received_message.data)
  created_at = parsed_message["payload"]["after"]["created_at"]
  created_at_parsed_utc = Time.parse(created_at)
  created_at_parsed_jtc = created_at_parsed_utc.getlocal("+09:00")
  create_receive_duration = received_at - created_at_parsed_jtc

  puts "#{created_at_parsed_jtc},#{received_message.publish_time},#{received_at},#{(create_receive_duration * 1000).to_i}"
  received_message.acknowledge!
end

subscriber.start
# Let the main thread sleep so the thread for listening
# messages does not quit
sleep 600 # 10分
subscriber.stop.wait!
