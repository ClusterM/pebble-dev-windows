#!/usr/bin/sh

URL="$@"
URL_PARSED=$(echo "$URL" | decode_url)

chromium --no-sandbox --test-type "$URL_PARSED" 2>/dev/null &
