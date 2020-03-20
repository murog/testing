#!/usr/bin/env bash

echo "### "
echo "### Installing Anthos Config Management"
echo "### "

gsutil cp gs://config-management-release/released/latest/config-management-operator.yaml config-management-operator.yaml
kubectl apply -f config-management-operator.yaml
rm config-management-operator.yaml