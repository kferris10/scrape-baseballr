#!/bin/sh

echo "$1"

if [ "$1" = "--action=scrape" ] ; then
  Rscript scrape-baseballr.R "${@:2}"
else
  echo "Invalid action. Must be 'scrape'"
  exit 1
fi
