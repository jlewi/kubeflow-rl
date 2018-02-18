local params = import "../../components/params.libsonnet";
params + {
  components +: {
    // Insert component parameter overrides here. Ex:
    // guestbook +: {
    //   name: "guestbook-dev",
    //   replicas: params.global.replicas,
    // },
    "agents-ppo" +: {
      gcp_project: "kubeflow-dev",
      gcp_secret: "kubeflow-rl-gcp",
      image: "gcr.io/kubeflow-dev/agents-ppo:cpu-cae5b3af",
      job_tag: "0218-0117-352d",
      log_dir: "gs://kubeflow-dev-jlewi/jobs/pybullet-kuka-ff-0218-0117-352d",
      name: "pybullet-kuka-ff-0218-0117-352d",
      namespace: "jlewi-rl",
      num_cpu: 2,
      secret_file_name: "secret.json",
    },
    tensorboard +: {
      log_dir: "gs://kubeflow-dev-jlewi/jobs/pybullet-kuka-ff-0218-0117-352d",
      name: "pybullet-kuka-ff-0218-0117-352d",
      namespace: "jlewi-rl",
      secret: "kubeflow-rl-gcp",
      secret_file_name: "secret.json",
    },
  },
}
