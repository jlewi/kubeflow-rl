#!/bin/bash
#
# usage: create_sample_app.sh <project> <namespace> <service>

PROJECT=$1
NAMESPACE=$2
SERVICE=$3

if [ -z ${PROJECT} ]; then
  echo Error PROJECT must be provided on the command line
  echo usage: ${USAGE}
  exit 1
fi

if [ -z ${NAMESPACE} ]; then
  echo Error NAMESPACE must be provided on the command line
  echo usage: ${USAGE}
  exit 1
fi

if [ -z ${SERVICE} ]; then
  echo Error service_name must be provided on the command line
  echo usage: ${USAGE}
  exit 1
fi

ENDPOINT_URL="${SERVICE}.endpoints.${PROJECT}.cloud.goog"
SERVICE_VERSION=$(gcloud endpoints services describe ${ENDPOINT_URL} --format='value(serviceConfig.id)')

# Create the sample app deployment file:
echo creating iap-tutorial-app.yaml
cat > iap-tutorial-app.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: iap-tutorial
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: iap-tutorial
    spec:
      containers:
      - name: esp
        image: gcr.io/endpoints-release/endpoints-runtime:1
        args: [
          "-p", "8080",
          "-a", "127.0.0.1:8081",
          "-s", "${ENDPOINT_URL}",
          "-v", "${SERVICE_VERSION}",
          "-z", "healthz",
        ]
        readinessProbe:
          httpGet:
            path: /healthz
            port: 8080
        ports:
          - containerPort: 8080
      - name: app
        image: python:3-slim
        command:
        - python3
        - "-c"
        - |
          from http.server import HTTPServer, BaseHTTPRequestHandler
          PORT=8081
          class RequestHandler(BaseHTTPRequestHandler):
              def do_GET(self):
                  self.send_response(200)
                  self.send_header('Content-type','text/html')
                  self.end_headers()
                  self.wfile.write(bytes("""
                  <!doctype html><html>
                <head><title>IAP Tutorial</title><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css"></head>
                <body>
                <div class="container">
                <div class="row">
                <div class="col s2">&nbsp;</div>
                <div class="col s8">
                <div class="card blue">
                    <div class="card-content white-text">
                        <h4>Hello %s</h4>
                    </div>
                    <div class="card-action">
                        <a href="/_gcp_iap/identity">Identity JSON</a>
                        <a href="/_gcp_iap/clear_login_cookie">Logout</a>
                    </div>
                </div></div></div></div>
                </body></html>
                  """ % self.headers.get("x-goog-authenticated-user-email","unauthenticated user").split(':')[-1], "utf8"))
          print("Listing on port", PORT)
          server = HTTPServer(('0.0.0.0', PORT), RequestHandler)
          server.serve_forever()
        ports:
          - containerPort: 8081
        readinessProbe:
          httpGet:
            host: "${ENDPOINT_URL}"
            path: /_gcp_iap/identity
            port: 443
            scheme: HTTPS
          periodSeconds: 10
          timeoutSeconds: 5
          successThreshold: 1
          failureThreshold: 2
EOF
