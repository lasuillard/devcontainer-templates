#!/usr/bin/env bash

: '
Build and run tests in a container built from a template.

Usage:
  scripts/test-template.sh <template-id>
'

set -o errexit
set -o nounset
set -o pipefail

shopt -s dotglob

template_id="$1"

tmpdir="${TMPDIR:-/tmp}/devcontainer-templates"
src_dir="${tmpdir}/${template_id}"

echo "Copying template '${template_id}' to '${src_dir}'"
mkdir --parents "${tmpdir}"
cp --recursive "src/${template_id}" "${src_dir}"

pushd "${src_dir}"

# Configure templates only if `devcontainer-template.json` contains the `options` property.
mapfile -t option_property < <(jq --raw-output '.options' devcontainer-template.json)

if [ "${option_property[*]}" != "" ] && [ "${option_property[*]}" != "null" ]; then
  mapfile -t options < <(jq --raw-output '.options | keys[]' devcontainer-template.json)

  if [ "${options[0]}" != "" ] && [ "${options[0]}" != "null" ]; then
    echo "Configuring template options for '${template_id}'"
    for option in "${options[@]}"; do
      option_key="\${templateOption:${option}}"
      option_value="$(jq --raw-output ".options | .${option} | .default" devcontainer-template.json)"

      if [ "${option_value}" = "" ] || [ "${option_value}" = "null" ]; then
        echo "Template '${template_id}' is missing a default value for option '${option}'"
        exit 1
      fi

      echo "Replacing '${option_key}' with '${option_value}'"
      option_value_escaped=$(sed --expression='s/[]\/$*.^[]/\\&/g' <<<"${option_value}")
      find ./ -type f -print0 | xargs --null sed --in-place "s/${option_key}/${option_value_escaped}/g"
    done
  fi
fi

popd

test_dir="test/${template_id}"
if [ -d "${test_dir}" ]; then
  echo "Copying test folder"
  dest_dir="${src_dir}/test-project"
  mkdir --parents "${dest_dir}"
  cp --recursive --preserve=mode,ownership,timestamps "${test_dir}"/* "${dest_dir}"
  cp --recursive --preserve=mode,ownership,timestamps test/test-utils/* "${dest_dir}"
fi

echo "Building Dev Container"
export DOCKER_BUILDKIT=1
id_label="test-container=${template_id}"
devcontainer up --id-label "${id_label}" --workspace-folder "${src_dir}"

echo "Registering cleanup handler on exit"
function cleanup() {
  echo "Cleaning up"
  docker container ls --filter "label=${id_label}" --quiet |
    xargs --no-run-if-empty \
      docker container rm --force

  rm --recursive --force "${src_dir}"
}
trap cleanup EXIT

echo "Running tests"
devcontainer exec \
  --workspace-folder "${src_dir}" \
  --id-label "${id_label}" \
  /bin/sh -s <<EOF
set -o errexit

if [ -f "test-project/test.sh" ]; then
  cd test-project
  if [ "$(id -u)" = "0" ]; then
    chmod +x test.sh
  else
    sudo chmod +x test.sh
  fi
  ./test.sh
else
  ls -a
fi
EOF
