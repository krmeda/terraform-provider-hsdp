# Introduction

This project contains the Terraform Scripts used for provisioning ProjectX Environments.

## Getting Started

TODO: Getting Started Guide

## Build and Test

TODO: Describe and show how to build your code and run the tests.

## Contribute

TODO: Explain how other users and developers can contribute to make your code better.

## 0. First time setup

Terraform needs to store state in a persistent store in order to be able to use in any environment. Currently ProjectX Infra Automation will store this state in S3 bucket. This bucket needs to be provisioned via Cloud Foundry Markeplace S3 service broker. In the US-East CF Org `ProjectX` and space `ProjectX-commons` create an S3 service instance. This will store the state files. The command to create it is:
    ```bash
    # Provision the service
    cf create-service hsdp-s3 s3_bucket ProjectX_infra_store -c '{"Region": "us-east-1", "EnforceServerSideEncryption": true, "EnforceSecureCommunications": true }'
    ```

In order to access the bucket service credentials are needed. This has to be first creattetd by running the following command:

    ```bash
    # Create Access Credentials
    cf create-service-key ProjectX_infra_store cfprops
    ```

Service credentials can be retrieved by running the following command:
    ```bash
    # Retrieve Access Credentials
    cf service-key ProjectX_infra_store cfprops
    ```  

## 1. Provision IAM Resources

The following steps needs to be performed.

1. Set the AWS Credentials by doing following:
    ```bash
    export AWS_ACCESS_KEY_ID = "<ACCESS_KEY_ID_FROM_CF_SERVICE_KEY>"
    export AWS_SECRET_ACCESS_KEY = "<SECRET_ACCESS_KEY_FROM_CF_SERVICE_KEY>"
    ```
2. Fill up the `.tfvars` file with the Terraform Variables
3. Create or switch to the correct terraform workspace using following commands
    ```bash
    # To create new workspace
    terraform workspace new <WORKSPACE_NAME>
    # To switch to correct workspace
    terraform workspace select <WORKSPACE_NAME>
    ```
4. Perform a Terraform Refresh in order to sync any changes to existing resources outside of Terraform.

5. If this is the first time running the script and root IAM org is not yet present in state, it needs to be imported. Import the Root IAM Org using the following command
    ```bash
    terraform import -var-file=ProjectX.tfvars hsdp_iam_org.phm_root_org f5d34188-57ba-4fe2-afcf-bf8cb57a860b
    ```
    If any other resources are already existing, they should also be imported similar to above.

6. Perform a terraform `plan` command in order to preview any changes that need to go in. (Typically on a Pull Request)
    ```bash
    terraform plan -var-file=ProjectX.tfvars -o <PLAN_NAME>.plan
    ```
7. Once the plan is approved, `apply` the plan in order to provision and persist the changes.
    ```bash
    terraform apply -var-file=ProjectX.tfvars <PLAN_NAME>.plan
    ```

## Docker image based provisioning

* To Init the Terraform
    ```bash
    docker run -it -v $(pwd):/tffiles -e "AWS_ACCESS_KEY_ID=<ACCESS_KEY>" -e "AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>" -e "S3_BUCKET_NAME=<BUCKET_NAME>" -e "TF_WORKSPACE_NAME=<ENV_NAME>" --entrypoint /tffiles/init_terraform.sh terraform-provider-hsdp
    ```
* To import existing resource
    ```bash
    docker run -it -v $(pwd):/tffiles -e "AWS_ACCESS_KEY_ID=<ACCESS_KEY>" -e "AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>" --entrypoint /tffiles/import_terraform.sh terraform-provider-hsdp hsdp_iam_org.ProjectX_dev_env_org 3cce941e-0a03-450a-9334-cb566301c21d
    ```
* To Plan terraform
    ```bash
    docker run -it -v $(pwd):/tffiles -e "AWS_ACCESS_KEY_ID=<ACCESS_KEY>" -e "AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>" --entrypoint /tffiles/plan_terraform.sh terraform-provider-hsdp
    ```
* To Apply the change
    ```bash
    docker run -it -v $(pwd):/tffiles -e "AWS_ACCESS_KEY_ID=<ACCESS_KEY>" -e "AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>" --entrypoint /tffiles/run_terraform.sh terraform-provider-hsdp
    ```