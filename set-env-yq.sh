if [[ ! $# -eq 4 ]]; then
    echo "ERORR: not enough args(repo url / branch / network / private_registry)"
    exit -1
fi

files=($(ls application/*.yaml))
for file in "${files[@]}"; do
    yq e --inplace '.spec.source.repoURL = "'"$1"'"' "$file"
    yq e --inplace '.spec.source.targetRevision = "'"$2"'"' "$file"
    yq e --inplace '.spec.source.directory.jsonnet.tlas[0].value = "'"$3"'"' "$file"
    yq e --inplace '.spec.source.directory.jsonnet.tlas[1].value = "'"$4"'"' "$file"
done
