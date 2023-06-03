#!/bin/bash

export PROJECT_ID=kubernetes-388201
export PROJECT_NUMBER=582791420051
export ZONE=us-central1
export ARTIFACTS_REPO=cloudberry-artifacts-repo
export APP_NAME=hello-app
export TAG=v1

gcloud config set project ${PROJECT_ID}

# gcloud projects add-iam-policy-binding ${PROJECT_ID} \
#   --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
#   --role roles/run.admin

# # Grant the IAM Service Account User role to the Cloud Build service account on the Cloud Run runtime service account
# gcloud iam service-accounts add-iam-policy-binding \
#   $PROJECT_NUMBER-compute@developer.gserviceaccount.com \
#   --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
#   --role="roles/iam.serviceAccountUser"
  

# gcloud artifacts repositories create ${ARTIFACTS_REPO} \
#    --repository-format=docker \
#    --location=${ZONE} \
#    --description="Cloudberry docker repository"

docker build -t ${ZONE}-docker.pkg.dev/${PROJECT_ID}/${ARTIFACTS_REPO}/${APP_NAME}:${TAG} .

docker images

gcloud artifacts repositories add-iam-policy-binding ${ARTIFACTS_REPO} \
    --location=${ZONE} \
    --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
    --role="roles/artifactregistry.reader"

gcloud auth configure-docker ${ZONE}-docker.pkg.dev --quiet

docker push ${ZONE}-docker.pkg.dev/${PROJECT_ID}/${ARTIFACTS_REPO}/${APP_NAME}:${TAG}