local params = import "../../components/params.libsonnet";
params + {
  components +: {
    // Insert component parameter overrides here. Ex:
    // guestbook +: {
    //   name: "guestbook-dev",
    //   replicas: params.global.replicas,
    // },
    "kubeflow-core" +: {
      namespace: "iap-test",
    },
    envoy +: {
      namespace: "iap-test",
    },
    tensorboard +: {
      namespace: "iap-test",
    },
  },
}
