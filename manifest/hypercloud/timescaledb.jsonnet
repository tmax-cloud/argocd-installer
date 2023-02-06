function (
  is_offline="false",
  private_registry="registry.hypercloud.org",
  hypercloud_hpcd_mode="multi",
  hypercloud_kafka_enabled="\"true\"",
  hyperauth_url="hyperauth.172.22.6.18.nip.io",
  hyperauth_client_secret="tmax_client_secret",
  domain="tmaxcloud.org",
  hyperauth_subdomain="hyperauth",
  console_subdomain="console",
  kubectl_timeout="21600",
  storageClass="default",
  aws_enabled="true",
  vsphere_enabled="true",
  time_zone="UTC",
  multi_operator_log_level="info",
  single_operator_log_level="info",
  api_server_log_level="INFO",
  timescaledb_log_level="WARNING",
  timescaledb_audit_chunk_time_interval="7 days",
  timescaledb_audit_retention_policy="1 years",
  timescaledb_event_chunk_time_interval="1 days",
  timescaledb_event_retention_policy="1 months",
  timescaledb_metering_hour_chunk_time_interval="1 days",
  timescaledb_metering_hour_retention_policy="1 months",
  timescaledb_metering_day_chunk_time_interval="1 months",
  timescaledb_metering_day_retention_policy="1 years",
  timescaledb_metering_month_chunk_time_interval="1 years",
  timescaledb_metering_month_retention_policy="1 years",
  timescaledb_metering_year_chunk_time_interval="1 years",
  timescaledb_metering_year_retention_policy="10 years"
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    apiVersion: 'v1',
    data: {
      'INIT_DB_SQL.sh': std.join("\n",
        [
          "#!/bin/bash",
          "psql -d \"$1\" <<__SQL__",
          "CREATE TABLE AUDIT (ID VARCHAR(40) NOT NULL, USERNAME VARCHAR(255), USERAGENT VARCHAR(255), NAMESPACE VARCHAR(255), APIGROUP VARCHAR(255), APIVERSION VARCHAR(32), RESOURCE VARCHAR(64), NAME VARCHAR(255), STAGE VARCHAR(32), STAGETIMESTAMP TIMESTAMP NOT NULL, VERB VARCHAR(32), CODE INT, STATUS VARCHAR(255), REASON VARCHAR(255), MESSAGE VARCHAR(255));",
          std.join("", ["SELECT create_hypertable('audit', 'stagetimestamp', chunk_time_interval => INTERVAL '", timescaledb_audit_chunk_time_interval, "', if_not_exists => TRUE);"]),
          std.join("", ["SELECT add_retention_policy('audit', INTERVAL '", timescaledb_audit_retention_policy ,"', if_not_exists => TRUE);"]),
          "SELECT alter_job(1000, schedule_interval => INTERVAL '1 hours');",
          "CREATE TABLE CLUSTER_MEMBER (ID SERIAL, NAMESPACE VARCHAR(255) NOT NULL, CLUSTER VARCHAR(255) NOT NULL, MEMBER_ID VARCHAR(255) NOT NULL, MEMBER_NAME VARCHAR(255), ATTRIBUTE VARCHAR(255), ROLE VARCHAR(255), STATUS VARCHAR(255), CREATEDTIME TIMESTAMP NOT NULL DEFAULT NOW(), UPDATEDTIME TIMESTAMP NOT NULL DEFAULT NOW());",
          "CREATE OR REPLACE PROCEDURE DELETE_PENDING_MEMBER(job_id int, config jsonb) LANGUAGE PLPGSQL AS $$ BEGIN DELETE FROM cluster_member WHERE STATUS = 'pending' and createdtime < now() - interval '1 days'; END$$;",
          "SELECT add_job('DELETE_PENDING_MEMBER','1 hours');",
          "ALTER TABLE CLUSTER_MEMBER ADD CONSTRAINT MEMBER_CONSTRAINT UNIQUE (NAMESPACE, CLUSTER, MEMBER_ID, ATTRIBUTE);",
          "CREATE UNIQUE INDEX CLUSTER_STATUS ON CLUSTER_MEMBER (NAMESPACE, CLUSTER, STATUS) WHERE ( STATUS = 'owner');",
          "CREATE TABLE METERING (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255));",
          "ALTER TABLE METERING ADD CONSTRAINT UNIQUE_METERING UNIQUE (NAMESPACE, METERING_TIME);",
          "CREATE TABLE METERING_HOUR (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255));",
          "ALTER TABLE METERING_HOUR ADD CONSTRAINT UNIQUE_METERING_HOUR UNIQUE (NAMESPACE, METERING_TIME);",
          "CREATE TABLE METERING_DAY (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255));",
          "ALTER TABLE METERING_DAY ADD CONSTRAINT UNIQUE_METERING_DAY UNIQUE (NAMESPACE, METERING_TIME);",
          "CREATE TABLE METERING_MONTH (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255));",
          "ALTER TABLE METERING_MONTH ADD CONSTRAINT UNIQUE_METERING_MONTH UNIQUE (NAMESPACE, METERING_TIME);",
          "CREATE TABLE METERING_YEAR (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255));",
          "ALTER TABLE METERING_YEAR ADD CONSTRAINT UNIQUE_METERING_YEAR UNIQUE (NAMESPACE, METERING_TIME);",
          std.join("", ["SELECT create_hypertable('metering_hour', 'metering_time', chunk_time_interval => INTERVAL '", timescaledb_metering_hour_chunk_time_interval, "', if_not_exists => TRUE);"]),
          std.join("", ["SELECT add_retention_policy('metering_hour', INTERVAL '", timescaledb_metering_hour_retention_policy ,"', if_not_exists => TRUE);"]),
          std.join("", ["SELECT create_hypertable('metering_day', 'metering_time', chunk_time_interval => INTERVAL '", timescaledb_metering_day_chunk_time_interval, "', if_not_exists => TRUE);"]),
          std.join("", ["SELECT add_retention_policy('metering_day', INTERVAL '", timescaledb_metering_day_retention_policy ,"', if_not_exists => TRUE);"]),
          std.join("", ["SELECT create_hypertable('metering_month', 'metering_time', chunk_time_interval => INTERVAL '", timescaledb_metering_month_chunk_time_interval, "', if_not_exists => TRUE);"]),
          std.join("", ["SELECT add_retention_policy('metering_month', INTERVAL '", timescaledb_metering_month_retention_policy ,"', if_not_exists => TRUE);"]),
          std.join("", ["SELECT create_hypertable('metering_year', 'metering_time', chunk_time_interval => INTERVAL '", timescaledb_metering_year_chunk_time_interval, "', if_not_exists => TRUE);"]),
          std.join("", ["SELECT add_retention_policy('metering_year', INTERVAL '", timescaledb_metering_year_retention_policy ,"', if_not_exists => TRUE);"]),
          "CREATE TABLE EVENT (NAMESPACE VARCHAR(128) , KIND VARCHAR(32) NOT NULL, NAME VARCHAR(128) NOT NULL, UID VARCHAR(64) NOT NULL, APIVERSION VARCHAR(64), FIELDPATH VARCHAR(64), ACTION VARCHAR(128), REASON VARCHAR(128), NOTE VARCHAR(512), REPORTING_CONTROLLER VARCHAR(128), REPORTING_INSTANCE VARCHAR(128), HOST VARCHAR(16), COUNT INT, TYPE VARCHAR(32), FIRST_TIMESTAMP TIMESTAMP, LAST_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);",
          std.join("", ["SELECT create_hypertable('event', 'last_timestamp', chunk_time_interval => INTERVAL '", timescaledb_event_chunk_time_interval ,"', if_not_exists => TRUE, migrate_data => TRUE);"]),
          std.join("", ["SELECT add_retention_policy('event', INTERVAL '", timescaledb_event_retention_policy ,"', if_not_exists => TRUE);"]),
          "CREATE EXTENSION pg_cron;",
          "SELECT cron.schedule('* * * * *', $$DELETE FROM CLUSTER_MEMBER WHERE STATUS = 'pending' AND CREATEDTIME < now() - interval '1days'$$);",
          "CREATE OR REPLACE FUNCTION UPDATE_TIME() RETURNS TRIGGER AS $$ BEGIN NEW.updatedtime = NOW(); RETURN NEW; END; $$ LANGUAGE plpgsql;",
          "CREATE TRIGGER TRIGGER_UPDATE_TIME AFTER UPDATE ON CLUSTER_MEMBER FOR EACH ROW EXECUTE PROCEDURE UPDATE_TIME();",
          std.join("", ["ALTER SYSTEM SET log_min_messages=", timescaledb_log_level,";"]),
          "__SQL__",
        ]),
    },
    kind: 'ConfigMap',
    metadata: {
      name: 'custom-init-scripts',
      namespace: 'hypercloud5-system',
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'StatefulSet',
    metadata: {
      labels: {
        app: 'timescaledb',
        'cluster-name': 'timescaledb',
        release: 'timescaledb',
      },
      name: 'timescaledb',
      namespace: 'hypercloud5-system',
    },
    spec: {
      podManagementPolicy: 'OrderedReady',
      replicas: 1,
      revisionHistoryLimit: 10,
      selector: {
        matchLabels: {
          app: 'timescaledb',
          'cluster-name': 'timescaledb',
          release: 'timescaledb',
        },
      },
      serviceName: 'timescaledb-service',
      template: {
        metadata: {
          labels: {
            app: 'timescaledb',
            'cluster-name': 'timescaledb',
            release: 'timescaledb',
          },
          name: 'timescaledb',
        },
        spec: {
          affinity: {
            podAntiAffinity: {
              preferredDuringSchedulingIgnoredDuringExecution: [
                {
                  podAffinityTerm: {
                    labelSelector: {
                      matchLabels: {
                        app: 'timescaledb',
                        'cluster-name': 'timescaledb',
                        release: 'timescaledb',
                      },
                    },
                    topologyKey: 'kubernetes.io/hostname',
                  },
                  weight: 100,
                },
                {
                  podAffinityTerm: {
                    labelSelector: {
                      matchLabels: {
                        app: 'timescaledb',
                        'cluster-name': 'timescaledb',
                        release: 'timescaledb',
                      },
                    },
                    topologyKey: 'failure-domain.beta.kubernetes.io/zone',
                  },
                  weight: 50,
                },
              ],
            },
          },
          containers: [
            {
              command: [
                '/bin/bash',
                '-c',
                "\ninstall -o postgres -g postgres -d -m 0700 \"/var/lib/postgresql/data\" \"/var/lib/postgresql/wal/pg_wal\" || exit 1\nTABLESPACES=\"\"\nfor tablespace in ; do\n  install -o postgres -g postgres -d -m 0700 \"/var/lib/postgresql/tablespaces/${tablespace}/data\"\ndone\n\n# Environment variables can be read by regular users of PostgreSQL. Especially in a Kubernetes\n# context it is likely that some secrets are part of those variables.\n# To ensure we expose as little as possible to the underlying PostgreSQL instance, we have a list\n# of allowed environment variable patterns to retain.\n#\n# We need the KUBERNETES_ environment variables for the native Kubernetes support of Patroni to work.\n#\n# NB: Patroni will remove all PATRONI_.* environment variables before starting PostgreSQL\n\n# We store the current environment, as initscripts, callbacks, archive_commands etc. may require\n# to have the environment available to them\nset -o posix\nexport -p > \"${HOME}/.pod_environment\"\nexport -p | grep PGBACKREST > \"${HOME}/.pgbackrest_environment\"\n\nfor UNKNOWNVAR in $(env | awk -F '=' '!/^(PATRONI_.*|HOME|PGDATA|PGHOST|LC_.*|LANG|PATH|KUBERNETES_SERVICE_.*)=/ {print $1}')\ndo\n    unset \"${UNKNOWNVAR}\"\ndone\n\ntouch /var/run/postgresql/timescaledb.conf\ntouch /var/run/postgresql/wal_status\n\necho \"*:*:*:postgres:${PATRONI_SUPERUSER_PASSWORD}\" >> ${HOME}/.pgpass\nchmod 0600 ${HOME}/.pgpass\n\nexport PATRONI_POSTGRESQL_PGPASS=\"${HOME}/.pgpass.patroni\"\n\nexec patroni /etc/timescaledb/patroni.yaml\n",
              ],
              env: [
                {
                  name: 'PATRONI_admin_OPTIONS',
                  value: 'createrole,createdb',
                },
                {
                  name: 'PATRONI_REPLICATION_USERNAME',
                  value: 'standby',
                },
                {
                  name: 'PATRONI_KUBERNETES_POD_IP',
                  valueFrom: {
                    fieldRef: {
                      apiVersion: 'v1',
                      fieldPath: 'status.podIP',
                    },
                  },
                },
                {
                  name: 'PATRONI_POSTGRESQL_CONNECT_ADDRESS',
                  value: '$(PATRONI_KUBERNETES_POD_IP):5432',
                },
                {
                  name: 'PATRONI_RESTAPI_CONNECT_ADDRESS',
                  value: '$(PATRONI_KUBERNETES_POD_IP):8008',
                },
                {
                  name: 'PATRONI_KUBERNETES_PORTS',
                  value: '[{"name": "postgresql", "port": 5432}]',
                },
                {
                  name: 'PATRONI_NAME',
                  valueFrom: {
                    fieldRef: {
                      apiVersion: 'v1',
                      fieldPath: 'metadata.name',
                    },
                  },
                },
                {
                  name: 'PATRONI_POSTGRESQL_DATA_DIR',
                  value: '/var/lib/postgresql/data',
                },
                {
                  name: 'PATRONI_KUBERNETES_NAMESPACE',
                  value: 'hypercloud5-system',
                },
                {
                  name: 'PATRONI_KUBERNETES_LABELS',
                  value: '{app: timescaledb, cluster-name: timescaledb, release: timescaledb}',
                },
                {
                  name: 'PATRONI_SCOPE',
                  value: 'timescaledb',
                },
                {
                  name: 'PGBACKREST_CONFIG',
                  value: '/etc/pgbackrest/pgbackrest.conf',
                },
                {
                  name: 'PGDATA',
                  value: '$(PATRONI_POSTGRESQL_DATA_DIR)',
                },
                {
                  name: 'PGHOST',
                  value: '/var/run/postgresql',
                },
                {
                  name: 'BOOTSTRAP_FROM_BACKUP',
                  value: '0',
                },
              ],
              envFrom: [
                {
                  secretRef: {
                    name: 'timescaledb-credentials',
                  },
                },
                {
                  secretRef: {
                    name: 'timescaledb-pgbackrest',
                    optional: true,
                  },
                },
              ],
              image: std.join("", [target_registry, "docker.io/tmaxcloudck/timescaledb-cron:b5.0.0.0"]),
              imagePullPolicy: 'IfNotPresent',
              lifecycle: {
                preStop: {
                  exec: {
                    command: [
                      'psql',
                      '-X',
                      '--file',
                      '/etc/timescaledb/scripts/lifecycle_preStop.psql',
                    ],
                  },
                },
              },
              name: 'timescaledb',
              ports: [
                {
                  containerPort: 8008,
                  name: 'patroni',
                  protocol: 'TCP',
                },
                {
                  containerPort: 5432,
                  name: 'postgresql',
                  protocol: 'TCP',
                },
              ],
              readinessProbe: {
                exec: {
                  command: [
                    'pg_isready',
                    '-h',
                    '/var/run/postgresql',
                  ],
                },
                failureThreshold: 6,
                initialDelaySeconds: 5,
                periodSeconds: 30,
                successThreshold: 1,
                timeoutSeconds: 5,
              },
              resources: {
                limits: {
                  cpu: '300m',
                  memory: '512Mi',
                },
                requests: {
                  cpu: '100m',
                  memory: '256Mi',
                },
              },
              securityContext: {
                allowPrivilegeEscalation: false,
              },
              terminationMessagePath: '/dev/termination-log',
              terminationMessagePolicy: 'File',
              volumeMounts: [
                {
                  mountPath: '/var/lib/postgresql',
                  name: 'storage-volume',
                },
                {
                  mountPath: '/var/lib/postgresql/wal',
                  name: 'wal-volume',
                },
                {
                  mountPath: '/etc/timescaledb/patroni.yaml',
                  name: 'patroni-config',
                  readOnly: true,
                  subPath: 'patroni.yaml',
                },
                {
                  mountPath: '/etc/timescaledb/scripts',
                  name: 'timescaledb-scripts',
                  readOnly: true,
                },
                {
                  mountPath: '/etc/timescaledb/post_init.d',
                  name: 'post-init',
                  readOnly: true,
                },
                {
                  mountPath: '/etc/certificate',
                  name: 'certificate',
                  readOnly: true,
                },
                {
                  mountPath: '/var/run/postgresql',
                  name: 'socket-directory',
                },
                {
                  mountPath: '/etc/pgbackrest',
                  name: 'pgbackrest',
                  readOnly: true,
                },
                {
                  mountPath: '/etc/pgbackrest/bootstrap',
                  name: 'pgbackrest-bootstrap',
                  readOnly: true,
                },
              ] + (
                if time_zone != "UTC" then [
                  {
                    "name": "timezone-config",
                    "mountPath": "/etc/localtime"
                  }
                ] else []
              )
            },
          ],
          dnsPolicy: 'ClusterFirst',
          initContainers: [
            {
              command: [
                'sh',
                '-c',
                "set -e\n[ $CPUS -eq 0 ]   && CPUS=\"${RESOURCES_CPU_LIMIT}\"\n[ $MEMORY -eq 0 ] && MEMORY=\"${RESOURCES_MEMORY_LIMIT}\"\n\nif [ -f \"${PGDATA}/postgresql.base.conf\" ] && ! grep \"${INCLUDE_DIRECTIVE}\" postgresql.base.conf -qxF; then\n  echo \"${INCLUDE_DIRECTIVE}\" >> \"${PGDATA}/postgresql.base.conf\"\nfi\n\ntouch \"${TSTUNE_FILE}\"\ntimescaledb-tune -quiet -pg-version 11 -conf-path \"${TSTUNE_FILE}\" -cpus \"${CPUS}\" -memory \"${MEMORY}MB\" \\\n   -yes\n\n# If there is a dedicated WAL Volume, we want to set max_wal_size to 60% of that volume\n# If there isn't a dedicated WAL Volume, we set it to 20% of the data volume\nif [ \"${RESOURCES_WAL_VOLUME}\" = \"0\" ]; then\n  WALMAX=\"${RESOURCES_DATA_VOLUME}\"\n  WALPERCENT=20\nelse\n  WALMAX=\"${RESOURCES_WAL_VOLUME}\"\n  WALPERCENT=60\nfi\n\nWALMAX=$(numfmt --from=auto ${WALMAX})\n\n# Wal segments are 16MB in size, in this way we get a \"nice\" number of the nearest\n# 16MB\nWALMAX=$(( $WALMAX / 100 * $WALPERCENT / 16777216 * 16 ))\nWALMIN=$(( $WALMAX / 2 ))\n\necho \"max_wal_size=${WALMAX}MB\" >> \"${TSTUNE_FILE}\"\necho \"min_wal_size=${WALMIN}MB\" >> \"${TSTUNE_FILE}\"\n",
              ],
              env: [
                {
                  name: 'TSTUNE_FILE',
                  value: '/var/run/postgresql/timescaledb.conf',
                },
                {
                  name: 'RESOURCES_WAL_VOLUME',
                  value: '30Gi',
                },
                {
                  name: 'RESOURCES_DATA_VOLUME',
                  value: '10Gi',
                },
                {
                  name: 'INCLUDE_DIRECTIVE',
                  value: "include_if_exists = '/var/run/postgresql/timescaledb.conf'",
                },
                {
                  name: 'CPUS',
                  valueFrom: {
                    resourceFieldRef: {
                      containerName: 'timescaledb',
                      divisor: '1',
                      resource: 'requests.cpu',
                    },
                  },
                },
                {
                  name: 'MEMORY',
                  valueFrom: {
                    resourceFieldRef: {
                      containerName: 'timescaledb',
                      divisor: '1Mi',
                      resource: 'requests.memory',
                    },
                  },
                },
                {
                  name: 'RESOURCES_CPU_LIMIT',
                  valueFrom: {
                    resourceFieldRef: {
                      containerName: 'timescaledb',
                      divisor: '1',
                      resource: 'limits.cpu',
                    },
                  },
                },
                {
                  name: 'RESOURCES_MEMORY_LIMIT',
                  valueFrom: {
                    resourceFieldRef: {
                      containerName: 'timescaledb',
                      divisor: '1Mi',
                      resource: 'limits.memory',
                    },
                  },
                },
              ],
              image: std.join("", [target_registry, "docker.io/tmaxcloudck/timescaledb-cron:b5.0.0.0"]),
              imagePullPolicy: 'IfNotPresent',
              name: 'tstune',
              resources: {
                limits: {
                  cpu: '300m',
                  memory: '512Mi',
                },
                requests: {
                  cpu: '100m',
                  memory: '256Mi',
                },
              },
              securityContext: {
                allowPrivilegeEscalation: false,
              },
              terminationMessagePath: '/dev/termination-log',
              terminationMessagePolicy: 'File',
              volumeMounts: [
                {
                  mountPath: '/var/run/postgresql',
                  name: 'socket-directory',
                },
              ],
            },
          ],
          restartPolicy: 'Always',
          schedulerName: 'default-scheduler',
          securityContext: {
            fsGroup: 1000,
            runAsGroup: 1000,
            runAsNonRoot: true,
            runAsUser: 1000,
          },
          serviceAccount: 'hypercloud5-admin',
          serviceAccountName: 'hypercloud5-admin',
          terminationGracePeriodSeconds: 600,
          volumes: [
            {
              emptyDir: {},
              name: 'socket-directory',
            },
            {
              configMap: {
                defaultMode: 420,
                name: 'timescaledb-patroni',
              },
              name: 'patroni-config',
            },
            {
              configMap: {
                defaultMode: 488,
                name: 'timescaledb-scripts',
              },
              name: 'timescaledb-scripts',
            },
            {
              name: 'post-init',
              projected: {
                defaultMode: 488,
                sources: [
                  {
                    configMap: {
                      name: 'custom-init-scripts',
                      optional: true,
                    },
                  },
                  {
                    secret: {
                      name: 'custom-secret-scripts',
                      optional: true,
                    },
                  },
                ],
              },
            },
            {
              configMap: {
                defaultMode: 416,
                name: 'timescaledb-pgbouncer',
                optional: true,
              },
              name: 'pgbouncer',
            },
            {
              configMap: {
                defaultMode: 416,
                name: 'timescaledb-pgbackrest',
                optional: true,
              },
              name: 'pgbackrest',
            },
            {
              name: 'certificate',
              secret: {
                defaultMode: 416,
                optional: true,
                secretName: 'timescaledb-certificate',
              },
            },
            {
              name: 'pgbackrest-bootstrap',
              secret: {
                defaultMode: 420,
                optional: true,
                secretName: 'pgbackrest-bootstrap',
              },
            },
          ] + (
            if time_zone != "UTC" then [
              {
                "name": "timezone-config",
                "hostPath": {
                  "path": std.join("", ["/usr/share/zoneinfo/", time_zone])
                }
              }
            ] else []
          )
        },
      },
      updateStrategy: {
        type: 'RollingUpdate',
      },
      volumeClaimTemplates: [
        {
          apiVersion: 'v1',
          kind: 'PersistentVolumeClaim',
          metadata: {
            labels: {
              app: 'timescaledb',
              'cluster-name': 'timescaledb',
              purpose: 'data-directory',
              release: 'timescaledb',
            },
            name: 'storage-volume',
          },
          spec: {
            accessModes: [
              'ReadWriteOnce',
            ],
            resources: {
              requests: {
                storage: '10Gi',
              },
            },
            volumeMode: 'Filesystem',
          },
        },
        {
          apiVersion: 'v1',
          kind: 'PersistentVolumeClaim',
          metadata: {
            labels: {
              app: 'timescaledb',
              'cluster-name': 'timescaledb',
              purpose: 'wal-directory',
              release: 'timescaledb',
            },
            name: 'wal-volume',
          },
          spec: {
            accessModes: [
              'ReadWriteOnce',
            ],
            resources: {
              requests: {
                storage: '30Gi',
              },
            },
            volumeMode: 'Filesystem',
          },
        },
      ],
    },
  },
]