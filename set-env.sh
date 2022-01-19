if [[ ! $# -eq 4 ]]; then
    echo "ERORR: not enough args(repo url / branch / network / private_registry)"
    exit -1
fi

files=("$(ls application/*.yaml)")
for file in "${files[@]}"; do
    target=$(cat "$file" | grep repoURL)
    sed -i 's#'"$target"'#    repoURL: '"$1"'#g' "$file"
    target=$(cat "$file" | grep targetRevision)
    sed -i 's#'"$target"'#    targetRevision: '"$2"'#g' "$file"
    target=$(cat "$file" | grep is_offline -A 1 | grep value)
    sed -i 's#'"$target"'#            value: '"$3"'#g' "$file"
    target=$(cat "$file" | grep private_registry -A 1 | grep value)
    sed -i 's#'"$target"'#            value: '"$4"'#g' "$file"
done
