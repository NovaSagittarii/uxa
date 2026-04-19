#!/bin/bash

zeroclaw onboard \
    --api-key $ZEROCLAW_API_KEY \
    --provider $ZEROCLAW_PROVIDER \
    --model $ZEROCLAW_MODEL \
    --quick \
toml set ~/.zeroclaw/config.toml autonomy.level "full" > ~/.zeroclaw/config.toml

exec bash
