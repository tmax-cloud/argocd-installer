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
      "early-stopping": {
           "medianstop": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/earlystopping-medianstop:", katib_cm_image_tag])
        }
      },
      "metrics-collector-sidecar": {
           "StdOut": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/file-metrics-collector:", katib_cm_image_tag])
        },
        "File": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/file-metrics-collector:", katib_cm_image_tag])
        },
        "TensorFlowEvent": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/tfevent-metrics-collector:", katib_cm_image_tag]),
          "resources": {
               "limits": {
                 "memory": "1Gi"
            }
          }
        }
      },
      "suggestion": {
           "random": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-hyperopt:", katib_cm_image_tag])
        },
        "tpe": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-hyperopt:", katib_cm_image_tag])
        },
        "grid": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-chocolate:", katib_cm_image_tag])
        },
        "hyperband": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-hyperband:", katib_cm_image_tag])
        },
        "bayesianoptimization": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-skopt:", katib_cm_image_tag])
        },
        "cmaes": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-goptuna:", katib_cm_image_tag])
        },
        "sobol": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-goptuna:", katib_cm_image_tag])
        },
        "enas": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-enas:", katib_cm_image_tag]),
          "resources": {
               "limits": {
                 "memory": "200Mi"
            }
          }
        },
        "darts": {
             "image": std.join("", [target_registry, "docker.io/kubeflowkatib/suggestion-darts:", katib_cm_image_tag])
        }
      }
   },
   "kind": "ConfigMap",
   "metadata": {
      "name": "katib-config",
      "namespace": ai_devops_namespace
   }
}
]