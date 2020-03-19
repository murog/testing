#!/usr/bin/env bash

set -e

echo "### "
echo "### Begin Provision GKE"
echo "### "

## Check if cluster already exists to avoid errors
EXISTING_CLUSTER=$(gcloud container clusters list --format="value(name)" --filter="name ~ ${CLUSTER_NAME_1} AND location:${CLUSTER_ZONE_1}")

if [ "${EXISTING_CLUSTER}" == "${CLUSTER_NAME_1}" ]; then
    echo "Cluster already created."
else
    echo "Creating cluster..."
    gcloud beta container clusters create ${CLUSTER_NAME_1} --zone ${CLUSTER_ZONE_1} \
        --username "admin" \
        --machine-type "n1-standard-4" \
        --image-type "COS" \
        --disk-size "100" \
        --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
        --num-nodes "2" \
        --enable-autoscaling --min-nodes 2 --max-nodes 8 \
        --network "default" \
        --enable-ip-alias \
        --cluster-version=${CLUSTER_VERSION} \
        --enable-stackdriver-kubernetes \
        --identity-namespace=${PROJECT}.svc.id.goog \
        --labels csm=
fi

echo "Getting cluster credentials"
gcloud container clusters get-credentials ${CLUSTER_NAME_1} --zone ${CLUSTER_ZONE_1}

echo "Renaming kubectx context to ${CLUSTER_NAME_1} and switching to context"
kubectx ${CLUSTER_NAME_1}=gke_${PROJECT}_${CLUSTER_ZONE_1}_${CLUSTER_NAME_1}
kubectx ${CLUSTER_NAME_1}

KUBECONFIG= kubectl config view --minify --flatten --context=$CLUSTER_NAME_1 > $CLUSTER_KUBECONFIG_1

EXISTING_BINDING=$(kubectl get clusterrolebinding cluster-admin-binding -o json | jq -r '.metadata.name')
if [ "${EXISTING_BINDING}" == "cluster-admin-binding" ]; then
    echo "clusterrolebinding already exists."
else
    echo "Creating clusterrolebinding"
    kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user="$(gcloud config get-value core/account)"
fi


## Check if cluster already exists to avoid errors
EXISTING_CLUSTER=$(gcloud container clusters list --format="value(name)" --filter="name ~ ${CLUSTER_NAME_2} AND location:${CLUSTER_ZONE_2}")

if [ "${EXISTING_CLUSTER}" == "${CLUSTER_NAME_2}" ]; then
    echo "Cluster already created."
else
    echo "Creating cluster..."
    gcloud beta container clusters create ${CLUSTER_NAME_2} --zone ${CLUSTER_ZONE_2} \
        --username "admin" \
        --machine-type "n1-standard-4" \
        --image-type "COS" \
        --disk-size "100" \
        --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
        --num-nodes "2" \
        --enable-autoscaling --min-nodes 2 --max-nodes 8 \
        --network "default" \
        --enable-ip-alias \
        --cluster-version=${CLUSTER_VERSION} \
        --enable-stackdriver-kubernetes \
        --identity-namespace=${PROJECT}.svc.id.goog \
        --labels csm=
fi

echo "Getting cluster credentials"
gcloud container clusters get-credentials ${CLUSTER_NAME_2} --zone ${CLUSTER_ZONE_2}

echo "Renaming kubectx context to ${CLUSTER_NAME_2} and switching to context"
kubectx ${CLUSTER_NAME_2}=gke_${PROJECT}_${CLUSTER_ZONE_2}_${CLUSTER_NAME_2}
kubectx ${CLUSTER_NAME_2}

KUBECONFIG= kubectl config view --minify --flatten --context=$CLUSTER_NAME_2 > $CLUSTER_KUBECONFIG_2

EXISTING_BINDING=$(kubectl get clusterrolebinding cluster-admin-binding -o json | jq -r '.metadata.name')
if [ "${EXISTING_BINDING}" == "cluster-admin-binding" ]; then
    echo "clusterrolebinding already exists."
else
    echo "Creating clusterrolebinding"
    kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user="$(gcloud config get-value core/account)"
fi

echo "### "
echo "### Provision GKE complete"
echo "### "
