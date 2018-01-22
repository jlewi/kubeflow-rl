{
	parts(namespace, name,):: {
		service:: {
		  local serviceName = name + "-tb",
		  "apiVersion": "v1", 
		  "kind": "Service", 
		  "metadata": {
		    "name": serviceName,
		    "namespace": namespace,		    
		    "annotations": {
		       // TODO(jlewi): What happen if we represent the annotation as an object and not serialized YAML?
		       "getambassador.io/config":
		       	  std.join("\n", [ 
			      "---",
			      "apiVersion: ambassador/v0",
			      "kind:  Mapping",
			      "name: " + name + "_mapping",
			      "prefix: /tensorboard/" + name, 
			      "rewrite: /",
			      "service: " + serviceName + "." + namespace]),
			 }, //annotations
		  }, 
		  "spec": {
		    "ports": [
		      {
		        "name": "http", 
		        "port": 80, 
		        "targetPort": 80,
		      }
		    ], 
		    "selector": {
		      "app": "tensorboard",
		      "tb-job": name,
		    },
		  },
		},

		tbDeployment(logDir, secretName, secretFileName, tfImage="gcr.io/tensorflow/tensorflow:latest"):: {
		  "apiVersion": "apps/v1beta1", 
		  "kind": "Deployment", 
		  "metadata": {
		    "name": name + "-tb",
		    "namespace": namespace,
		  }, 
		  "spec": {
		    "replicas": 1, 
		    "template": {
		      "metadata": {
		        "labels": {
		          "app": "tensorboard",
		          "tb-job": name,
		        }, 
		        "name": name,
		        "namespace": namespace,
		      }, 
		      "spec": {
		        "containers": [
		          {
		            "command": [
		              "/usr/local/bin/tensorboard", 
		              "--logdir=" + logDir, 
		              "--port=80"
		            ], 
		            "image": tfImage, 
		            "name": "tensorboard", 
		            "ports": [
		              {
		                "containerPort": 80
		              }
		            ],
		            "env":   [
			           {
			           "name": "GOOGLE_APPLICATION_CREDENTIALS",
			           "value": "/secret/gcp-credentials/" + secretFileName,
			           },
			       ],
		           "volumeMounts": [{
			        "name": "credentials",
			        "mountPath": "/secret/gcp-credentials",
			        }],
		          }
		        ],
		        "volumes": [{
			            "name": "credentials",
			            "secret": {
			              "secretName": secretName,
			            },
			      }		       
		        ],
		      }
		    }
		  }
		},
	},
}