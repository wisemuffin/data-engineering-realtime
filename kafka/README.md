
# Setting up Kafka for snowflake
https://community.snowflake.com/s/article/How-To-Streaming-From-Kafka-to-Snowflake-Part-1-Kafka-to-S3
```bash
docker run -p 2181:2181 \
 -p 3030:3030 \
 -p 8081-8083:8081-8083 \
    -p 9581-9585:9581-9585 \
    -p 9092:9092 \
    -e AWS_ACCESS_KEY_ID=your_aws_access_key_without_quotes \
    -e AWS_SECRET_ACCESS_KEY=your_aws_secret_key_without_quotes \
    -e ADV_HOST=127.0.0.1 \
      landoop/fast-data-dev:latest
```
# Add kafka connect

you need to choose a topic and a s3 connector

http://127.0.0.1:64191/

then create a aws s3 with config:

name=kafka-to-s3-to-snowflake
connector.class=io.confluent.connect.s3.S3SinkConnector
s3.region=ap-southeast-2
format.class=io.confluent.connect.s3.format.json.JsonFormat
topics.dir=topics
flush.size=1
topics=first_topic
tasks.max=1
value.converter=org.apache.kafka.connect.storage.StringConverter
storage.class=io.confluent.connect.s3.storage.S3Storage
key.converter=org.apache.kafka.connect.storage.StringConverter
s3.bucket.name=kafka-to-s3-to-snowflake

# kafka console producer
if you dont have a producer set up you can

Just replace TOPIC_NAME

```bash
docker exec -it DOCKER_CONTAINER_ID /bin/bash

kafka-console-producer --broker-list 127.0.0.1:9092 --topic=TOPIC_NAME
```

Once you press enter, you should see a > appear on the screen expecting you to type something.

### to check i with a console consumer
```bash
kafka-console-consumer --bootstrap-server 127.0.0.1:9092 --topic TOPIC_NAME
```
