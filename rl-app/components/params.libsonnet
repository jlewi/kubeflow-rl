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
      name: "kubeflow-core",
      namespace: "rl",
      tfDefaultImage: "null",
      tfJobImage: "gcr.io/tf-on-k8s-dogfood/tf_operator:v20171223-37af20d",
      tfJobUiServiceType: "ClusterIP",
    },
    "iap": {
      name: "iap",
      namespace: "rl",
      secretName: "iap-ingress-ssl",
    },
  },
}
