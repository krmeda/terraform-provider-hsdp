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

TFPLANFILE="hsdp-iam-plan.tfplan"

if ! [ -e ${TFPLANFILE} ]; then
  echo "Error: Terraform Plan file ${TFPLANFILE} not found"
  exit 1
fi

echo "Applying plan from $TFPLANFILE"
terraform show ${TFPLANFILE}
terraform apply ${TFPLANFILE}
