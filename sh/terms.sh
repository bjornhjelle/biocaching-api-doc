#!/bin/sh
curl  -H 'X-User-Api-Key: <KEY>' -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -X GET 'https://api.biocaching.com/admin/terms'