require "google/cloud/pubsub"
# require 'pry'
subscription_id = "baz"

pubsub = Google::Cloud::Pubsub.new(
  project_id: "prj-dev-xuan-cloud-pubsub-poc",
)

subscription = pubsub.subscription subscription_id
subscriber   = subscription.listen do |received_message|
  received_at = Time.now # 他の処理で時間がかかると結果がブレるのでlistenしたら即時間を計測
  parsed_message = JSON.parse(received_message.data)
  commited_at = parsed_message["payload"]["after"]["created_at"]
  commited_at_parsed_utc = Time.parse(commited_at)
  commited_at_parsed_jtc = commited_at_parsed_utc.getlocal("+09:00")

  puts "Commited at: #{commited_at_parsed_jtc}, Published at: #{received_message.publish_time}, Received at: #{received_at}"
  received_message.acknowledge!
end

subscriber.start
# Let the main thread sleep for 60 seconds so the thread for listening
# messages does not quit
sleep 60
subscriber.stop.wait!
