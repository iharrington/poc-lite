# poc-lite
Setup deployment for litecoin

###.gitlab-ci.yml

   * Untested* but should allow for the playbooks to be executed and perform the following:
        * *provided results of lint check from gitlab -> [gitlab_lint_results.png](gitlab_lint_results.png)

###cicd/ci.yml

Builds Dockerfile and pushes to [dockerhub](https://hub.docker.com/repository/docker/iharrington/poc-lite)
* latest and version number set
* Included scan results -> [docker_scan_results.txt](docker_scan_results.txt)

###cicd/cd.yml
    
Deploys helm chart to docker for desktop (easily changed to k8s cluster)

includes:
  * headless-service
  * StatefulSet (with PV/PVC)

# Terraform IAM (AWS)

###terraform/

###aws_setup.tf
**note** update keys in `terraform/aws_setup.tf` to [authenticate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication)

###iam.tf
Configured to create:

* A role - `ec2-role`
* A policy - `ec2-reader`
* A group - `ec2-reader-group`
* A user - `ec2-user`
* Link them together using `aws_iam_policy_attachment` - `ec2-reader-attachment`
