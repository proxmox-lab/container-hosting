#!/bin/bash

#######################################################################################
# Steps:
# 1. Copy this file to bootstrapEnvironment.sh.
# 2. Populate the environment variables listed below.
# 3. Run ./_local_only/runTerraform.sh validate|apply|destroy from the project root.
#
# Note:
# Any action taken will affect the environment tied to the branch you are currently on.
#######################################################################################
# AWS Provider Variables
export AWS_DEFAULT_REGION=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

# Simulate Default Github Action Runner Variables
export GITHUB_REF=refs/heads/$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo development)
export GITHUB_REPOSITORY=proxmox-lab/container-hosting
export GITHUB_SHA=$(git rev-parse HEAD 2>/dev/null || echo 0000000000000000000000000000000000000000)

# Inputs defined in the root inputs.tf file.
export TF_VAR_GIT_REPOSITORY=$GITHUB_REPOSITORY
export TF_VAR_GIT_SHORT_SHA=${GITHUB_SHA:~8}
export TF_VAR_PVE_HOST=
export TF_VAR_PVE_NODE=
export TF_VAR_PVE_PASSWORD=
export TF_VAR_PVE_POOL=
export TF_VAR_PVE_USER=
export TF_VAR_SALTMASTER=

# Proxmox Provider Variables
export PM_API_URL="https://${TF_VAR_PVE_HOST}:8006/api2/json"
export PM_USER="${TF_VAR_PVE_USER}@pam"
export PM_PASS="${TF_VAR_PVE_PASSWORD}"

# State Bucket Variables
export BUCKET=
export KEY=$GITHUB_REPOSITORY
export DYNAMODB_TABLE=
export KMS_KEY_ID=

# Debugging
# export SKIP_COMMIT_CHECK=YES
# export TF_LOG=TRACE
# export TF_LOG_PATH=terraform.log
