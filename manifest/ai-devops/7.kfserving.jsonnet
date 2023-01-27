function (    
    is_offline="false",
    private_registry="172.22.6.2:5000",    
    custom_domain_name="tmaxcloud.org",    
    tmax_client_secret="tmax_client_secret",
    hyperauth_url="172.23.4.105",
    hyperauth_realm="tmax",
    console_subdomain="console",    
    gatekeeper_log_level="info",    
    gatekeeper_version="v1.0.2"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";
[
    {
  "apiVersion": "apps/v1",
  "kind": "Deployment",
  "metadata": {
    "labels": {
      "app": "kserve",
      "app.kubernetes.io/name": "kserve",
      "control-plane": "kserve-controller-manager",
      "controller-tools.k8s.io": "1.0"
    },
    "name": "kserve-controller-manager",
    "namespace": "kubeflow"
  },
  "spec": {
    "selector": {
      "matchLabels": {
        "app": "kserve",
        "app.kubernetes.io/name": "kserve",
        "control-plane": "kserve-controller-manager",
        "controller-tools.k8s.io": "1.0"
      }
    },
    "template": {
      "metadata": {
        "annotations": {
          "kubectl.kubernetes.io/default-container": "manager",
          "sidecar.istio.io/inject": "false"
        },
        "labels": {
          "app": "kserve",
          "app.kubernetes.io/name": "kserve",
          "control-plane": "kserve-controller-manager",
          "controller-tools.k8s.io": "1.0"
        }
      },
      "spec": {
        "containers": [
          {
            "args": [
              "--metrics-addr=127.0.0.1:8080",
              "--leader-elect"
            ],
            "command": [
              "/manager"
            ],
            "env": [
              {
                "name": "POD_NAMESPACE",
                "valueFrom": {
                  "fieldRef": {
                    "fieldPath": "metadata.namespace"
                  }
                }
              },
              {
                "name": "SECRET_NAME",
                "value": "kserve-webhook-server-cert"
              }
            ],
            "image": std.join("", [target_registry, "docker.io/kserve/kserve-controller:v0.10.0"]),
            "imagePullPolicy": "Always",
            "name": "manager",
            "ports": [
              {
                "containerPort": 9443,
                "name": "webhook-server",
                "protocol": "TCP"
              }
            ],
            "resources": {
              "limits": {
                "cpu": "100m",
                "memory": "300Mi"
              },
              "requests": {
                "cpu": "100m",
                "memory": "200Mi"
              }
            },
            "securityContext": {
              "allowPrivilegeEscalation": false
            },
            "volumeMounts": [
              {
                "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                "name": "cert",
                "readOnly": true
              }
            ]
          },
          {
            "args": [
              "--secure-listen-address=0.0.0.0:8443",
              "--upstream=http://127.0.0.1:8080/",
              "--logtostderr=true",
              "--v=10"
            ],
            "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.13.1"]),
            "name": "kube-rbac-proxy",
            "ports": [
              {
                "containerPort": 8443,
                "name": "https",
                "protocol": "TCP"
              }
            ]
          }
        ],
        "securityContext": {
          "runAsNonRoot": true
        },
        "serviceAccountName": "kserve-controller-manager",
        "terminationGracePeriodSeconds": 10,
        "volumes": [
          {
            "name": "cert",
            "secret": {
              "defaultMode": 420,
              "secretName": "kserve-webhook-server-cert"
            }
          }
        ]
      }
    }
  }
}
]    