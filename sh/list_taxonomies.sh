#!/bin/sh
curl  -H 'Content-Type: application/json' -H 'Accept: application/json' \
  -H 'X-User-Email: <EMAIL>' -H 'X-User-Token: <USER-TOKEN>' \
  -H 'X-User-Api-Key: <KEY>' \
  -X GET "http://api.biocaching.com:82/api/taxonomies" 