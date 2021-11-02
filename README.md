# Kafka docker build

A simple Docker build for Kafka to enable running on Apple Silicon and Intel

# Build with Buildx to support arm and intel/amd

First setup buildx:
`docker buildx install`

Then for each build:

`docker buildx build --platform linux/amd64,linux/arm64/v8 -t ztolley/kafka:2.8.1 --push .`
docker build .

A Github action has been created that will build the push the image on checkin, update the version in the action file when you want to build a new release for a new kafka
