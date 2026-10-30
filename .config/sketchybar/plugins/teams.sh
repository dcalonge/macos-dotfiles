#!/bin/bash

# Try to extract Teams presence from local storage
DB="$HOME/Library/Application Support/Microsoft/Teams"

STATUS=$(grep -rho '"availability":"[^"]*"' "$DB" 2>/dev/null \
  | tail -1 \
  | cut -d'"' -f4)

echo "$STATUS"
