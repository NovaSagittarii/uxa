# FROM debian:trixie-slim
FROM rust:1.95.0-trixie

RUN apt update
RUN apt install -y git curl

WORKDIR /uxa-job

COPY install.sh install.sh
RUN bash install.sh

# nice things to have
RUN apt install -y htop tmux openssh-server vim
EXPOSE 22

COPY start.sh start.sh
# CMD [ "bash", "/uxa-job/start.sh"]
