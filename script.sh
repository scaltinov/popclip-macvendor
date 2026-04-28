#!/bin/bash
# PopClip Extension: MAC Vendor
# Look up vendor/manufacturer information for a selected MAC address

export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

MAC="${1:-$POPCLIP_TEXT}"

SHOW_MAC="${POPCLIP_OPTION_SHOW_MAC:-1}"
SHOW_COMPANY="${POPCLIP_OPTION_SHOW_COMPANY:-1}"
SHOW_PREFIX="${POPCLIP_OPTION_SHOW_PREFIX:-1}"
SHOW_COUNTRY="${POPCLIP_OPTION_SHOW_COUNTRY:-1}"
SHOW_ADDRESS="${POPCLIP_OPTION_SHOW_ADDRESS:-0}"
SHOW_BLOCK_TYPE="${POPCLIP_OPTION_SHOW_BLOCK_TYPE:-0}"
SHOW_PRIVATE_FLAG="${POPCLIP_OPTION_SHOW_PRIVATE_FLAG:-0}"
COPY_CLIPBOARD="${POPCLIP_OPTION_COPY_TO_CLIPBOARD:-1}"
SHOW_DIALOG="${POPCLIP_OPTION_SHOW_DIALOG:-1}"

is_valid_mac() {
  local mac=$1
  [[ $mac =~ ^([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}$ ]] || \
  [[ $mac =~ ^([0-9a-fA-F]{4}\.){2}[0-9a-fA-F]{4}$ ]]
}

normalize_mac() {
  local mac=$1
  # Cisco dot notation: AABB.CCDD.EEFF -> AA:BB:CC:DD:EE:FF
  if [[ $mac =~ ^([0-9a-fA-F]{4})\.([0-9a-fA-F]{4})\.([0-9a-fA-F]{4})$ ]]; then
    local p1="${BASH_REMATCH[1]}"
    local p2="${BASH_REMATCH[2]}"
    local p3="${BASH_REMATCH[3]}"
    mac="${p1:0:2}:${p1:2:2}:${p2:0:2}:${p2:2:2}:${p3:0:2}:${p3:2:2}"
  fi
  # Unify separator to colon and uppercase
  echo "$mac" | tr '-' ':' | tr '[:lower:]' '[:upper:]'
}

extract_json_field() {
  local json=$1
  local field=$2
  echo "$json" | python3 -c "import json,sys; d=json.load(sys.stdin); v=d.get('$field',''); print(v if v is not None else '')" 2>/dev/null
}

if ! is_valid_mac "$MAC"; then
  osascript -e 'display notification "Invalid MAC address" with title "MAC Vendor"'
  exit 0
fi

NORMALIZED=$(normalize_mac "$MAC")

JSON=$(curl -s --max-time 5 "https://api.maclookup.app/v2/macs/$NORMALIZED" 2>/dev/null)

if [ -z "$JSON" ]; then
  osascript -e 'display notification "Connection failed" with title "MAC Vendor"'
  exit 0
fi

FOUND=$(extract_json_field "$JSON" "found")
if [ "$FOUND" != "True" ] && [ "$FOUND" != "true" ] && [ "$FOUND" != "1" ]; then
  osascript -e "display notification \"Vendor not found: $NORMALIZED\" with title \"MAC Vendor\""
  exit 0
fi

OUTPUT=""
if [ "$SHOW_MAC" = "1" ]; then
  OUTPUT="MAC: $MAC"
fi

append() {
  local line=$1
  if [ -z "$OUTPUT" ]; then
    OUTPUT="$line"
  else
    OUTPUT+="\n$line"
  fi
}

if [ "$SHOW_COMPANY" = "1" ]; then
  COMPANY=$(extract_json_field "$JSON" "company")
  [ -n "$COMPANY" ] && append "Vendor: $COMPANY"
fi

if [ "$SHOW_PREFIX" = "1" ]; then
  PREFIX=$(extract_json_field "$JSON" "macPrefix")
  [ -n "$PREFIX" ] && append "OUI: $PREFIX"
fi

if [ "$SHOW_COUNTRY" = "1" ]; then
  COUNTRY=$(extract_json_field "$JSON" "country")
  [ -n "$COUNTRY" ] && append "Country: $COUNTRY"
fi

if [ "$SHOW_ADDRESS" = "1" ]; then
  ADDRESS=$(extract_json_field "$JSON" "address")
  [ -n "$ADDRESS" ] && append "Address: $ADDRESS"
fi

if [ "$SHOW_BLOCK_TYPE" = "1" ]; then
  BLOCK_TYPE=$(extract_json_field "$JSON" "blockType")
  [ -n "$BLOCK_TYPE" ] && append "Block: $BLOCK_TYPE"
fi

if [ "$SHOW_PRIVATE_FLAG" = "1" ]; then
  IS_PRIVATE=$(extract_json_field "$JSON" "isPrivate")
  [ -n "$IS_PRIVATE" ] && append "Private: $IS_PRIVATE"
fi

if [ "$COPY_CLIPBOARD" = "1" ] && [ -n "$OUTPUT" ]; then
  printf "%s" "$OUTPUT" | pbcopy
fi

if [ -n "$OUTPUT" ]; then
  if [ "$SHOW_DIALOG" = "1" ]; then
    OUTPUT_NL=$(echo -e "$OUTPUT")
    if [ "$COPY_CLIPBOARD" = "1" ]; then
      OUTPUT_NL="${OUTPUT_NL}

✔ Copied to clipboard"
    fi
    osascript - "$OUTPUT_NL" <<'OSA' >/dev/null
on run argv
  display dialog item 1 of argv buttons {"OK"} default button "OK" with title "MAC Vendor"
end run
OSA
  else
    echo -e "$OUTPUT"
  fi
fi
