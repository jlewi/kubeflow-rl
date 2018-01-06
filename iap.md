# Setting Up IAP on GKE

This are the instructions for setting up IAP on the Kubeflow cluster being used by the project
kubeflow-rl to experiment with TensorFlow agents, RL and Kubeflow.

Create a self signed certificate

TODO(jlewi): How can we get a signed certificate so we don't get Chrome warnings.

```
PROJECT=$(gcloud config get-value project)
ENDPOINT_URL="kubeflow.endpoints.${PROJECT}.cloud.goog"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -subj "/CN=${ENDPOINT_URL}/O=Google LTD./C=US" \
  -keyout ~/tmp/tls.key -out ~/tmp/tls.crt

```

Certificates for project kubeflow-rl are stored in `gs://kubeflow-rl-secrets`

Create the K8s secret

```
kubectl create secret generic iap-ingress-ssl  --from-file=${HOME}/tmp/tls.crt --from-file=${HOME}/tmp/tls.key
```

Deploy the K8s resources

```
cd rl-app
ks apply gke -c iap
```

Create the OpenAPI spec to use with cloud endpoints

```
./create_iap_openapi.sh kubeflow-rl rl iap-tutorial iap-jupyter-load-balancer
```

Create the service

```
gcloud --project=${PROJECT} endpoints services deploy iap-tutorial-openapi.yaml
```

Create oauth client credentials

TODO(jlewi): Link to instructions when they are available

Enable IAP

```
export CLIENT_ID=...
export CLIENT_SECRET=...
./enable_iap.sh kubeflow-rl rl iap-tutorial
```
