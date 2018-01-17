# Proximial Policy Optimization using [tensorflow/agents](https://github.com/tensorflow/agents)

The following may be used to launch the [demo notebook](demo.ipynb):

```bash
docker run -ti --rm -p 8888:8888 \
-v /tmp/kubeflow-agents-render/7bafff5b:/tmp/kubeflow-agents-render/7bafff5b \
--entrypoint /usr/bin/env --name kubeflow-rl \
gcr.io/kubeflow-rl/agents-ppo:cpu-9693bd40 jupyter notebook --allow-root
```

TODO: Run on JupyterHub via kubeflow!

[![](render_preview.png)](render.mp4)
