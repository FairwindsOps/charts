#! /bin/bash
set -eo pipefail

folders=( ./stable ./incubator )
for d in "${folders[@]}"; do
  for chart in "${d}"/* ; do
      if [ ! -d "${chart}" ]; then
        continue
      fi
      version=$(yq eval '.version' "$chart/Chart.yaml")
      version=$(echo "$version" | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
      yq eval -i ".version = \"$version\"" "$chart/Chart.yaml"
  done
done
