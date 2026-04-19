docker build -t uxa-job job || exit /b 1
docker run --rm --env-file job\.env -it uxa-job || exit /b 1
@REM docker run --rm -it -p 2222:22 uxa-job || exit /b 1
