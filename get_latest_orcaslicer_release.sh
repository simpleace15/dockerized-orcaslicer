#!/bin/bash

TMPDIR="$(mktemp -d)"
curl -SsL https://api.github.com/repos/SoftFever/OrcaSlicer/releases/latest > $TMPDIR/latest.json
url=$(jq -r '.assets[] | select(.browser_download_url|test(".*\\.AppImage"))| .browser_download_url' $TMPDIR/latest.json)
name=$(jq -r '.assets[] | select(.browser_download_url|test(".*\\.AppImage"))| .name' $TMPDIR/latest.json)
version=$(jq -r .tag_name $TMPDIR/latest.json)

if [[ "$name" == *Ubuntu* ]]; then
  curl -fSsL $url > /dev/null

  echo "Done! The Ubuntu AppImage file has been downloaded to the current directory."
else
  echo "No Ubuntu AppImage found in the latest release. Exiting..."
fi
