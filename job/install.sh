#!/bin/bash
set -euxo pipefail

apt install -y sudo  # needed for build script for agent-browser
apt install -y build-essential
# apt install -y mold
# mkdir -p /root/.cargo/
# cat <<EOF >> /root/.cargo/config.toml
# [target.'cfg(target_os = "linux")']
# rustflags = ["-C", "link-arg=-fuse-ld=mold"]
# EOF

echo 'export PATH="$PATH:/usr/local/cargo/bin"' >> ~/.bashrc
export PATH="$PATH:/usr/local/cargo/bin"

# zeroclaw v0.7.1-beta.1049
(
    git clone https://github.com/zeroclaw-labs/zeroclaw.git && \
    git -C zeroclaw reset --hard 0205572fc2dd2b52f52617a11466e25456a27b52 && \
    cd zeroclaw && ./install.sh --skip-onboard
) &
# agent-browser (install --with-deps uses apt!!)
(cargo install agent-browser && agent-browser install --with-deps) &
(cargo install toml-cli) &
(
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    /root/.local/bin/uv sync
) &
wait
