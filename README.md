# Limble Solutions Project

This is a proof-of-concept Wordpress deployment on AWS, utilizing Terraform, EKS, and MySQL on RDS.

## Goals and Constraints

* Highly available
* Redundant
* Ephemeral
* Fully infrastructure-as-code
* Speedy
* 16 hour working time limit ([timelogged here](timelog.md))

## TODO

1. Remove this TODO when done.
2. Read about Terraform AWS provider.
3. Setup EKS cluster for Wordpress, Terraform it.
a. Loadbalancing? Is Ingress/cluster IP enough? (**ELB**)
b. Use helm for this?
c. Dockerfile/komposerize?
4. Setup MySQL on RDS via Terraform, connect it to my EKS cluster on Terraform.
a. VPC/individual subnets/security groups
5. Setup Cloudfront with Terraform, connect it to my EKS cluster.
a. VPC/individual subnets/security groups
6. Script/terraform both the RDS <-> EKS connection and EKS <-> Cloudfront connection.
7. Setup backups with Terraform.
8. Setup dev/prod/QA EKS clusters.
9. Setup diaster recovery.
10. Logging with Cloudwatch, terraformed.
a. Can we get simple monitoring going too?

## Usage

Create a `configs/terraform/aws.tfvars` file like so:

```
access_key = ""
secret_key = ""
iam_arn    = "" # IAM user ARN to view EKS cluster on console
```

1. `terraform {init,plan,apply} -var-file="aws.tfvars"`
2. `aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --kubeconfig $(terraform output -raw cluster_name).yaml; mv $(terraform output -raw cluster_name).yaml ../kubernetes/$(terraform output -raw cluster_name).yaml`
3. `terraform output -raw config_map > ../kubernetes/config_map.yaml; k --kubeconfig ../kubernetes/$(terraform output -raw cluster_name).yaml apply -f ../kubernetes/config_map.yaml`
4. `k --kubeconfig ../kubernetes/$(terraform output -raw cluster_name).yaml apply -f ../kubernetes/deployment.yaml`

## Structure

TODO: insert diagram here

## Issues

Make sure there is clean destroy.

## Explanation

TODO: Insert writeup here.

### Decisions

#### EKS - Managed node vs self-managed vs Fargate

Managed node groups have no additional costs over self-managed nodes and automatically include ASGs. Fargate is better suited for temporary or burstable workloads rather than a website.

## Future Ideas

This is what I ran out of time to do, but would be nice.

## Resources
