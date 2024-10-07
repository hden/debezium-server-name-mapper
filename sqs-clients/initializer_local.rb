
require "aws-sdk-sqs"

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
  sqs_client = Aws::SQS::Client.new(region: region)

  resp = sqs_client.create_queue(queue_name: queue_name)
  puts "Queue URL: #{resp.queue_url}"
end

main
