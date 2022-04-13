function (
  is_offline="false",
    private_registry="172.22.6.2:5000",
    hyperauth_svc_type="Ingress",
    hyperauth_external_ip="172.22.6.8",
    is_kafka_enabled="true",
    hyperauth_subdomain="hyperauth",
    hypercloud_domain_host="tmaxcloud.org"
)

if is_kafka_enabled == "true" then [
  {
    "apiVersion": "kafka.strimzi.io/v1beta2",
    "kind": "Kafka",
    "metadata": {
      "name": "kafka",
      "namespace": "hyperauth"
    },
    "spec": {
      "kafka": {
        "version": "2.8.0",
        "replicas": 3,
        "listeners": [
          {
            "name": "plain",
            "port": 9092,
            "type": "internal",
            "configuration": {
              "brokerCertChainAndKey": {
                "secretName": "kafka-jks",
                "certificate": "tls.crt",
                "key": "tls.key"
              }
            },
            "tls": true
          }
        ],
        "logging": {
          "type": "inline",
          "loggers": {
            "log4j.logger.io.strimzi": "TRACE",
            "log4j.logger.kafka": "DEBUG",
            "log4j.logger.org.apache.kafka": "DEBUG"
          }
        },
        "config": {
          "offsets.topic.replication.factor": 3,
          "transaction.state.log.replication.factor": 1,
          "transaction.state.log.min.isr": 1,
          "log.message.format.version": "2.8",
          "inter.broker.protocol.version": "2.8"
        },
        "storage": {
          "type": "persistent-claim",
          "size": "10Gi"
        },
        "metricsConfig": {
          "type": "jmxPrometheusExporter",
          "valueFrom": {
            "configMapKeyRef": {
              "name": "kafka-metrics",
              "key": "kafka-metrics-config.yml"
            }
          }
        }
      },
      "zookeeper": {
        "replicas": 3,
        "storage": {
          "type": "persistent-claim",
          "size": "1Gi"
        },
        "metricsConfig": {
          "type": "jmxPrometheusExporter",
          "valueFrom": {
            "configMapKeyRef": {
                "name": "kafka-metrics",
                "key": "zookeeper-metrics-config.yml"
            }
          }
        }
      },
      "entityOperator": {
        "topicOperator": {},
        "userOperator": {}
      },
      "kafkaExporter": {
        "topicRegex": ".*",
        "groupRegex": ".*"
      }
    }
  },
  {
    "kind": "ConfigMap",
    "apiVersion": "v1",
    "metadata": {
      "name": "kafka-metrics",
      "namespace": "hyperauth",
      "labels": {
        "app": "strimzi"
      }
    },
    "data": {
      "kafka-metrics-config.yml": std.join("", 
        [
          "# See https://github.com/prometheus/jmx_exporter for more info about JMX Prometheus Exporter metrics\n",
          "lowercaseOutputName: true\n",
          "rules:\n",
          "# Special cases and very specific rules\n",
          "- pattern: kafka.server<type=(.+), name=(.+), clientId=(.+), topic=(.+), partition=(.*)><>Value\n",
          "  name: kafka_server_$1_$2\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    clientId: \"$3\"\n",
          "    topic: \"$4\"\n",
          "    partition: \"$5\"\n",
          "- pattern: kafka.server<type=(.+), name=(.+), clientId=(.+), brokerHost=(.+), brokerPort=(.+)><>Value\n",
          "  name: kafka_server_$1_$2\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    clientId: \"$3\"\n",
          "    broker: \"$4:$5\"\n",
          "- pattern: kafka.server<type=(.+), cipher=(.+), protocol=(.+), listener=(.+), networkProcessor=(.+)><>connections\n",
          "  name: kafka_server_$1_connections_tls_info\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    listener: \"$2\"\n",
          "    networkProcessor: \"$3\"\n",
          "    protocol: \"$4\"\n",
          "    cipher: \"$5\"\n",
          "- pattern: kafka.server<type=(.+), clientSoftwareName=(.+), clientSoftwareVersion=(.+), listener=(.+), networkProcessor=(.+)><>connections\n",
          "  name: kafka_server_$1_connections_software\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    clientSoftwareName: \"$2\"\n",
          "    clientSoftwareVersion: \"$3\"\n",
          "    listener: \"$4\"\n",
          "    networkProcessor: \"$5\"\n",
          "- pattern: \"kafka.server<type=(.+), listener=(.+), networkProcessor=(.+)><>(.+):\"\n",
          "  name: kafka_server_$1_$4\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    listener: \"$2\"\n",
          "    networkProcessor: \"$3\"\n",
          "- pattern: kafka.server<type=(.+), listener=(.+), networkProcessor=(.+)><>(.+)\n",
          "  name: kafka_server_$1_$4\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    listener: \"$2\"\n",
          "    networkProcessor: \"$3\"\n",
          "# Some percent metrics use MeanRate attribute\n",
          "# Ex) kafka.server<type=(KafkaRequestHandlerPool), name=(RequestHandlerAvgIdlePercent)><>MeanRate\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+)Percent\\w*><>MeanRate\n",
          "  name: kafka_$1_$2_$3_percent\n",
          "  type: GAUGE\n",
          "# Generic gauges for percents\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+)Percent\\w*><>Value\n",
          "  name: kafka_$1_$2_$3_percent\n",
          "  type: GAUGE\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+)Percent\\w*, (.+)=(.+)><>Value\n",
          "  name: kafka_$1_$2_$3_percent\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    \"$4\": \"$5\"\n",
          "# Generic per-second counters with 0-2 key/value pairs\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+)PerSec\\w*, (.+)=(.+), (.+)=(.+)><>Count\n",
          "  name: kafka_$1_$2_$3_total\n",
          "  type: COUNTER\n",
          "  labels:\n",
          "    \"$4\": \"$5\"\n",
          "    \"$6\": \"$7\"\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+)PerSec\\w*, (.+)=(.+)><>Count\n",
          "  name: kafka_$1_$2_$3_total\n",
          "  type: COUNTER\n",
          "  labels:\n",
          "    \"$4\": \"$5\"\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+)PerSec\\w*><>Count\n",
          "  name: kafka_$1_$2_$3_total\n",
          "  type: COUNTER\n",
          "# Generic gauges with 0-2 key/value pairs\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.+), (.+)=(.+)><>Value\n",
          "  name: kafka_$1_$2_$3\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    \"$4\": \"$5\"\n",
          "    \"$6\": \"$7\"\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.+)><>Value\n",
          "  name: kafka_$1_$2_$3\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    \"$4\": \"$5\"\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+)><>Value\n",
          "  name: kafka_$1_$2_$3\n",
          "  type: GAUGE\n",
          "# Emulate Prometheus 'Summary' metrics for the exported 'Histogram's.\n",
          "# Note that these are missing the '_sum' metric!\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.+), (.+)=(.+)><>Count\n",
          "  name: kafka_$1_$2_$3_count\n",
          "  type: COUNTER\n",
          "  labels:\n",
          "    \"$4\": \"$5\"\n",
          "    \"$6\": \"$7\"\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.*), (.+)=(.+)><>(\\d+)thPercentile\n",
          "  name: kafka_$1_$2_$3\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    \"$4\": \"$5\"\n",
          "    \"$6\": \"$7\"\n",
          "    quantile: \"0.$8\"\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.+)><>Count\n",
          "  name: kafka_$1_$2_$3_count\n",
          "  type: COUNTER\n",
          "  labels:\n",
          "    \"$4\": \"$5\"\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+), (.+)=(.*)><>(\\d+)thPercentile\n",
          "  name: kafka_$1_$2_$3\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    \"$4\": \"$5\"\n",
          "    quantile: \"0.$6\"\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+)><>Count\n",
          "  name: kafka_$1_$2_$3_count\n",
          "  type: COUNTER\n",
          "- pattern: kafka.(\\w+)<type=(.+), name=(.+)><>(\\d+)thPercentile\n",
          "  name: kafka_$1_$2_$3\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    quantile: \"0.$4\"\n",
          ""
        ]
      ),
      "zookeeper-metrics-config.yml": std.join("",
        [
          "# See https://github.com/prometheus/jmx_exporter for more info about JMX Prometheus Exporter metrics\n",
          "lowercaseOutputName: true\n",
          "rules:\n",
          "# replicated Zookeeper\n",
          "- pattern: \"org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\\\d+)><>(\\\\w+)\"\n",
          "  name: \"zookeeper_$2\"\n",
          "  type: GAUGE\n",
          "- pattern: \"org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\\\d+), name1=replica.(\\\\d+)><>(\\\\w+)\"\n",
          "  name: \"zookeeper_$3\"\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    replicaId: \"$2\"\n",
          "- pattern: \"org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\\\d+), name1=replica.(\\\\d+), name2=(\\\\w+)><>(Packets\\\\w+)\"\n",
          "  name: \"zookeeper_$4\"\n",
          "  type: COUNTER\n",
          "  labels:\n",
          "    replicaId: \"$2\"\n",
          "    memberType: \"$3\"\n",
          "- pattern: \"org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\\\d+), name1=replica.(\\\\d+), name2=(\\\\w+)><>(\\\\w+)\"\n",
          "  name: \"zookeeper_$4\"\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    replicaId: \"$2\"\n",
          "    memberType: \"$3\"\n",
          "- pattern: \"org.apache.ZooKeeperService<name0=ReplicatedServer_id(\\\\d+), name1=replica.(\\\\d+), name2=(\\\\w+), name3=(\\\\w+)><>(\\\\w+)\"\n",
          "  name: \"zookeeper_$4_$5\"\n",
          "  type: GAUGE\n",
          "  labels:\n",
          "    replicaId: \"$2\"\n",
          "    memberType: \"$3\"\n",
          ""
        ]
      )
    }
  }
] else []