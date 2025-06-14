#!/bin/bash

TMPDIR="$(mktemp -d)"
#curl for latest releases
curl -SsL https://api.github.com/repos/SoftFever/OrcaSlicer/releases/latest > $TMPDIR/latest.json

# Get the latest stable that contains a matching AppImage
url=$(jq -r '.assets[] | select(.browser_download_url|test("Linux.*_AppImage_Ubuntu2404_V*.*.*.AppImage$"))| .browser_download_url' $TMPDIR/latest.json)
name=$(jq -r '.assets[] | select(.browser_download_url|test("Linux.*_AppImage_Ubuntu2404_V*.*.*.AppImage$"))| .name' $TMPDIR/latest.json)
version=$(jq -r .tag_name $TMPDIR/latest.json)

if [ $# -ne 1 ]; then
  echo "Wrong number of params"
  exit 1
else
  request=$1
fi

case $request in

  url)
    echo $url
    ;;

  name)
    echo $name
    ;;

  version)
    echo $version
    ;;

  *)
    echo "Unknown request"
    ;;
esac

rm -rf $TMPDIR

exit 0
