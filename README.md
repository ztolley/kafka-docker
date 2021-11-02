# Kafka docker build

A simple Docker build for Kafka to enable running on Apple Silicon and Intel

# Build with Buildx to support arm and intel/amd

First setup buildx:
`docker buildx install`

Then for each build:

`docker buildx build --platform linux/amd64,linux/arm64/v8 -t ztolley/kafka:2.8.1 --push .`
docker build .

A Github action has been created that will build the push the image on checkin, update the version in the action file when you want to build a new release for a new kafka

## Docker Compose example

```
# docker-compose.yml

services:
  zookeeper:
    image: zookeeper
    env_file:
      - .env
  kafka:
    build:
      context: .
      dockerfile: Dockerfile
    depends_on:
      - zookeeper
    ports:
      - 9092:9092
    env_file:
      - .env

```

```
# .env

KAFKA_LISTENERS=PLAINTEXT://:9092
KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://127.0.0.1:9092
KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT
KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT
KAFKA_BROKER_ID=1
KAFKA_LOG4J_LOGGERS='kafka.controller=INFO,kafka.producer.async.DefaultEventHandler=INFO,state.change.logger=INFO'
KAFKA_LOG4J_ROOT_LOGLEVEL=INFO
KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1
KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
ZOOKEEPER_CLIENT_PORT=2181
ZOOKEEPER_TICK_TIME=2000
```

## Docker hub

`docker pull ztolley/kafka`
