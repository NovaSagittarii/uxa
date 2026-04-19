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
exec zeroclaw agent

# zeroclaw agent -m "your query"
