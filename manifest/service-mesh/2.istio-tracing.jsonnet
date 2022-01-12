function (
    EFK_ES_SVC_NAME="elasticsearch",
    EFK_NAMESPACE="kube-logging",
    CLIENT_ID="jaeger",
    CLIENT_SECRET="jaeger-secret",
    CLIENT_ROLE="jaeger-manager",
    KEYCLOAK_ADDR="KEYCLOAK_ADDR"
    CUSTOM_DOMAIN_NAME="172.22.6.18.nip.io"
"
)

[
  {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: 'jaeger-service-account',
      namespace: 'istio-system',
      labels: {
        app: 'jaeger',
      },
    },
  },
  {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRole',
    metadata: {
      name: 'jaeger-istio-system',
      labels: {
        app: 'jaeger',
      },
    },
    rules: [
      {
        apiGroups: [
          'extensions',
          'apps',
        ],
        resources: [
          'deployments',
        ],
        verbs: [
          'get',
          'list',
          'create',
          'patch',
          'update',
          'delete',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'pods',
          'services',
        ],
        verbs: [
          'get',
          'list',
          'watch',
          'create',
          'delete',
        ],
      },
      {
        apiGroups: [
          'networking.k8s.io',
        ],
        resources: [
          'ingresses',
        ],
        verbs: [
          'get',
          'list',
          'watch',
          'create',
          'delete',
          'update',
        ],
      },
      {
        apiGroups: [
          'apps',
        ],
        resources: [
          'daemonsets',
        ],
        verbs: [
          'get',
          'list',
          'watch',
          'create',
          'delete',
          'update',
        ],
      },
    ],
  },
  {
    kind: 'ClusterRoleBinding',
    apiVersion: 'rbac.authorization.k8s.io/v1',
    metadata: {
      name: 'jaeger-istio-system',
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'jaeger-service-account',
        namespace: 'istio-system',
      },
    ],
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: 'jaeger-istio-system',
    },
  },
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'jaeger-configuration',
      namespace: 'istio-system',
      labels: {
        app: 'jaeger',
        'app.kubernetes.io/name': 'jaeger',
      },
    },
    data: {
      'span-storage-type': 'elasticsearch',
      collector: 'es:\n  server-urls: http://EFK_ES_SVC_NAME.EFK_NAMESPACE.svc.cluster.local:9200\ncollector:\n  zipkin:\n    http-port: 9411\n',
      query: 'es:\n  server-urls: http://EFK_ES_SVC_NAME.EFK_NAMESPACE.svc.cluster.local:9200\n',
      agent: 'collector:\n  host-port: "jaeger-collector:14267"\n',
    },
  },
  null,
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      namespace: 'istio-system',
      name: 'jaeger-collector',
      labels: {
        app: 'jaeger',
        'app.kubernetes.io/name': 'jaeger',
        'app.kubernetes.io/component': 'collector',
      },
    },
    spec: {
      selector: {
        matchLabels: {
          app: 'jaeger',
        },
      },
      replicas: 1,
      strategy: {
        type: 'Recreate',
      },
      template: {
        metadata: {
          labels: {
            app: 'jaeger',
            'app.kubernetes.io/name': 'jaeger',
            'app.kubernetes.io/component': 'collector',
          },
          annotations: {
            'prometheus.io/scrape': 'true',
            'prometheus.io/port': '14268',
          },
        },
        spec: {
          serviceAccountName: 'jaeger-service-account',
          containers: [
            {
              image: 'docker.io/jaegertracing/jaeger-collector:1.14',
              name: 'jaeger-collector',
              args: [
                '--config-file=/conf/collector.yaml',
              ],
              ports: [
                {
                  containerPort: 14267,
                  protocol: 'TCP',
                },
                {
                  containerPort: 14268,
                  protocol: 'TCP',
                },
                {
                  containerPort: 9411,
                  protocol: 'TCP',
                },
              ],
              readinessProbe: {
                httpGet: {
                  path: '/',
                  port: 14269,
                },
              },
              volumeMounts: [
                {
                  name: 'jaeger-configuration-volume',
                  mountPath: '/conf',
                },
              ],
              env: [
                {
                  name: 'SPAN_STORAGE_TYPE',
                  valueFrom: {
                    configMapKeyRef: {
                      name: 'jaeger-configuration',
                      key: 'span-storage-type',
                    },
                  },
                },
              ],
            },
          ],
          volumes: [
            {
              configMap: {
                name: 'jaeger-configuration',
                items: [
                  {
                    key: 'collector',
                    path: 'collector.yaml',
                  },
                ],
              },
              name: 'jaeger-configuration-volume',
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      namespace: 'istio-system',
      name: 'jaeger-collector',
      labels: {
        app: 'jaeger',
        'app.kubernetes.io/name': 'jaeger',
        'app.kubernetes.io/component': 'collector',
      },
    },
    spec: {
      ports: [
        {
          name: 'jaeger-collector-tchannel',
          port: 14267,
          protocol: 'TCP',
          targetPort: 14267,
        },
        {
          name: 'jaeger-collector-http',
          port: 14268,
          protocol: 'TCP',
          targetPort: 14268,
        },
        {
          name: 'jaeger-collector-zipkin',
          port: 9411,
          protocol: 'TCP',
          targetPort: 9411,
        },
      ],
      selector: {
        'app.kubernetes.io/name': 'jaeger',
        'app.kubernetes.io/component': 'collector',
      },
      type: 'ClusterIP',
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'zipkin',
      labels: {
        app: 'jaeger',
        'app.kubernetes.io/name': 'jaeger',
        'app.kubernetes.io/component': 'zipkin',
      },
    },
    spec: {
      ports: [
        {
          name: 'jaeger-collector-zipkin',
          port: 9411,
          protocol: 'TCP',
          targetPort: 9411,
        },
      ],
      selector: {
        'app.kubernetes.io/name': 'jaeger',
        'app.kubernetes.io/component': 'collector',
      },
      type: 'ClusterIP',
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      annotations: null,
      labels: {
        app: 'jaeger',
        'app.kubernetes.io/component': 'query',
        'app.kubernetes.io/name': 'jaeger',
      },
      name: 'jaeger-query',
      namespace: 'istio-system',
    },
    spec: {
      replicas: 1,
      selector: {
        matchLabels: {
          app: 'jaeger',
        },
      },
      strategy: {
        type: 'Recreate',
      },
      template: {
        metadata: {
          annotations: {
            'prometheus.io/port': '16686',
            'prometheus.io/scrape': 'true',
          },
          creationTimestamp: null,
          labels: {
            app: 'jaeger',
            'app.kubernetes.io/component': 'query',
            'app.kubernetes.io/name': 'jaeger',
          },
        },
        spec: {
          serviceAccountName: 'jaeger-service-account',
          containers: [
            {
              name: 'gatekeeper',
              image: 'quay.io/keycloak/keycloak-gatekeeper:10.0.0',
              imagePullPolicy: 'Always',
              args: [
                '--client-id=CLIENT_ID',
                '--client-secret=CLIENT_SECRET',
                '--listen=:3000',
                '--upstream-url="http://127.0.0.1:16686"',
                '--discovery-url="https://KEYCLOAK_ADDR/auth/realms/tmax"',
                '--secure-cookie=true',
                '--skip-openid-provider-tls-verify=true',
                '--enable-self-signed-tls',
                '--skip-upstream-tls-verify=true',
                '--enable-default-deny=true',
                '--enable-refresh-tokens=true',
                '--enable-metrics=true',
                '--encryption-key=AgXa7xRcoClDEU0ZDSH4X0XhL5Qy2Z2j',
                '--forbidden-page=/html/access-forbidden.html',
                '--resources=uri="/*|roles=CLIENT_ID:CLIENT_ROLE"',
                '--enable-encrypted-token',
                '--verbose',
              ],
              ports: [
                {
                  containerPort: 3000,
                  name: 'gatekeeper',
                },
              ],
              volumeMounts: [
                {
                  name: 'gatekeeper-files',
                  mountPath: '/html',
                },
              ],
            },
            {
              args: [
                '--config-file=/conf/query.yaml',
              ],
              env: [
                {
                  name: 'SPAN_STORAGE_TYPE',
                  valueFrom: {
                    configMapKeyRef: {
                      key: 'span-storage-type',
                      name: 'jaeger-configuration',
                    },
                  },
                },
                {
                  name: 'QUERY_BASE_PATH',
                  value: '/api/jaeger',
                },
              ],
              image: 'docker.io/jaegertracing/jaeger-query:1.14',
              imagePullPolicy: 'IfNotPresent',
              name: 'jaeger-query',
              ports: [
                {
                  containerPort: 16686,
                  protocol: 'TCP',
                },
              ],
              readinessProbe: {
                failureThreshold: 3,
                httpGet: {
                  path: '/',
                  port: 16687,
                  scheme: 'HTTP',
                },
                initialDelaySeconds: 20,
                periodSeconds: 5,
                successThreshold: 1,
                timeoutSeconds: 4,
              },
              resources: {},
              terminationMessagePath: '/dev/termination-log',
              terminationMessagePolicy: 'File',
              volumeMounts: [
                {
                  mountPath: '/conf',
                  name: 'jaeger-configuration-volume',
                },
              ],
            },
          ],
          dnsPolicy: 'ClusterFirst',
          restartPolicy: 'Always',
          schedulerName: 'default-scheduler',
          terminationGracePeriodSeconds: 30,
          volumes: [
            {
              name: 'gatekeeper-files',
              configMap: {
                name: 'gatekeeper-files',
              },
            },
            {
              configMap: {
                defaultMode: 420,
                items: [
                  {
                    key: 'query',
                    path: 'query.yaml',
                  },
                ],
                name: 'jaeger-configuration',
              },
              name: 'jaeger-configuration-volume',
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      annotations: null,
      labels: {
        app: 'jaeger',
        'app.kubernetes.io/component': 'query',
        'app.kubernetes.io/name': 'jaeger',
      },
      name: 'jaeger-query',
      namespace: 'istio-system',
    },
    spec: {
      ports: [
        {
          name: 'jaeger-query',
          port: 443,
          protocol: 'TCP',
          targetPort: 3000,
        },
      ],
      selector: {
        'app.kubernetes.io/component': 'query',
        'app.kubernetes.io/name': 'jaeger',
      },
      type: 'ClusterIP',
    },
  },
  {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: 'jaeger-ingress',
      namespace: 'istio-system',
      labels: {
        app: 'jaeger',
        'app.kubernetes.io/name': 'jaeger',
        'app.kubernetes.io/component': 'query',
        'ingress.tmaxcloud.org/name': 'jaeger',
      },
      annotations: {
        'traefik.ingress.kubernetes.io/router.entrypoints': 'websecure',
      },
    },
    spec: {
      ingressClassName: 'tmax-cloud',
      tls: [
        {
          hosts: [
            'jaeger.CUSTOM_DOMAIN_NAME',
          ],
        },
      ],
      rules: [
        {
          host: 'jaeger.CUSTOM_DOMAIN_NAME',
          http: {
            paths: [
              {
                pathType: 'Prefix',
                path: '/',
                backend: {
                  service: {
                    name: 'jaeger-query',
                    port: {
                      number: 443,
                    },
                  },
                },
              },
            ],
          },
        },
      ],
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'DaemonSet',
    metadata: {
      namespace: 'istio-system',
      name: 'jaeger-agent',
      labels: {
        app: 'jaeger',
        'app.kubernetes.io/name': 'jaeger',
        'app.kubernetes.io/component': 'agent',
      },
    },
    spec: {
      selector: {
        matchLabels: {
          app: 'jaeger',
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'jaeger',
            'app.kubernetes.io/name': 'jaeger',
            'app.kubernetes.io/component': 'agent',
          },
          annotations: {
            'prometheus.io/scrape': 'true',
            'prometheus.io/port': '5778',
          },
        },
        spec: {
          containers: [
            {
              image: 'docker.io/jaegertracing/jaeger-agent:1.14',
              name: 'jaeger-agent',
              args: [
                '--config-file=/conf/agent.yaml',
              ],
              volumeMounts: [
                {
                  name: 'jaeger-configuration-volume',
                  mountPath: '/conf',
                },
              ],
              ports: [
                {
                  containerPort: 5775,
                  protocol: 'UDP',
                },
                {
                  containerPort: 6831,
                  protocol: 'UDP',
                },
                {
                  containerPort: 6832,
                  protocol: 'UDP',
                },
                {
                  containerPort: 5778,
                  protocol: 'TCP',
                },
              ],
            },
          ],
          hostNetwork: true,
          dnsPolicy: 'ClusterFirstWithHostNet',
          volumes: [
            {
              configMap: {
                name: 'jaeger-configuration',
                items: [
                  {
                    key: 'agent',
                    path: 'agent.yaml',
                  },
                ],
              },
              name: 'jaeger-configuration-volume',
            },
          ],
        },
      },
    },
  },
]
