#!/usr/bin/env bash
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# For now, just assume we're building a cpu image

get_project_id() {
  # From
  # Find the project ID first by DEVSHELL_PROJECT_ID (in Cloud Shell)
  # and then by querying the gcloud default project.
  local project="${DEVSHELL_PROJECT_ID:-}"
  if [[ -z "$project" ]]; then
    project=$(gcloud config get-value project 2> /dev/null)
  fi
  if [[ -z "$project" ]]; then
    >&2 echo "No default project was found, and DEVSHELL_PROJECT_ID is not set."
    >&2 echo "Please use the Cloud Shell or set your default project by typing:"
    >&2 echo "gcloud config set project YOUR-PROJECT-NAME"
  fi
  echo "$project"
}

upsearch () {
  test / == "$PWD" && return || \
      test -e "$1" && echo "$PWD" && return || \
      cd .. && upsearch "$1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT=$(upsearch WORKSPACE)
AGENT_LIB=${1:-baselines}

IMAGE_BASE_NAME=kubeflow-rl-${AGENT_LIB}
CPU_GPU=cpu

PROJECT_ID=$(get_project_id)
SALT=`date | shasum -a 256 | cut -c1-8`
VERSION_TAG=${CPU_GPU}-${SALT} # probably want git hash of agents not kubeflow-rl
IMAGE_TAG=gcr.io/${PROJECT_ID}/${IMAGE_BASE_NAME}:${VERSION_TAG}

cd ${WORKSPACE_ROOT}

docker build -t ${IMAGE_TAG} -f tools/base/Dockerfile.${AGENT_LIB} .

gcloud docker -- push ${IMAGE_TAG}
