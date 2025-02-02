#!/bin/bash

# Copyright (c) 2021 Red Hat, Inc.
# Copyright Contributors to the Open Cluster Management project

set -o errexit
set -o nounset

acm_namespace=open-cluster-management

echo "using kubeconfig $KUBECONFIG"
kubectl delete namespace hoh-system --ignore-not-found

curl -s "https://raw.githubusercontent.com/open-cluster-management/leaf-hub-spec-sync/$TAG/deploy/leaf-hub-spec-sync.yaml.template" | \
    SYNC_SERVICE_PORT="" IMAGE="" envsubst | kubectl delete -f - -n "$acm_namespace" --ignore-not-found
curl -s "https://raw.githubusercontent.com/open-cluster-management/leaf-hub-status-sync/$TAG/deploy/leaf-hub-status-sync.yaml.template" | \
    SYNC_SERVICE_PORT="" IMAGE="" envsubst | kubectl delete -f - -n "$acm_namespace" --ignore-not-found

# delete the HoH config CRD
kubectl delete -f "https://raw.githubusercontent.com/open-cluster-management/hub-of-hubs-crds/$TAG/crds/hub-of-hubs.open-cluster-management.io_config_crd.yaml" \
	--ignore-not-found

kubectl annotate mch multiclusterhub  --overwrite mch-imageOverridesCM=  -n "$acm_namespace"
kubectl delete configmap custom-repos -n "$acm_namespace" --ignore-not-found
