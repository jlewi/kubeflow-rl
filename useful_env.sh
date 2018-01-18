#!/bin/sh
# Some useful environment variables to source
PROJECT=kubeflow-rl
NAMESPACE=rl
JUPYTER_SERVICE=jupyter-hub-esp
JUPYTER_INGRESS=${JUPYTER_SERVICE}

# Name of component for IAP
JUPYTER_IAP_INGRESS_NAME=jupyter-iap
ENDPOINT=jupyterhub

# Name of the ksonnet environment
ENV=gke

# Name of the core Kubeflow component
CORE_NAME=kubeflow-core

DOCS_PATH=~/git_kubeflow-rl/google_kubeflow/docs/gke/

