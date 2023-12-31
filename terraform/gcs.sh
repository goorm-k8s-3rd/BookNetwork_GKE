#!/bin/bash

BUCKET_NAME="k8s-standard-bucket-tfstate"
PROJECT_ID="spry-framework-406704"
LOCATION="ASIA-NORTHEAST3"

# GCS 버킷 생성

if gsutil ls -p $PROJECT_ID gs://$BUCKET_NAME 2>&1 | grep -q 'NotFound'; then
    echo "Creating bucket $BUCKET_NAME"
    gsutil mb -p $PROJECT_ID -l $LOCATION gs://$BUCKET_NAME
    gsutil versioning set on gs://$BUCKET_NAME
else
    echo "Bucket $BUCKET_NAME already exists."
fi

terraform init
terraform plan
terraform apply -auto-approve
