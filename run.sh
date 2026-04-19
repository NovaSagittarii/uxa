set -euxo pipefail
docker build -t uxa-job job
docker run --rm --env-file job/.env -it uxa-job
