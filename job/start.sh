#!/bin/bash

zeroclaw onboard \
    --force \
    --api-key $ZEROCLAW_API_KEY \
    --provider $ZEROCLAW_PROVIDER \
    --model $ZEROCLAW_MODEL \
    --quick
toml set ~/.zeroclaw/config.toml autonomy.level "full" > ~/.zeroclaw/config.toml.tmp
cp ~/.zeroclaw/config.toml.tmp ~/.zeroclaw/config.toml
toml set ~/.zeroclaw/config.toml agent.max_tool_iterations "STRIP(100)" > ~/.zeroclaw/config.toml.tmp
cp ~/.zeroclaw/config.toml.tmp ~/.zeroclaw/config.toml

toml set ~/.zeroclaw/config.toml reliability.max_retries "STRIP(100)" > ~/.zeroclaw/config.toml.tmp
cp ~/.zeroclaw/config.toml.tmp ~/.zeroclaw/config.toml
toml set ~/.zeroclaw/config.toml reliability.max_backoff_ms "STRIP(60000)" > ~/.zeroclaw/config.toml.tmp
cp ~/.zeroclaw/config.toml.tmp ~/.zeroclaw/config.toml
toml set ~/.zeroclaw/config.toml pacing.loop_detection_enabled "STRIP(false)" > ~/.zeroclaw/config.toml.tmp
cp ~/.zeroclaw/config.toml.tmp ~/.zeroclaw/config.toml
# handle the fact that toml-cli can't do typed replacement lol
cat ~/.zeroclaw/config.toml.tmp | sed -E 's/"STRIP\(([^)]*)\)"/\1/g' > ~/.zeroclaw/config.toml

# exec bash
# /root/.local/bin/uv run /uxa-job/main.py &
# zeroclaw agent -m $ZEROCLAW_QUERY > /uxa-job/out.txt 2> /uxa-job/err.txt
# exec wait

zeroclaw agent -m "$ZEROCLAW_QUERY" > /uxa-job/out.txt 2> /uxa-job/err.txt
cat /uxa-job/out.txt  # print for visibility
cat /uxa-job/err.txt
exec /root/.local/bin/uv run /uxa-job/main.py
