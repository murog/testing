#!/usr/bin/env bash

# Variables
export CLUSTER_NAME=$(kubectl config current-context)
export BASE_DIR=${BASE_DIR:="${PWD}/.."}
echo "BASE_DIR set to $BASE_DIR"

echo "### "
echo "### Begin configuring ACM Operator"
echo "### "

## Poll the Config Repository
(set -x; cat $BASE_DIR/config-management/config_sync.yaml | 
    sed 's@<REPO_URL>@'${REPO_URL}@g | 
    sed 's@<CLUSTER_NAME>@'${CLUSTER_NAME}@g | 
    sed 's@<SYNC_BRANCH>@'${SYNC_BRANCH}@g | 
    sed 's@<POLICY_DIR>@'${POLICY_DIR}@g | 
    kubectl apply -f -)

