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
      namespace: "default",
      tfJobImage: "gcr.io/tf-on-k8s-dogfood/tf_operator:v20171214-0bd02ac",
    },
    "agents-ppo": {
      gcp_project: "kubeflow-rl",
      hparam_set: "pybullet_kuka_ff",
      image: "gcr.io/kubeflow-rl/agents-ppo:cpu-cae5b3af",
      image_gpu: "null",
      job_tag: "0e90193e",
      log_dir: "gs://kubeflow-rl-kf/jobs/pybullet-kuka-ff-0e90193e",
      name: "pybullet-kuka-ff-0e90193e",
      namespace: "rl",
      num_cpu: 30,
      num_gpus: 0,
      num_masters: 1,
      num_ps: 1,
      num_replicas: 1,
      num_workers: 1,
      network: "feed_forward_gaussian",
      policy_layers: "200,100",
      value_layers: "200,100",
      num_agents: 30,
      steps: 1e7,
      discount: 0.995,
      kl_target: 1e-2,
      kl_cutoff_factor: 2,
      kl_cutoff_coef: 1000,
      algorithm: "agents.ppo.PPOAlgorithm",
      trainer_mode: "train_and_render"
    },
  },
}
