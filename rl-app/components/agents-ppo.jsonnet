local params = std.extVar("__ksonnet/params").components["agents-ppo"];
local k = import 'k.libsonnet';
local deployment = k.extensions.v1beta1.deployment;
local container = deployment.mixin.spec.template.spec.containersType;
local podTemplate = k.extensions.v1beta1.podTemplate;

local tfJob = import 'kubeflow/tf-job/tf-job.libsonnet';

local name = params.name;
local namespace = params.namespace;
local numGpus = params.num_gpus;
local hparamSet = params.hparam_set;
local GCPProject = params.gcp_project;
local jobTag = params.job_tag;
local logDir = params.log_dir;
local image = params.image;
local imageGpu = params.image_gpu;
local numCpu = params.num_cpu;

local network = params.network;
local policyLayers = params.policy_layers;
local valueLayers = params.value_layers;
local numAgents = params.num_agents;
local steps = params.steps;
local discount = params.discount;
local klTarget = params.kl_target;
local klCutoffFactor = params.kl_cutoff_factor;
local klCutoffCoef = params.kl_cutoff_coef;
local algorithm = params.algorithm;
local trainerMode = params.trainer_mode;

local args = [
  "--logdir=" + logDir,
  "--config=" + hparamSet,
  "--network=" + network,
  "--policy_layers=" + policyLayers,
  "--value_layers=" + valueLayers,
  "--num_agents=" + numAgents,
  "--steps=" + steps,
  "--discount=" + discount,
  "--kl_target=" + klTarget,
  "--kl_cutoff_factor=" + klCutoffFactor,
  "--kl_cutoff_coef=" + klCutoffCoef,
  "--algorithm=" + algorithm,
  "--mode=" + trainerMode
];

local workerSpec = if numGpus > 0 then
  	tfJob.parts.tfJobReplica("MASTER", 1, args, imageGpu, numGpus)
  	else
  	tfJob.parts.tfJobReplica("MASTER", 1, args, image);

local replicas = std.map(function(s)
  s + {
    template+: {
      spec+:  {
        containers: [
          s.template.spec.containers[0] + {
            resources: {
              limits: {
                cpu: numCpu
              },
              requests: {
                cpu: numCpu
              }
            },
          },
        ],
      },
    },
  },
  std.prune([workerSpec]));

local job = tfJob.parts.tfJob(name, namespace, replicas);

std.prune(k.core.v1.list.new([job]))
