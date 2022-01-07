function (
    username="username",
    password="password",
)

[
    {
        "apiVersion": "v1",
        "kind": "Secret",
        "metadata": {
            "labels": [
                {
                    "cluster.x-k8s.io/provider": "infrastructure-vsphere",
                },
            ],
            "name": "capv-manager-bootstrap-credentials",
            "namespace": "capv-system",
        },
        "stringData": {
            #"credentials.yaml": std.join("", ["username: ", params.username, "\npassword: ", params.password]),
            "credentials.yaml": std.join("", ["username: ", username, "\npassword: ", password]),
        },
        "type": "Opaque",
    },
]