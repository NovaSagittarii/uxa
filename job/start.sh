#!/bin/bash

zeroclaw onboard \
    --force \
    --api-key $ZEROCLAW_API_KEY \
    --provider $ZEROCLAW_PROVIDER \
    --model $ZEROCLAW_MODEL \
    --quick
toml set ~/.zeroclaw/config.toml autonomy.level "full" > ~/.zeroclaw/config.toml.tmp
cp ~/.zeroclaw/config.toml.tmp ~/.zeroclaw/config.toml
toml set ~/.zeroclaw/config.toml agent.max_tool_iterations 100 > ~/.zeroclaw/config.toml.tmp
cp ~/.zeroclaw/config.toml.tmp ~/.zeroclaw/config.toml

toml set ~/.zeroclaw/config.toml reliability.max_retries 100 > ~/.zeroclaw/config.toml.tmp
cp ~/.zeroclaw/config.toml.tmp ~/.zeroclaw/config.toml
toml set ~/.zeroclaw/config.toml reliability.max_backoff_ms 60000 > ~/.zeroclaw/config.toml.tmp
cp ~/.zeroclaw/config.toml.tmp ~/.zeroclaw/config.toml

# exec bash
# /root/.local/bin/uv run /uxa-job/main.py &
# zeroclaw agent -m $ZEROCLAW_QUERY > /uxa-job/out.txt 2> /uxa-job/err.txt
# exec wait

zeroclaw agent -m $ZEROCLAW_QUERY > /uxa-job/out.txt 2> /uxa-job/err.txt
exec /root/.local/bin/uv run /uxa-job/main.py
