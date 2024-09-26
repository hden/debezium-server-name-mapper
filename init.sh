curl -s -X PUT 'http://localhost:8681/v1/projects/emulator/topics/foobar'
curl -s -X PUT 'http://localhost:8681/v1/projects/emulator/subscriptions/baz' \
-H 'Content-Type: application/json' \
-d '{
  "topic": "projects/emulator/topics/foobar"
}'
