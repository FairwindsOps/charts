#!/usr/bin/env bash
# shellcheck disable=SC1003
set -e

version=0.1.1
image_version=0.5

# Based on https://gist.github.com/pkuczynski/8665367
# https://github.com/jasperes/bash-yaml MIT license

parse_yaml() {
    local yaml_file=$1
    local prefix=$2
    local s
    local w
    local fs

    s='[[:space:]]*'
    w='[a-zA-Z0-9_.-]*'
    fs="$(echo @|tr @ '\034')"

    (
        sed -e '/- [^\“]'"[^\']"'.*: /s|\([ ]*\)- \([[:space:]]*\)|\1-\'$'\n''  \1\2|g' |

        sed -ne '/^--/s|--||g; s|\"|\\\"|g; s/[[:space:]]*$//g;' \
            -e "/#.*[\"\']/!s| #.*||g; /^#/s|#.*||g;" \
            -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
            -e "s|^\($s\)\($w\)${s}[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |

        awk -F"$fs" '{
            indent = length($1)/2;
            if (length($2) == 0) { conj[indent]="+";} else {conj[indent]="";}
            vname[indent] = $2;
            for (i in vname) {if (i > indent) {delete vname[i]}}
                if (length($3) > 0) {
                    vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                    printf("%s%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, conj[indent-1],$3);
                }
            }' |

        sed -e 's/_=/+=/g' |

        awk 'BEGIN {
                FS="=";
                OFS="="
            }
            /(-|\.).*=/ {
                gsub("-|\\.", "_", $1)
            }
            { print }'
    ) < "$yaml_file"
}
create_variables() {
    local yaml_file="$1"
    local prefix="$2"
    eval "$(parse_yaml "$yaml_file" "$prefix")"
}

create_variables fairwinds-insights.yaml fairwinds_

fairwinds_images_folder=${fairwinds_images_folder:='./_insightsTempImages'}

mkdir -p $fairwinds_images_folder
for img in ${fairwinds_images_docker[@]}; do
    echo "Saving image $img"
    if [[ "$img" != "[]" && "$img" != "" ]]
    then
        if [[ "$(docker images -q "${img}" 2> /dev/null)" == "" ]]; then
            docker pull $img
        fi
        docker save $img -o $fairwinds_images_folder/$(basename $img | sed -e 's/[^a-zA-Z0-9]//g').tar
    fi
done

docker pull quay.io/fairwinds/insights-ci:$image_version

docker create --name insights-ci \
  -e FAIRWINDS_TOKEN=$FAIRWINDS_TOKEN \
  -e SCRIPT_VERSION=$version \
  quay.io/fairwinds/insights-ci:$image_version

docker cp . insights-ci:/insights
failed=0
docker start -a insights-ci || failed=1

if [[ "$fairwinds_options_junitOutput" != "" ]]
then
    docker cp insights-ci:/insights/$fairwinds_options_junitOutput $fairwinds_options_junitOutput || echo "No jUnit output found"
fi
docker rm insights-ci
if [ "$failed" -eq "1" ]; then
    exit 1
fi
