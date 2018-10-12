# Terraform Remote State steup

Generates the necessary infrastructure and permissions to manage the Terraform state remotely. This creates an AWS s3 bucket to store the state, a DynamoDB to lock it, and a IAM user to access it. It also restricts the permissions of each of these elements, by applying the appropriate policies. This module can be used upon the creation of other more complex projects, to setup the remote state. This module can be found at the terraform [public regristry](https://registry.terraform.io/modules/rafaelmarques7/remote-state/aws/1.0.0).
<hr />


## Table of contents
- [Setup Terraform Remote State](#setup-terraform-remote-state)
    - [Deployment](#deployment)
    - [WWH - what, why, how](#wwh---what-why-how)
    - [Input arguments](#input-arguments)
    - [Output](#output)
    - [Security](#security)
    - [Common Problems](#common-problems)
    - [Reading material](#reading-material)
<hr />


## Folder structure
```
remote_state
  ├── dynamodb.tf         | dynamodb_table
  ├── input.tf            | required variables
  ├── main.tf             | empty file
  ├── outputs.tf          | provided output
  ├── policies.tf         | create policies
  ├── provider.tf         | aws provider
  ├── README.md           | this file
  ├── s3.tf               | create s3 buckets
  ├── user.tf             | create user
  └── variables.tf        | optional variables
```
<hr />


## Deployment
1. Set the necessary variables - generate a pseudo_random string for the s3 bucket and dynamodb table, and do set the AWS credentials

```bash 
export AWS_ACCESS_KEY=$AWS_DEV_ACCESS_KEY && \
export AWS_SECRET_KEY=$AWS_DEV_SECRET_KEY && \
export BUCKET_NAME="remote-state-bucket-"$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1) && \
export DYNAMODB_TABLE_NAME="dynamodb-state-lock-"$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1)
export ACCOUNT_ID="insert AWS account ID here"
```
Notes: 
* Run the above procedure only once! 
  * The S3 bucket has a lifecycle protection rule. 
  * Every time this is run, a new bucket and dynamodb table name is created. 
  * Thus, it will raise an error upon running terraform for a 2nd time, because the state (bucket reference) is different.

2. Run terraform with the required input.
```bash
terraform init && \
terraform apply \
--var aws_access_key=$AWS_ACCESS_KEY \
--var aws_secret_key=$AWS_SECRET_KEY \
--var bucket_name=$BUCKET_NAME \
--var dynamodb_table_name=$DYNAMODB_TABLE_NAME \
--var account_id=$ACCOUNT_ID \
-auto-approve
```

3. Output should be something like this:
```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

dynamodb_table = {
  arn = arn:aws:dynamodb:us-east-1:975608782524:table/dynamodb-state-lock-ur0dc3a0ww
  id = dynamodb-state-lock-ur0dc3a0ww
}
iam_user = {
  arn = arn:aws:iam::975608782524:user/bot_terraform
  keys = The access keys must be created manually on the AWS console!
  name = bot_terraform
}
s3_bucket = {
  arn = arn:aws:s3:::remote-state-bucket-dsu0tmdqr1
  bucket_domain_name = remote-state-bucket-dsu0tmdqr1.s3.amazonaws.com
  id = remote-state-bucket-dsu0tmdqr1
}
```
<hr />


## WWH - what, why, how
**What?** This is a terraform script to automate the process of deploying the necessary infrastructure to manage Terraform state remotely. It can be **used to setup any Terraform project**.

**Why?** If you are using Terraform by yourself, managing state locally might be enough. However, when working in teams, different team members must have the same infrastructure representation (state!). If this is not the case, and each member of the team has the state stored locally, the infrastructure will break easily, because **a change made by one person will not propagate to the others**. The way to overcome this is using [remote state](https://www.terraform.io/docs/providers/terraform/d/remote_state.html).  

**How?** The remote state will be stored in AWS S3. A bucket is created, and the state file is stored there. As to guarantee that the state is only accessed by one person at a time, a DynamoDb table is used to lock it. Finally, the access to the state is restricted to a single user (which is also created by this script).
**In summary: &nbsp;  s3 bucket +++ dynamodb table +++ single user access**.
<hr />


## Input arguments
There a total of 8 input variables (required variables are marked with a (*) symbol):
```
- aws_access_key                  | required    
- aws_secret_key                  | required
- bucket_name                     | required
- dynamodb_table_name             | required
- account_id                      | required - AWS account ID
- region                          | defaults to "us-east-1"
- remote_state_file_name          | defaults to "state_terraform"
- username_terraform              | defaults to "bot_terraform"
```
<hr />


## Output 
Running the deployment procedure will output 3 variables (and the corresponding properties):
```
- dynamodb_table
  * arn
  * id
- state_bucket
  * arn
  * id 
  * bucket_domain_name
- iam_user
  * arn
  * name
```
<hr />


## Security
* This script deploys an s3 bucket with an identity-based policy that restricts the access to a single user.
* This user is the one created by this script.
* Upon creating the user, its credentials are not set. This has to be done manually using the AWS console.

Request to get a file inside the state bucket
  * using my personal account (**failure**):
    ```
    An error occurred (AccessDenied) when calling the GetObject operation: Access Denied
    ```
  * using bot_terraform user (**success**):
    ```
    {
        "AcceptRanges": "bytes",
        "LastModified": "Thu, 11 Oct 2018 13:07:03 GMT",
        "ContentLength": 3008,
        "ETag": "\"d34dcfda04346be26fd299c3065af6fc\"",                           
        "VersionId": "sS_3Rq54lvymgZA8z6xSW3t2QgfqD5Oc",
        "ContentType": "text/html",
        "ServerSideEncryption": "AES256",
        "Metadata": {}
    }
    ```
<hr />


## Common Problems
Please note that:
  * running this script multiple times will cause unexpected errors.
    * this happens because the resources already exist, there is conflict in the state, or for some other reason.
  * this script should be executed once and once only.
  * if that execution fail, you should delete all the resources created previous to the failure, and retry.
<hr />


## Reading material
Here is some useful reading material (for multiple purposes):

* [why this is necessary](https://stackoverflow.com/questions/47913041/initial-setup-of-terraform-backend-using-terraform)
* [official terraform remote state docs](https://www.terraform.io/docs/state/remote.html)
* [terraform **conventions**](https://github.com/jonbrouse/terraform-style-guide/blob/master/README.md)
* [policies: identity-based vs resource-based](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_identity-vs-resource.html)
* [terraform S3 bucket](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html) and [bucket object](https://www.terraform.io/docs/providers/aws/r/s3_bucket_object.html)
* [terraform dynamodb_table](https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html)
* [policies with terraform - **guide**](https://www.terraform.io/docs/providers/aws/guides/iam-policy-documents.html)
* [terraform policy **Document**](https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html), [policy **Attachment**](https://www.terraform.io/docs/providers/aws/r/iam_policy_attachment.html), [iam **Policy**](https://www.terraform.io/docs/providers/aws/r/iam_policy.html)
* [publish modules to terraform registry](https://www.terraform.io/docs/registry/modules/publish.html) and [standard module structure](https://www.terraform.io/docs/modules/create.html#standard-module-structure)
* [S3 backend config](https://www.terraform.io/docs/backends/types/s3.html)
<hr />