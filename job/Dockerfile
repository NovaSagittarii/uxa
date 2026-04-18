FROM debian:trixie-slim

RUN apt update
RUN apt install -y git curl

WORKDIR /uxa-job

# v0.7.1-beta.1049
RUN git clone https://github.com/zeroclaw-labs/zeroclaw.git && \
    git -C zeroclaw reset --hard 0205572fc2dd2b52f52617a11466e25456a27b52
