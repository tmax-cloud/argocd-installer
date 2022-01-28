if [[ ! $# -eq 3 ]]; then
    echo "ERORR: set-single-env-yq.sh needs 3 arguments, not ""$#"
    echo "USAGE : bash set-single-env-yq.sh [REPO_URL] [BRANCH_NAME] [CLUSTER_NAME]"
    exit -1
fi

yq e --inplace '.metadata.name = '"$3"'-applications' application/app_of_apps/single-applications.yaml
yq e --inplace '.spec.source.repoURL = "'"$1"'"' application/app_of_apps/single-applications.yaml
yq e --inplace '.spec.source.targetRevision = "'"$2"'"' application/app_of_apps/single-applications.yaml
yq e --inplace '.spec.destination.name = "'"$3"'"' application/app_of_apps/single-applications.yaml