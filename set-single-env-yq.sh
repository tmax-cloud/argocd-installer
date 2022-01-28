if [[ ! $# -eq 4 ]]; then
    echo "ERORR: set-single-env-yq.sh needs 4 arguments, not ""$#"
    echo "USAGE : bash set-single-env-yq.sh [REPO_URL] [BRANCH_NAME] [CLUSTER_INFO_TYPE] [CLUSTER_INFO]"
    echo "CLUSTER_INFO_TYPE : name / server"
    exit -1
fi

yq e --inplace '.spec.source.repoURL = "'"$1"'"' application/app_of_apps/single-applications.yaml
yq e --inplace '.spec.source.targetRevision = "'"$2"'"' application/app_of_apps/single-applications.yaml
yq e --inplace '.spec.destination.'"$3"' = "'"$4"'"' application/app_of_apps/single-applications.yaml