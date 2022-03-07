# Limble Solutions Project

This is a proof-of-concept Wordpress deployment on AWS, utilizing Terraform, EKS, and MySQL on RDS.

## Goals and Constraints

* Fully infrastructure-as-code
* Speedy
* 16 hour working time limit ([timelogged here](timelog.md))

## TODO

1. Remove this TODO when done.
5. Setup Cloudfront with Terraform, connect it to my EKS cluster.
a. VPC/individual subnets/security groups
6. Script/terraform EKS <-> Cloudfront connection.
7. Setup backups with Terraform.
8. Setup dev/prod/QA EKS clusters.
9. Setup diaster recovery.
10. Logging with Cloudwatch, terraformed.
a. Can we get simple monitoring going too?

## Usage

Create a `configs/terraform/aws.tfvars` file:

```
access_key = ""
secret_key = ""
db_password = ""
iam_arn    = "" # IAM user ARN to view EKS cluster on console
```

1. `cd configs/terraform; terraform {init,plan,apply} -var-file="aws.tfvars"`
2. `cd ../kubernetes; k apply -k ./`
3. `k get services wordpress  -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"`

## Structure

TODO: insert diagram here

## Issues

Make sure there is clean destroy.

## Explanation

TODO: Insert writeup here.

### Decisions

#### EKS - Managed node vs self-managed vs Fargate

Managed node groups have no additional costs over self-managed nodes and automatically include ASGs. Fargate is better suited for temporary or burstable workloads rather than a website.

#### Modules vs Resources

For ease of use, I went with the VPC module as opposed to the actual AWS resource. If I had more time to re-design it I would refactor to use the pure AWS resource, but the module saved time.

#### Kubernetes provider vs configuration files

I enjoyed the greater flexibility of building and applying Kubernetes configuration files over using the Kubernetes provider, but can see the advantage to have that aspect managed by Terraform too.

## Future Ideas

This is what I ran out of time to do, but would be nice.

* Secrets Management - SSM/Hashicorp Vault
Defining RDS password twice isn't great.
