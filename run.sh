set -euxo pipefail
docker build -t uxa-job job
docker run --rm --env-file job/.env -p 8000:8000 -it uxa-job
