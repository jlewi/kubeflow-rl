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

# Note: Requires py/requirements.txt

get_project_id() {
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

if [[ -z $(command -v jinja2) ]]; then
  echo "The jinja2 command line utlity is required, installed via pip install jinja2-cli"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

IMAGE_BASE_NAME=baselines
EXAMPLE_PATH=${SCRIPT_DIR}

PROJECT_ID=$(get_project_id)
SALT=`date | shasum -a 256 | cut -c1-8`
VERSION_TAG=cpu-${SALT}
IMAGE_TAG=gcr.io/${PROJECT_ID}/${IMAGE_BASE_NAME}:${VERSION_TAG}
JOB_NAME=${IMAGE_BASE_NAME}-${SALT}
LOG_DIR=gs://${PROJECT_ID}-k8s/jobs/run-${SALT}

cd ${SCRIPT_DIR}
docker build -t ${IMAGE_TAG} .
gcloud docker -- push ${IMAGE_TAG}
