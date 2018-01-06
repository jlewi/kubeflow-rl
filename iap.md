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

Wait for the backend id for the ingress

```
./get_backend_id.sh kubeflow-rl rl iap-tutorial
Waiting for backend id PROJECT=kubeflow-rl NAMESPACE=rl SERVICE=iap-tutorial...
BACKEND_ID=9197620295647407514
```

