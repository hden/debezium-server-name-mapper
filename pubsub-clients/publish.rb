require "google/cloud/pubsub"

topic_id = "ogasawara-manual-sample"

pubsub = Google::Cloud::Pubsub.new(
  project_id: "prj-dev-xuan-cloud-pubsub-poc",

)

topic = pubsub.topic topic_id
topic.publish "This is a test message."

puts "Message published."
