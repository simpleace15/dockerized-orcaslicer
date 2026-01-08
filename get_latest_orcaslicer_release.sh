#!/bin/bash

TMPDIR="$(mktemp -d)"

# Fetch latest release data from GitHub API
curl -SsL https://api.github.com/repos/SoftFever/OrcaSlicer/releases/latest > "$TMPDIR/latest.json"

# Extract fields using jq with more flexible regex to match AppImage
url=$(jq -r '.assets[] | select(.browser_download_url | test("OrcaSlicer_Linux_AppImage_.+?_V[0-9]+\.[0-9]+\.[0-9]+(-[0-9a-zA-Z]+)?\.AppImage$")) | .browser_download_url' "$TMPDIR/latest.json")
name=$(jq -r '.assets[] | select(.browser_download_url | test("OrcaSlicer_Linux_AppImage_.+?_V[0-9]+\.[0-9]+\.[0-9]+(-[0-9a-zA-Z]+)?\.AppImage$")) | .name' "$TMPDIR/latest.json")
version=$(jq -r '.tag_name' "$TMPDIR/latest.json")

# Validate input
if [ $# -ne 1 ]; then
  echo "Wrong number of params"
  rm -rf "$TMPDIR"
  exit 1
else
  request=$1
fi

# Handle user request
case $request in
  url)
    echo "$url"
    ;;
  name)
    echo "$name"
    ;;
  version)
    echo "$version"
    ;;
  *)
    echo "Unknown request: $request"
    ;;
esac

# Cleanup
rm -rf "$TMPDIR"

exit 0