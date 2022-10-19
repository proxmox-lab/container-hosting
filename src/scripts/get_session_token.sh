#!/bin/bash

set -e

read access_key secret_key session_token < <(echo $(aws sts get-session-token --duration-seconds 1800 | jq -r '.[] | .AccessKeyId, .SecretAccessKey, .SessionToken'))

jq -n --arg access_key $access_key --arg secret_key $secret_key --arg session_token $session_token '{ "access_key": $access_key, "secret_key": $secret_key, "session_token": $session_token }'
