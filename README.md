# Limble Solutions Project

This is a proof-of-concept Wordpress deployment on AWS, utilizing Terraform, EKS, and MySQL on RDS.

## Goals and Constraints

* Highly available
* Redundant
* Ephemeral
* Fully infrastructure-as-code
* Speedy
* 16 hour working time limit

## TODO

1. Remove this TODO when done.
2. Read about Terraform AWS provider.
3. Setup EKS cluster for Wordpress, Terraform it.
a. Loadbalancing? Is Ingress/cluster IP enough?
b. Use helm for this?
c. Dockerfile/komposerize?
4. Setup MySQL on RDS via Terraform, connect it to my EKS cluster on Terraform.
5. Setup Cloudfront with Terraform, connect it to my EKS cluster.
6. Script/terraform both the RDS <-> EKS connection and EKS <-> Cloudfront connection.
7. Use AWS CLI for some of this.
8. Setup backups with Terraform.
9. Setup dev/prod/QA EKS clusters.
10. Setup diaster recovery.
11. Logging with Cloudwatch, terraformed.
a. Can we get simple monitoring going too?

## Structure

TODO: insert diagram here

## Explanation

TODO: Insert writeup here.

## Future Ideas

This is what I ran out of time to do, but would be nice.
