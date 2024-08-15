# Custom Topic Name Mapper

Forked from: https://github.com/debezium/debezium-examples/tree/main/debezium-server-name-mapper (Apache Pulsar with PrefixingNameMapper)

This example demonstrates how to develop and deploy a bean that would allow the developer to implement a custom topic naming policy.

The implementation of the custom naming policy is in the class `ConstantNameMapper`.
The class is marked as `@Dependent` and it is injected into the configured sink adaptor class.
It exposes a configuration option named `mapper.constant` which defines a string that is inserted before the original topic name.

The configuration option is configured either via `application.properties` configuration file or via other ways defined in the Microprofile Config specification, e.g. an environment variable.

As an example, when setting `mapper.constant` to the value `foobar`, then a message intended to be delivered to the topic `server.schema.table` would be routed to topic `foobar`.

## Topology

This demo uses Pub/Sub as the sink and the standard Debezium example PostgreSQL database.
Both Pub/Sub Emulator and the source database are deployed via Docker Compose file.

## How to run

From terminal start the source database and the sink system:

```
$ export DEBEZIUM_VERSION=2.7
$ docker compose up
```

In another terminal build the custom naming policy class and the runner JAR to start the application:

```
$ mvn clean install
```

Create a topic (`foobar`) and a subscription (`baz`):

```
./init.sh
```

Start the application:

```
$ java -jar target/quarkus-app/quarkus-run.jar
```

In another terminal pull a event from the subscription:

```
./pull.sh
```

The resulting topic list should contain for example a topic named

```
{
  "receivedMessages": [{
    "ackId": "projects/emulator/subscriptions/baz:1",
    "message": {
      "data": "eyJzY2hlbWEiOnsidHlwZSI6InN0cnVjdCIsImZpZWxkcyI6W3sidHlwZSI6InN0cnVjdCIsImZpZWxkcyI6W3sidHlwZSI6ImludDMyIiwib3B0aW9uYWwiOmZhbHNlLCJkZWZhdWx0IjowLCJmaWVsZCI6ImlkIn0seyJ0eXBlIjoic3RyaW5nIiwib3B0aW9uYWwiOmZhbHNlLCJmaWVsZCI6Im5hbWUifSx7InR5cGUiOiJzdHJpbmciLCJvcHRpb25hbCI6dHJ1ZSwiZmllbGQiOiJkZXNjcmlwdGlvbiJ9LHsidHlwZSI6ImRvdWJsZSIsIm9wdGlvbmFsIjp0cnVlLCJmaWVsZCI6IndlaWdodCJ9XSwib3B0aW9uYWwiOnRydWUsIm5hbWUiOiJ0dXRvcmlhbC5pbnZlbnRvcnkucHJvZHVjdHMuVmFsdWUiLCJmaWVsZCI6ImJlZm9yZSJ9LHsidHlwZSI6InN0cnVjdCIsImZpZWxkcyI6W3sidHlwZSI6ImludDMyIiwib3B0aW9uYWwiOmZhbHNlLCJkZWZhdWx0IjowLCJmaWVsZCI6ImlkIn0seyJ0eXBlIjoic3RyaW5nIiwib3B0aW9uYWwiOmZhbHNlLCJmaWVsZCI6Im5hbWUifSx7InR5cGUiOiJzdHJpbmciLCJvcHRpb25hbCI6dHJ1ZSwiZmllbGQiOiJkZXNjcmlwdGlvbiJ9LHsidHlwZSI6ImRvdWJsZSIsIm9wdGlvbmFsIjp0cnVlLCJmaWVsZCI6IndlaWdodCJ9XSwib3B0aW9uYWwiOnRydWUsIm5hbWUiOiJ0dXRvcmlhbC5pbnZlbnRvcnkucHJvZHVjdHMuVmFsdWUiLCJmaWVsZCI6ImFmdGVyIn0seyJ0eXBlIjoic3RydWN0IiwiZmllbGRzIjpbeyJ0eXBlIjoic3RyaW5nIiwib3B0aW9uYWwiOmZhbHNlLCJmaWVsZCI6InZlcnNpb24ifSx7InR5cGUiOiJzdHJpbmciLCJvcHRpb25hbCI6ZmFsc2UsImZpZWxkIjoiY29ubmVjdG9yIn0seyJ0eXBlIjoic3RyaW5nIiwib3B0aW9uYWwiOmZhbHNlLCJmaWVsZCI6Im5hbWUifSx7InR5cGUiOiJpbnQ2NCIsIm9wdGlvbmFsIjpmYWxzZSwiZmllbGQiOiJ0c19tcyJ9LHsidHlwZSI6InN0cmluZyIsIm9wdGlvbmFsIjp0cnVlLCJuYW1lIjoiaW8uZGViZXppdW0uZGF0YS5FbnVtIiwidmVyc2lvbiI6MSwicGFyYW1ldGVycyI6eyJhbGxvd2VkIjoidHJ1ZSxsYXN0LGZhbHNlLGluY3JlbWVudGFsIn0sImRlZmF1bHQiOiJmYWxzZSIsImZpZWxkIjoic25hcHNob3QifSx7InR5cGUiOiJzdHJpbmciLCJvcHRpb25hbCI6ZmFsc2UsImZpZWxkIjoiZGIifSx7InR5cGUiOiJzdHJpbmciLCJvcHRpb25hbCI6dHJ1ZSwiZmllbGQiOiJzZXF1ZW5jZSJ9LHsidHlwZSI6ImludDY0Iiwib3B0aW9uYWwiOnRydWUsImZpZWxkIjoidHNfdXMifSx7InR5cGUiOiJpbnQ2NCIsIm9wdGlvbmFsIjp0cnVlLCJmaWVsZCI6InRzX25zIn0seyJ0eXBlIjoic3RyaW5nIiwib3B0aW9uYWwiOmZhbHNlLCJmaWVsZCI6InNjaGVtYSJ9LHsidHlwZSI6InN0cmluZyIsIm9wdGlvbmFsIjpmYWxzZSwiZmllbGQiOiJ0YWJsZSJ9LHsidHlwZSI6ImludDY0Iiwib3B0aW9uYWwiOnRydWUsImZpZWxkIjoidHhJZCJ9LHsidHlwZSI6ImludDY0Iiwib3B0aW9uYWwiOnRydWUsImZpZWxkIjoibHNuIn0seyJ0eXBlIjoiaW50NjQiLCJvcHRpb25hbCI6dHJ1ZSwiZmllbGQiOiJ4bWluIn1dLCJvcHRpb25hbCI6ZmFsc2UsIm5hbWUiOiJpby5kZWJleml1bS5jb25uZWN0b3IucG9zdGdyZXNxbC5Tb3VyY2UiLCJmaWVsZCI6InNvdXJjZSJ9LHsidHlwZSI6InN0cnVjdCIsImZpZWxkcyI6W3sidHlwZSI6InN0cmluZyIsIm9wdGlvbmFsIjpmYWxzZSwiZmllbGQiOiJpZCJ9LHsidHlwZSI6ImludDY0Iiwib3B0aW9uYWwiOmZhbHNlLCJmaWVsZCI6InRvdGFsX29yZGVyIn0seyJ0eXBlIjoiaW50NjQiLCJvcHRpb25hbCI6ZmFsc2UsImZpZWxkIjoiZGF0YV9jb2xsZWN0aW9uX29yZGVyIn1dLCJvcHRpb25hbCI6dHJ1ZSwibmFtZSI6ImV2ZW50LmJsb2NrIiwidmVyc2lvbiI6MSwiZmllbGQiOiJ0cmFuc2FjdGlvbiJ9LHsidHlwZSI6InN0cmluZyIsIm9wdGlvbmFsIjpmYWxzZSwiZmllbGQiOiJvcCJ9LHsidHlwZSI6ImludDY0Iiwib3B0aW9uYWwiOnRydWUsImZpZWxkIjoidHNfbXMifSx7InR5cGUiOiJpbnQ2NCIsIm9wdGlvbmFsIjp0cnVlLCJmaWVsZCI6InRzX3VzIn0seyJ0eXBlIjoiaW50NjQiLCJvcHRpb25hbCI6dHJ1ZSwiZmllbGQiOiJ0c19ucyJ9XSwib3B0aW9uYWwiOmZhbHNlLCJuYW1lIjoidHV0b3JpYWwuaW52ZW50b3J5LnByb2R1Y3RzLkVudmVsb3BlIiwidmVyc2lvbiI6Mn0sInBheWxvYWQiOnsiYmVmb3JlIjpudWxsLCJhZnRlciI6eyJpZCI6MTA0LCJuYW1lIjoiaGFtbWVyIiwiZGVzY3JpcHRpb24iOiIxMm96IGNhcnBlbnRlcidzIGhhbW1lciIsIndlaWdodCI6MC43NX0sInNvdXJjZSI6eyJ2ZXJzaW9uIjoiMi43LjEuRmluYWwiLCJjb25uZWN0b3IiOiJwb3N0Z3Jlc3FsIiwibmFtZSI6InR1dG9yaWFsIiwidHNfbXMiOjE3MjM3MzI5MTQ1NDMsInNuYXBzaG90IjoidHJ1ZSIsImRiIjoicG9zdGdyZXMiLCJzZXF1ZW5jZSI6IltudWxsLFwiMzQ0ODkzNjhcIl0iLCJ0c191cyI6MTcyMzczMjkxNDU0MzU3MywidHNfbnMiOjE3MjM3MzI5MTQ1NDM1NzMwMDAsInNjaGVtYSI6ImludmVudG9yeSIsInRhYmxlIjoicHJvZHVjdHMiLCJ0eElkIjo3NzUsImxzbiI6MzQ0ODkzNjgsInhtaW4iOm51bGx9LCJ0cmFuc2FjdGlvbiI6bnVsbCwib3AiOiJyIiwidHNfbXMiOjE3MjM3MzI5MTQ2NjUsInRzX3VzIjoxNzIzNzMyOTE0NjY1Nzg1LCJ0c19ucyI6MTcyMzczMjkxNDY2NTc4NTAwMH19",
      "messageId": "2",
      "publishTime": "2024-08-15T14:41:55.370Z",
      "orderingKey": "{\"schema\":{\"type\":\"struct\",\"fields\":[{\"type\":\"int32\",\"optional\":false,\"default\":0,\"field\":\"id\"}],\"optional\":false,\"name\":\"tutorial.inventory.products.Key\"},\"payload\":{\"id\":104}}"
    }
  }]
}
```
