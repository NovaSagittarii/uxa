#!/bin/bash

zeroclaw onboard \
    --api-key $ZEROCLAW_API_KEY \
    --api-provider $ZEROCLAW_PROVIDER \
    --model $ZEROCLAW_MODEL \
    --quick \

exec bash
