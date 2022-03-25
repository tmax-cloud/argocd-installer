function (
	is_offline="false",
	private_registry="172.22.6.2:5000",
	client_id="grafana",
	tmax_client_secret="tmax_client_secret",
	keycloak_addr="",
	grafana_pvc="10Gi",
	grafana_version="6.4.3",
	grafana_image_repo="grafana/grafana",
	ingress_domain="",
	cluster_name="master",
	admin_user="test@test.co.kr"
)

if cluster_name == "master" then [
	{
		"apiVersion": "networking.k8s.io/v1",
		"kind": "Ingress",
		"metadata": {
			"labels": {
				"ingress.tmaxcloud.org/name": "grafana"
			},
			"annotations": {
				"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
			},
			"name": "grafana",
			"namespace": "monitoring"
		},
		"spec": {
			"ingressClassName": "tmax-cloud",
			"rules": [
				{
					"host": std.join("", ["grafana.", ingress_domain]),
					"http": {
						"paths": [
							{
								"backend": {
									"service": {
										"name": "grafana",
										"port": {
											"number": 3000
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
						std.join("", ["grafana.", ingress_domain])
					]
				}
			]
		}
	}
] else []
