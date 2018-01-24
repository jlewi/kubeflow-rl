local params = std.extVar("__ksonnet/params").components.envoy;
// TODO(https://github.com/ksonnet/ksonnet/issues/222): We have to add namespace as an explicit parameter
// because ksonnet doesn't support inheriting it from the environment yet.

local k = import 'k.libsonnet';
local envoy = import "kubeflow/core/envoy.libsonnet";

local name = params.name;
local namespace = params.namespace;
local audiences = std.split(params.audiences, ',');
envoy.parts(namespace).all(params.envoyImage, params.secretName, params.ipName, audiences)
