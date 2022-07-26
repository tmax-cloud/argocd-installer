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
  hyperregistry_enabled="true",
  storageClass="default",
  aws_enabled="true",
  vsphere_enabled="true",
  multi_operator_log_level="info",
  single_operator_log_level="info",
  api_server_log_level="INFO",
  postgres_log_level="WARNING",
)

local target_registry = if is_offline == "false" then "" else private_registry + "/";

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "postgres",
      "namespace": "hypercloud5-system"
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": "postgres"
        }
      },
      "replicas": 1,
      "template": {
        "metadata": {
          "labels": {
            "app": "postgres"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "postgres",
              "image": std.join("", [target_registry, "docker.io/tmaxcloudck/postgres-cron:b5.0.0.1"]),
              "imagePullPolicy": "IfNotPresent",
              "ports": [
                {
                  "containerPort": 5432
                }
              ],
              "env": [
                {
                  "name": "TZ",
                  "value": "Asia/Seoul"
                },
                {
                  "name": "POSTGRES_USER",
                  "value": "postgres"
                },
                {
                  "name": "POSTGRES_PASSWORD",
                  "valueFrom": {
                    "secretKeyRef": {
                      "name": "postgres-secret",
                      "key": "POSTGRES_PASSWORD"
                    }
                  }
                }
              ],
              "resources": {
                "limits": {
                  "cpu": "500m",
                  "memory": "500Mi"
                },
                "requests": {
                  "cpu": "300m",
                  "memory": "100Mi"
                }
              },
              "volumeMounts": [
                {
                  "mountPath": "/var/lib/postgresql/data",
                  "name": "data",
                  "subPath": "postgres"
                },
                {
                  "mountPath": "/docker-entrypoint-initdb.d",
                  "name": "initdbsql"
                }
              ]
            }
          ],
          "serviceAccountName": "hypercloud5-admin",
          "volumes": [
            {
              "name": "data",
              "persistentVolumeClaim": {
                "claimName": "postgres-data"
              }
            },
            {
              "name": "initdbsql",
              "configMap": {
                "name": "postgres-init-config",
                "items": [
                  {
                    "key": "INIT_DB_SQL",
                    "path": "init-db.sql"
                  }
                ]
              }
            }
          ]
        }
      }
    }
  },
  {
    "kind": "PersistentVolumeClaim",
    "apiVersion": "v1",
    "metadata": {
      "name": "postgres-data",
      "namespace": "hypercloud5-system"
    },
    "spec": {
      "accessModes": [
        "ReadWriteOnce"
      ],
      "resources": {
        "requests": {
          "storage": "10Gi"
        }
      }
    } + (
      if storageClass != "default" then {
        "storageClassName": storageClass
      } else {}
    )
  },
  {
  "apiVersion": "v1",
  "kind": "ConfigMap",
  "metadata": {
    "name": "postgres-init-config",
    "namespace": "hypercloud5-system"
  },
  "data": {
    "INIT_DB_SQL": "CREATE TABLE METERING (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255),PRIMARY KEY (ID));
    ALTER TABLE METERING ADD CONSTRAINT UNIQUE_METERING UNIQUE (NAMESPACE, METERING_TIME);
    CREATE TABLE METERING_HOUR (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255),PRIMARY KEY (ID));
    ALTER TABLE METERING_HOUR ADD CONSTRAINT UNIQUE_METERING_HOUR UNIQUE (NAMESPACE, METERING_TIME);
    CREATE TABLE METERING_DAY (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255),PRIMARY KEY (ID));
    ALTER TABLE METERING_DAY ADD CONSTRAINT UNIQUE_METERING_DAY UNIQUE (NAMESPACE, METERING_TIME);
    CREATE TABLE METERING_MONTH (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255),PRIMARY KEY (ID));
    ALTER TABLE METERING_MONTH ADD CONSTRAINT UNIQUE_METERING_MONTH UNIQUE (NAMESPACE, METERING_TIME);
    CREATE TABLE METERING_YEAR (ID VARCHAR(64) NOT NULL,NAMESPACE VARCHAR(255) NOT NULL,CPU DOUBLE PRECISION,MEMORY BIGINT,STORAGE BIGINT,GPU DOUBLE PRECISION,PUBLIC_IP INT,PRIVATE_IP INT, TRAFFIC_IN BIGINT, TRAFFIC_OUT BIGINT, METERING_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,STATUS VARCHAR(255),PRIMARY KEY (ID));
    ALTER TABLE METERING_YEAR ADD CONSTRAINT UNIQUE_METERING_YEAR UNIQUE (NAMESPACE, METERING_TIME);
    CREATE TABLE AUDIT (ID VARCHAR(64) NOT NULL, USERNAME VARCHAR(255), USERAGENT VARCHAR(255), NAMESPACE VARCHAR(255), APIGROUP VARCHAR(255), APIVERSION VARCHAR(32), RESOURCE VARCHAR(64), NAME VARCHAR(255), STAGE VARCHAR(32), STAGETIMESTAMP TIMESTAMP NOT NULL, VERB VARCHAR(32), CODE INT, STATUS VARCHAR(255), REASON VARCHAR(255), MESSAGE VARCHAR(255), PRIMARY KEY (ID));
    CREATE INDEX TIME_INDEX ON AUDIT (STAGETIMESTAMP);
    CREATE TABLE CLUSTER_MEMBER (ID SERIAL, NAMESPACE VARCHAR(255) NOT NULL, CLUSTER VARCHAR(255) NOT NULL, MEMBER_ID VARCHAR(255) NOT NULL, MEMBER_NAME VARCHAR(255), ATTRIBUTE VARCHAR(255), ROLE VARCHAR(255), STATUS VARCHAR(255), CREATEDTIME TIMESTAMP NOT NULL DEFAULT NOW(), UPDATEDTIME TIMESTAMP NOT NULL DEFAULT NOW());
    ALTER TABLE CLUSTER_MEMBER ADD CONSTRAINT MEMBER_CONSTRAINT UNIQUE (NAMESPACE, CLUSTER, MEMBER_ID, ATTRIBUTE);
    CREATE UNIQUE INDEX CLUSTER_STATUS ON CLUSTER_MEMBER (NAMESPACE, CLUSTER, STATUS) WHERE ( STATUS = 'owner');
    SELECT cron.schedule('* * * * *', $$DELETE FROM CLUSTER_MEMBER WHERE STATUS = 'pending' AND CREATEDTIME < now() - interval '7days'$$);
    CREATE OR REPLACE FUNCTION UPDATE_TIME() RETURNS TRIGGER AS $$ BEGIN NEW.updatedtime = NOW(); RETURN NEW; END; $$ LANGUAGE plpgsql;
    CREATE TRIGGER TRIGGER_UPDATE_TIME AFTER UPDATE ON CLUSTER_MEMBER FOR EACH ROW EXECUTE PROCEDURE UPDATE_TIME();
    ALTER DATABASE postgres set idle_in_transaction_session_timeout = '3min';
    ALTER SYSTEM SET log_min_messages = " + postgres_log_level + ";"
  }
}
]