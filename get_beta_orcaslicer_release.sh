###

# work in progress

###

#!/bin/bash

TMPDIR="$(mktemp -d)"

# Fetch nightly builds release data from GitHub
curl -SsL https://api.github.com/repos/SoftFever/OrcaSlicer/releases/tags/nightly-builds > "$TMPDIR/nightly.json"

# Extract fields using jq to match the nightly AppImage for Ubuntu 24.04
url=$(jq -r '.assets[] | select(.browser_download_url | test("OrcaSlicer_Linux_AppImage_Ubuntu2404_V[0-9]+\\.[0-9]+\\.[0-9]+-dev\\.AppImage$")) | .browser_download_url' "$TMPDIR/nightly.json")
name=$(jq -r '.assets[] | select(.browser_download_url | test("OrcaSlicer_Linux_AppImage_Ubuntu2404_V[0-9]+\\.[0-9]+\\.[0-9]+-dev\\.AppImage$")) | .name' "$TMPDIR/nightly.json")
version=$(jq -r '.tag_name' "$TMPDIR/nightly.json")

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
