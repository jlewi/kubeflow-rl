#!/bin/bash
# A simple script to create the openapi swagger spec that can be used to put an http service behind IAP
#
# Usage:
# create_iap_openapi.sh project namespace service_name ingress_name
#
PROJECT=$1
NAMESPACE=$2
SERVICE=$3
INGRESS=$4

# TODO(jlewi): raise an error if any of the above values aren't set.

NODE_PORT=$(kubectl --namespace=${NAMESPACE} get svc ${SERVICE} -o jsonpath='{.spec.ports[0].nodePort}')
while [[ -z ${BACKEND_ID} ]]; 
do BACKEND_ID=$(gcloud compute --project=${PROJECT} backend-services list --filter=name~k8s-be-${NODE_PORT}- --format='value(id)'); 
echo "Waiting for backend id PROJECT=${PROJECT} NAMESPACE=${NAMESPACE} SERVICE=${SERVICE}..."; 
sleep 2; 
done
echo BACKEND_ID=${BACKEND_ID}

while [[ -z $INGRESS_IP ]]; 
do INGRESS_IP=$(kubectl --namespace=${NAMESPACE} get ingress ${INGRESS} -o jsonpath='{.status.loadBalancer.ingress[].ip}'); 
echo "Waiting for ingress IP PROJECT=${PROJECT} NAMESPACE=${NAMESPACE} INGRESS=${INGRESS}..."; 
sleep 2; 
done

echo BACKEND_ID=${BACKEND_ID}
echo INGRESS_IP=${INGRESS_IP}

# We use the service name as the name for the service
ENDPOINT_URL="${SERVICE}.endpoints.${PROJECT}.cloud.goog"
echo ENDPOINT_URL=${ENDPOINT_URL}

echo Writing openap spec to ${SERVICE}-openapi.yaml

cat > ${SERVICE}-openapi.yaml <<EOF
swagger: "2.0"
info:
  description: "wildcard config for any HTTP service behind IAP."
  title: "General HTTP Service using IAP"
  version: "1.0.0"
basePath: "/"
consumes:
- "application/json"
produces:
- "application/json"
schemes:
- "https"
paths:
  "/**":
    get:
      operationId: Get
      responses:
        '200':
          description: Get
        default:
          description: Error
    delete:
      operationId: Delete
      responses:
        '204':
          description: Delete
        default:
          description: Error
    patch:
      operationId: Patch
      responses:
        '200':
          description: Patch
        default:
          description: Error
    post:
      operationId: Post
      responses:
        '200':
          description: Post
        default:
          description: Error
    put:
      operationId: Put
      responses:
        '200':
          description: Put
        default:
          description: Error
securityDefinitions:
  google_jwt:
    authorizationUrl: ""
    flow: "implicit"
    type: "oauth2"
    # This must match the 'iss' field in the JWT.
    x-google-issuer: "https://cloud.google.com/iap"
    # Update this with your service account's email address.
    x-google-jwks_uri: "https://www.gstatic.com/iap/verify/public_key-jwk"
    # This must match the "aud" field in the JWT. You can add multiple audiences to accept JWTs from multiple clients.
    x-google-audiences: "${JWT_AUDIENCE}"
host: "${ENDPOINT_URL}"
x-google-endpoints:
- name: "${ENDPOINT_URL}"
  target: "${INGRESS_IP}"
EOF
