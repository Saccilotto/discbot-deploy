#!/bin/bash

# Navigate to the Terra folder and run Terraform
cd ./Terra
terraform init
terraform apply -auto-approve

# Check if Terraform apply was successful
if [ $? -ne 0 ]; then
    echo "Terraform apply failed. Exiting."
    exit 1
fi

# Navigate to the Anstack folder and run the Ansible playbook
cd ./Anstack
ansible-playbook setup_stack.yml

# Check if Ansible playbook run was successful
if [ $? -ne 0 ]; then
    echo "Ansible playbook run failed. Exiting."
    exit 1
fi

echo "Terraform and Ansible playbook run completed successfully."