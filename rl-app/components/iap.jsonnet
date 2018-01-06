local params = std.extVar("__ksonnet/params").components["iap"];
// TODO(https://github.com/ksonnet/ksonnet/issues/222): We have to add namespace as an explicit parameter
// because ksonnet doesn't support inheriting it from the environment yet.

local k = import 'k.libsonnet';
local iap = import "iap.libsonnet";

local name = params.name;
local namespace = params.namespace;
local secretName = params.secretName;


std.prune(k.core.v1.list.new([
	iap.parts(namespace).iapService,
	iap.parts(namespace).iapIngress(secretName),	
]))
