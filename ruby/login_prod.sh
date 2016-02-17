#!/bin/sh
curl  -v -H 'Content-Type: application/json' -H 'Accept: application/json' \
  -X POST "http://api.biocaching.com:82/users/sign_in" \
  -d '{"user" : { "email" : "bjorn@biocaching.com", "password" : "test1234"}}' \
  -c cookie
