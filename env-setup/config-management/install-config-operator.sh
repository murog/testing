#!/usr/bin/env bash

gsutil cp gs://config-management-release/released/latest/config-management-operator.yaml config-management-operator.yaml
kubectl apply -f config-management-operator.yaml
rm config-management-operator.yaml