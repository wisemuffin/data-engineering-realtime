# Data Engineering Realtime Data

I have created this project to demo real time reporting performance for various architectures.

## Architecture

## Components

- Kafka Producer - Nodejs app generating fake data
- Kafka Producer - React app that will send data from a UI to Kafka
- Kafka
- Kafka Consumer - Nodejs
- Kafka Consumer - React
- S3 - staging data between Kafka and Snowflake
- Snowflake - Snowpipe
- Analytics React App

## Performance
- Kafka Producer -> Kafka -> Kafka Consumer - React
- Kafka Producer -> Kafka -> S3 -> Snowflake -> React App