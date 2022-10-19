#!/bin/bash

# Normalize Input Command
COMMAND=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# Validate Inputs
if [ -z "$COMMAND" ] || ([ "$COMMAND" != "apply" ] &&  [ "$COMMAND" != "destroy" ] && [ "$COMMAND" != "validate" ] && [ "$COMMAND" != "graph" ] && [ "$COMMAND" != "plan" ]); then
  echo "You must pass one of the following arguments to this script: apply, destroy, validate."
  exit 1
fi

# Changes Must Be Commited Before Apply
if [ ! -z $SKIP_COMMIT_CHECK ]; then
  COMMITTED=$(git status | grep "nothing to commit, working tree clean")
  if [ -z "$COMMITTED" ] && [ "$COMMAND" == "apply" ]; then
    echo "You must commit your code before running apply!"
    exit 2
  fi
fi

# Bootstrap Environment (Simulate Gitlab Action Runner Environment Initialization)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ -f "$DIR/bootstrapEnvironment.sh" ]; then
  . $DIR/bootstrapEnvironment.sh
else
  echo "Error: The bootstrap environment script is missing!"
  echo "Follow the instructions included at the top of $DIR/bootstrapEnvironment.template.sh."
  exit 1
fi

cd $DIR/../src

terraform workspace select ${GITHUB_REF#refs/heads/}|| terraform workspace new ${GITHUB_REF#refs/heads/}

terraform init -backend-config="bucket=$BUCKET" -backend-config="key=$GITHUB_REPOSITORY" -backend-config="encrypt=true" -backend-config="kms_key_id=$KMS_KEY_ID" -backend-config="dynamodb_table=$DYNAMODB_TABLE"

terraform $@
