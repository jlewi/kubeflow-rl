{
  global: {
    // User-defined global parameters; accessible to all component and environments, Ex:
    // replicas: 4,
  },
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
    "kubeflow-core": {
      cloud: "null",
      disks: "",
      jupyterHubAuthenticator: "iap",
      jupyterHubEndpoint: "jupyterhub.endpoints.kubeflow-rl.cloud.goog",
      jupyterHubServiceType: "ClusterIP",
      jupyterHubServiceVersion: "2018-01-10r4",
      name: "kubeflow-core",
      namespace: "rl",
      tfDefaultImage: "null",
      tfJobImage: "gcr.io/tf-on-k8s-dogfood/tf_operator:v20180117-04425d9-dirty-e3b0c44",
      tfJobUiServiceType: "ClusterIP",
    },
    "jupyter-iap": {
      certsSecretName: "iap-ingress-ssl",      
      name: "jupyter-iap",
      namespace: "rl",
    },
  },
}
