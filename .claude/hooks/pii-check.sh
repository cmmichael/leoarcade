#!/bin/bash
# Claude Code PreToolUse hook: before git commit/push, scan public/ for obvious
# personal info. Exit 2 blocks the command and shows the message to Claude.

input=$(cat)
echo "$input" | grep -qE 'git[^"]*(commit|push)' || exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
[ -d public ] || exit 0

problems=""

text_hits=$(grep -rnIE \
  -e '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' \
  -e '(\+?1[ .-]?)?\(?[0-9]{3}\)?[ .-][0-9]{3}[ .-][0-9]{4}' \
  -e '\b[0-9]{1,5} [A-Z][a-z]+ (St|Street|Ave|Avenue|Rd|Road|Dr|Drive|Ln|Lane|Ct|Court|Blvd|Way|Pl|Place)\b' \
  public 2>/dev/null | grep -v 'pii-ok')
[ -n "$text_hits" ] && problems+="Possible email / phone / street address:
$text_hits
"

while IFS= read -r -d '' img; do
  gps=""
  if command -v exiftool >/dev/null; then
    gps=$(exiftool -s -s -s -GPSPosition "$img" 2>/dev/null)
  elif command -v mdls >/dev/null; then
    gps=$(mdls -raw -name kMDItemLatitude "$img" 2>/dev/null | grep -v null)
  fi
  [ -n "$gps" ] && problems+="Image has GPS location data: $img
"
done < <(find public -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.heic' -o -iname '*.png' -o -iname '*.tif*' \) -print0)

if [ -n "$problems" ]; then
  cat >&2 <<MSG
PRIVACY CHECK BLOCKED THIS COMMAND. This site is public.
$problems
Ask Leo about each item before continuing. Remove real personal info, strip GPS
from photos (e.g. re-export without location, or: exiftool -gps:all= FILE), or mark
intentionally fake text with a "pii-ok" comment on the same line.
MSG
  exit 2
fi
exit 0
