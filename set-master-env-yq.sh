if [[ ! $# -eq 2 ]]; then
    echo "ERORR: set-master-env-yq.sh needs 2 arguments, not ""$#"
    echo "USAGE : bash set-master-env-yq.sh [REPO_URL] [BRANCH_NAME]"
    exit -1
fi

yq e --inplace '.spec.source.repoURL = "'"$1"'"' application/app_of_apps/master-applications.yaml
yq e --inplace '.spec.source.targetRevision = "'"$2"'"' application/app_of_apps/master-applications.yaml