#!/bin/sh

## Set the current working directory to script source
cd $(dirname $(readlink -f $0))

## Symlink the custom plugins directory to current directory
ln -s $HOME/terraform.d terraform.d

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "Error: AWS Access Key Id environment variable was not provided"
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "Error: AWS Secret Access Key environment variable was not provided"
  exit 1
fi

if [ -z "$S3_BUCKET_NAME" ]; then
  echo "Error: S3 Bucket Name environment variable was not provided"
  exit 1
fi

if [ -z "$TF_WORKSPACE_NAME" ]; then
  echo "Error: Terraform Workspace Name environment variable was not provided"
  exit 1
fi

echo "Initializing Terraform Directory"
terraform init -backend-config="bucket=$S3_BUCKET_NAME"
terraform workspace select ${TF_WORKSPACE_NAME}