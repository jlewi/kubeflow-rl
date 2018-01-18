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

FROM gcr.io/kubeflow-rl/kubeflow-rl-agents:cpu-55d1a0ef

ADD trainer /app/trainer/

# TODO: Split demo stuff out into separate container?
ADD * /app/demo/

WORKDIR /app/

ENTRYPOINT ["python", "-m", "trainer.task"]
