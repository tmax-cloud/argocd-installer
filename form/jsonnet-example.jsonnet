function (
  // 이름은 변경해도 되지만 하단의 두 변수는 꼭 선언해주어야 함
  // 이름을 다르게 사용할시 application/helm/templates의 모듈 application yaml에서도 이름을 변경
  is_offline="false",
  private_registry="registry.hypercloud.org",
  // 모듈에서 여러 jsonnet 파일을 작성할 경우 모든 파일에 동일하게 변수들을 선언해주어야 함
  // 추가적인 변수 예시
  example_var="example_val",
  example_flag="true/false"
)

// 이름은 변경해도 되지만 아래와 같은 방식을 이용하여 폐쇄망일 경우 image 경로 치환을 해주어야함
local target_registry = if is_offline == "false" then "" else private_registry + "/";

// web에서 yaml to convert한 뒤 변수화 필요한 부분을 수정
[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "labels": {
        "hypercloud": "multi-operator"
      },
      "name": "hypercloud-multi-operator-controller-manager",
      "namespace": "hypercloud5-system"
    },
    "spec": {
      "replicas": 1,
      "selector": {
        "matchLabels": {
          "hypercloud": "multi-operator"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "hypercloud": "multi-operator"
          }
        },
        "spec": {
          "containers": [
            {
              "args": [
                "--metrics-addr=127.0.0.1:8080",
                "--enable-leader-election"
              ],
              "command": [
                "/manager"
              ],
              "env": [              
                {
                  "name": "HC_DOMAIN",
                  // 고정값이 아닌 경우 아래와같이 변수를 사용 가능
                  "value": example_var
                }                
              ],
              // std.join 함수를 이용하여 폐쇄망 처리
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/hypercloud-multi-operator:b5.0.26.13"]),
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
                  "memory": "100Mi"
                },
                "requests": {
                  "cpu": "100m",
                  "memory": "20Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/tmp/k8s-webhook-server/serving-certs",
                  "name": "cert",
                  "readOnly": true
                },
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "hypercloud-multi-operator-controller-manager-token",
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
              "image": std.join("", [target_registry, "gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0"]),
              "name": "kube-rbac-proxy",
              "ports": [
                {
                  "containerPort": 8443,
                  "name": "https"
                }
              ],
              "resources": {
                "limits": {
                  "cpu": "100m",
                  "memory": "30Mi"
                },
                "requests": {
                  "cpu": "100m",
                  "memory": "20Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/var/run/secrets/kubernetes.io/serviceaccount",
                  "name": "hypercloud-multi-operator-controller-manager-token",
                  "readOnly": true
                }
              ]
            }
          ],
          "serviceAccountName": "hypercloud-multi-operator-controller-manager",
          "terminationGracePeriodSeconds": 10,
          "volumes": [
            {
              "name": "cert",
              "secret": {
                "defaultMode": 420,
                "secretName": "hypercloud-multi-operator-webhook-server-cert"
              }
            },
            {
              "name": "hypercloud-multi-operator-controller-manager-token",
              "secret": {
                "defaultMode": 420,
                "secretName": "hypercloud-multi-operator-controller-manager-token"
              }
            }
          ]
        }
      }
    }
  }
] + (
  // if문을 이용하여 resource의 배포여부를 결정하게 할 수 있음
  if example_flag == "true" then [
    {
      "apiVersion": "networking.k8s.io/v1",
      "kind": "Ingress",
      "metadata": {
        "labels": {
          "ingress.tmaxcloud.org/name": "hyperauth"
        },
        "annotations": {
          "traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
        },
        "name": "hyperauth-api-gateway-ingress",
        "namespace": "hyperauth"
      },
      "spec": {
        "ingressClassName": "tmax-cloud",
        "rules": [
          {
            "host": "hyperauth.domain.com",
            "http": {
              "paths": [
                {
                  "backend": {
                    "service": {
                      "name": "hyperauth",
                      "port": {
                        "number": 8080
                      }
                    }
                  },
                  "path": "/",
                  "pathType": "Prefix"
                }
              ]
            }
          }
        ],
        "tls": [
          {
            "hosts": [
              "hyperauth.domain.com"
            ],
            "secretName": "hyperauth-https-secret"
          }
        ]
      }
    }
  ] else []
) 
// else []를 생략할 경우 빈리소스가 아닌 null이 되어 에러가 발생하므로 주의