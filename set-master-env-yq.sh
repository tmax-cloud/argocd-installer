if [[ ! $# -eq 2 ]]; then
    echo "ERORR: set-master-env-yq.sh needs 2 arguments, not ""$#"
    echo "USAGE : bash set-master-env-yq.sh [REPO_URL] [BRANCH_NAME]"
    #echo "USAGE : bash set-master-env-yq.sh [REPO_URL] [BRANCH_NAME] [NETWORK_DISABLED] [DOMAIN]"
    exit -1
fi

path="application/app_of_apps"
yq e --inplace '.spec.source.repoURL = "'"$1"'"' "$path"/master-applications.yaml
yq e --inplace '.spec.source.targetRevision = "'"$2"'"' "$path"/master-applications.yaml

#path="application/helm"
#authDomain="hyperauth.""$4"
#yq e --inplace '.spec.source.repoURL = "'"$1"'"' "$path"/shared-values.yaml
#yq e --inplace '.spec.source.targetRevision = "'"$2"'"' "$path"/shared-values.yaml
#yq e --inplace '.global.network.disabled = '"$3" "$path"/shared-values.yaml
#yq e --inplace '.global.domain = "'"$4"'"' "$path"/shared-values.yaml
#yq e --inplace '.global.keycloak.domain = "'"$authDomain"'"' "$path"/shared-values.yaml