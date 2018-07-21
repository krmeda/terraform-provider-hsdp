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

if ! [ -e "projectx.tfvars" ]; then
  echo "Error: Terraform Variables File not found"
  exit 1
fi

if ! [ $# -eq 2 ]; then
  echo "Error: Resource to Import and Id needs to be provided"
  exit 1
fi

echo "Importing resource $1 with id $2"
terraform import -var-file=projectx.tfvars $1 $2