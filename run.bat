docker build -t uxa-job job || exit /b 1
docker run --rm -it uxa-job || exit /b 1
