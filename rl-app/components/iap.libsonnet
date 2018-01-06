{
	parts(namespace):: {
		// TODO(jlewi): We need to get rid of this service and just make it possible
		// to configure the type for the jupyterHubService included in Kubeflow as NodePort
		// We will also need to add the endpoints sidecar to jupyter
		iapService:: {
		  "apiVersion": "v1", 
		  "kind": "Service", 
		  "metadata": {
		    "name": "iap-tutorial",
		    "namespace": namespace,
		  }, 
		  "spec": {
		    "ports": [
		      {
		        "name": "http", 
		        "port": 80, 
		        "protocol": "TCP", 
		        "targetPort": 8080
		      }
		    ], 
		    "selector": {
		      // Needs to stay in sync with kubeflow-core component		      
		      "app": "iap-tutorial"
		    }, 
		    "type": "NodePort"
		  }
	   }, // iapService
	   iapIngress(secretName):: {
		  "apiVersion": "extensions/v1beta1", 
		  "kind": "Ingress", 
		  "metadata": {
		    "name": "iap-jupyter-load-balancer",
		    "namespace": namespace,
		  }, 
		  "spec": {
		    "rules": [
		      {
		        "http": {
		          "paths": [
		            {
		              "backend": {
		                "serviceName": "iap-tutorial", 
		                "servicePort": 80
		              }, 
		              "path": "/*"
		            }
		          ]
		        }
		      }
		    ], 
		    "tls": [
		      {
		        "secretName": secretName,
		      }
		    ]
		  }
		}, // iapIngress
	}, // parts 
}