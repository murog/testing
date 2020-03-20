#!/usr/bin/env bash

# Variables
export CLUSTER_NAME=$(kubectl config current-context)
export BASE_DIR=${BASE_DIR:="${PWD}/.."}
echo "BASE_DIR set to $BASE_DIR"

echo "### "
echo "### Begin configuring Policy Controller"
echo "### "

(set -x; cat $BASE_DIR/config-management/policy_controller_config.yaml | 
    kubectl apply -f -)


