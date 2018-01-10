# Proximial Policy Optimization using [tensorflow/agents](https://github.com/tensorflow/agents)

The following may be used to launch the [demo notebook](demo.ipynb):

```bash
docker run -ti --rm -p 8888:8888 \
-v /tmp/kubeflow-agents-render/7bafff5b:/tmp/kubeflow-agents-render/7bafff5b \
--entrypoint /usr/bin/env --name kubeflow-rl \
gcr.io/kubeflow-rl/agents-ppo:cpu-9693bd40 jupyter notebook --allow-root
```

Renders can be run inside of the kubeflow-rl container, which has the necessary pybullet and other dependencies installed, such as with the following:

```bash

LOG_DIR=/tmp/kubeflow-agents-render/7bafff5b

docker run --workdir /app \
  -v ${LOG_DIR}:${LOG_DIR} \
  -it gcr.io/kubeflow-rl/agents-ppo:cpu-e50643ec \
  --logdir ${LOG_DIR} --config pybullet_kuka \
  --mode render --run_base_tag render
```
