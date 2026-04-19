docker build -t uxa-job job || exit /b 1
docker run --rm -it uxa-job --env-file uxa\.env || exit /b 1
@REM docker run --rm -it -p 2222:22 uxa-job || exit /b 1
