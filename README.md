## Reference

- https://github.com/zeroclaw-labs/zeroclaw
- https://github.com/vercel-labs/agent-browser

## Local Run

```sh
docker run --rm --env-file job/.env -p 8000:8000 -it lithoium/uxa-job
```
[run.sh](run.sh) or [run.bat](run.bat)

## Deployment onto Kubernetes

```sh
helm upgrade -i uxa charts/uxa-job --set uxaConfig.apiKey=$ZEROCLAW_API_KEY --set uxaConfig.query="what's the weather like?"
```

```sh
source job/.env
export KUBECONFIG=$(realpath vultr/kubeconfig.yaml)
uv run streamlit run run-kube.py
```
