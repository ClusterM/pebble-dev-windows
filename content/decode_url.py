#!/usr/bin/python3

import sys
import urllib.parse
import re

# Read input from stdin
input_data = sys.stdin.read().strip()

if not input_data.startswith('data:text/html'):
    print(input_data)
    sys.exit(0)

# Decode base HTML
data = input_data.split(',', 1)[1]
html = urllib.parse.unquote(data)

# Replace return_to url

match = re.search(r'\?return_to=(http://localhost:\d+/close\?)', html)
replacement_url = match.group(1) if match else None
html = re.sub(r'\?return_to=http://localhost:\d+/close\?', '', html)
if replacement_url and 'pebblejs://close#' in html:
    html = html.replace('pebblejs://close#', replacement_url)

# Re-encode
encoded = urllib.parse.quote(html)

print(f'data:text/html;charset=utf-8,{encoded}')
