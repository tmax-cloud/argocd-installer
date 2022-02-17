if [[ ! $# -eq 4 ]]; then
    echo "ERORR: set-single-env-yq.sh needs 4 arguments, not ""$#"
    echo "USAGE : bash set-single-env-yq.sh [REPO_URL] [BRANCH_NAME] [CLUSTER_NAME] [PRIVATE_REGISTRY_URL]"
    exit -1
fi

path="application/app_of_apps"
newFile="$path"/"$3""-applications.yaml"
appName="$3""-applications"

cp -f "$path"/single-applications.yaml "$newFile"
yq e --inplace '.metadata.labels.cluster = "'"$3"'"' "$newFile"
yq e --inplace '.metadata.name = "'"$appName"'"' "$newFile"
yq e --inplace '.spec.source.repoURL = "'"$1"'"' "$newFile"
yq e --inplace '.spec.source.targetRevision = "'"$2"'"' "$newFile"
yq e --inplace '.spec.source.helm.parameters[0].value = "'"$3"'"' "$newFile"
yq e --inplace '.spec.source.helm.parameters[1].value = "'"$3"'"' "$newFile"
yq e --inplace '.spec.source.helm.parameters[2].value = "'"$4"'"' "$newFile"