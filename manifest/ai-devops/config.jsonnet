function (
    is_offline="false",
    private_registry="172.22.6.2:5000",
    ai_devops_namespace="kubeflow",
    istio_namespace="istio-system",
    knative_namespace="knative-serving",     
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
local katib_cm_image_tag = "v0.12.0";
[
{
   "apiVersion": "v1",
   "data": {
      "early-stopping": {\n  \"medianstop\": {\n    \"image\": \"std.join("", [target_registry, "docker.io/kubeflowkatib/earlystopping-medianstop:", katib_cm_image_tag])\"\n  }\n},
      "metrics-collector-sidecar": {\n  \"StdOut\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/file-metrics-collector:", katib_cm_image_tag])\n  },\n  \"File\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/file-metrics-collector:", katib_cm_image_tag])\n  },\n  \"TensorFlowEvent\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/tfevent-metrics-collector:", katib_cm_image_tag]),\n    \"resources\": {\n      \"limits\": {\n        \"memory\": \"1Gi\"\n      }\n    }\n  }\n},
      "suggestion": {\n  \"random\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-hyperopt:", katib_cm_image_tag])\n  },\n  \"tpe\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-hyperopt:", katib_cm_image_tag])\n  },\n  \"grid\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-chocolate:", katib_cm_image_tag])\n  },\n  \"hyperband\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-hyperband:", katib_cm_image_tag])\n  },\n  \"bayesianoptimization\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-skopt:", katib_cm_image_tag])\n  },\n  \"cmaes\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-goptuna:", katib_cm_image_tag])\n  },\n  \"sobol\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-goptuna:", katib_cm_image_tag])\n  },\n  \"enas\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-enas:", katib_cm_image_tag]),\n    \"resources\": {\n      \"limits\": {\n        \"memory\": \"200Mi\"\n      }\n    }\n  },\n  \"darts\": {\n    \"image\": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-darts:", katib_cm_image_tag])\n  }\n}
   },
   "kind": "ConfigMap",
   "metadata": {
      "name": "katib-config",
      "namespace": ai_devops_namespace
   }
}
]