#!/bin/bash

# called by mrq-test-data.sh with three parameters:
# $1: environment
# $2: type
# $3: id

# construct env string
case "$1" in
  "expr")
    ENV="experiment-api"
    ;;
  "stg1")
    ENV="staging-api"
    ;;
  "prod")
    ENV="api"
    ;;
esac

PAYLOAD=$(sh ./build-payloads.sh $2 $3)

echo $PAYLOAD

curl \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  "https://$ENV.sift.com/v205/events?return_workflow_status=true"

echo -e "\n"

if [ $? -ne 0 ]; then
    echo "Error: curl request failed"
    exit 1
fi