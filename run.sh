set -euxo pipefail
docker build -t uxa-job job
docker run --rm --env-file job/.env -p 80:80 -it uxa-job
