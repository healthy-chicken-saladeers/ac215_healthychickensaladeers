#!/bin/bash

# exit immediately if a command exits with a non-zero status
set -e

# Define some environment variables
export IMAGE_NAME="rag-detective-api-service"
export BASE_DIR=$(pwd)
export SECRETS_DIR=$(pwd)/../../secrets/
export PERSISTENT_DIR=$(pwd)/../../persistent-folder/
export GCP_PROJECT="rag-detective"
export GCS_BUCKET_NAME="ac215_scraper_bucket"
export GCS_SERVICE_ACCOUNT="ml-workflow@rag-detective.iam.gserviceaccount.com"

echo "BASE_DIR is ${BASE_DIR}"
echo "SECRETS_DIR is ${SECRETS_DIR}"
echo "OPENAI_APIKEY" is $OPENAI_APIKEY

# Build the image based on the Dockerfile
docker build -t $IMAGE_NAME -f Dockerfile .
# M1/2 chip macs use this line
#docker build -t $IMAGE_NAME --platform=linux/arm64/v8 -f Dockerfile .

# Run the container
docker run --rm --name "$IMAGE_NAME" -ti \
-v "$BASE_DIR":/app \
-v "$SECRETS_DIR":/secrets \
-v "$PERSISTENT_DIR":/persistent \
-p 9000:9000 \
-e DEV=1 \
-e GCP_PROJECT=$GCP_PROJECT \
-e GCS_BUCKET_NAME=$GCS_BUCKET_NAME \
-e OPENAI_APIKEY=$OPENAI_APIKEY \
-e GCS_SERVICE_ACCOUNT=$GCS_SERVICE_ACCOUNT \
-e GOOGLE_APPLICATION_CREDENTIALS=/secrets/ml-workflow.json \
$IMAGE_NAME
