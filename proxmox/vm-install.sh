#!/bin/bash

# to destroy the VMs, task must be confirmed with 'yes', not confirming skips the task

terraform destroy

# install or update all VMs

terraform init -upgrade
terraform plan
#terraform apply --auto-approve
terraform apply --auto-approve -parallelism=3


echo "if cloning fails, rerun the script"
