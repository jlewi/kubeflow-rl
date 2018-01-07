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
      disks: "null",
      jupyterHubEndpoint: "jupyterhub.endpoints.kubeflow-rl.cloud.goog",
      jupyterHubServiceType: "ClusterIP",
      jupyterHubServiceVersion: "2018-01-07r1",
      name: "kubeflow-core",
      namespace: "rl",
      tfDefaultImage: "null",
      tfJobImage: "gcr.io/tf-on-k8s-dogfood/tf_operator:v20171223-37af20d",
      tfJobUiServiceType: "ClusterIP",
    },
    "jupyter-iap": {
      certsSecretName: "iap-ingress-ssl",      
      name: "jupyter-iap",
      namespace: "rl",
    },
  },
}
