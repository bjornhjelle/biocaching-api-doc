#!/bin/sh
curl  -H 'X-User-Api-Key: <KEY>' -H 'X-User-Email: <EMAIL>' \
  -H 'X-User-Token: <USER-TOKEN>' -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -X GET 'https://api.biocaching.com/terms/status'