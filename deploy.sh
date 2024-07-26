#!/bin/bash

accountId=$1
region=$2
licenseKey=$3
bucket=$4

echo "region set to ${region}"

sam build --use-container

echo "Creating S3 bucket ${bucket} in region ${region}"

aws s3 mb --region "${region}" "s3://${bucket}"

sam package --region "${region}" --s3-bucket "${bucket}" --output-template-file packaged.yaml

aws cloudformation deploy \
	--region "${region}" \
	--template-file packaged.yaml \
	--stack-name NewrelicExamplePython \
	--capabilities CAPABILITY_IAM \
	--parameter-overrides "NRAccountId=${accountId}" "NRLicenseKey=${licenseKey}"
