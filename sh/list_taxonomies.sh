#!/bin/sh
curl  -H 'Content-Type: application/json' -H 'Accept: application/json' \
    -H 'X-User-Email: bjorn@biocaching.com' -H 'X-User-Token: zCC868dPzS2Gp1y-UE1M' \
  -X GET "http://api.biocaching.com:82/api/taxonomies" 