# Load .env variables
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Terraform init
init:
	terraform init -backend-config="storage_account_name=${ARM_STORAGE_ACCOUNT}" \
                   -backend-config="container_name=${ARM_CONTAINER_NAME}" \
                   -backend-config="key=${ARM_TF_KEY}" \
                   -backend-config="resource_group_name=${ARM_RESOURCE_GROUP}" \
                   -backend-config="subscription_id=${ARM_SUBSCRIPTION_ID}" \
                   -backend-config="client_id=${ARM_CLIENT_ID}" \
                   -backend-config="client_secret=${ARM_CLIENT_SECRET}" \
                   -backend-config="tenant_id=${ARM_TENANT_ID}"

# Terraform plan
plan:
	terraform plan

# Terraform apply
apply:
	terraform apply -auto-approve
