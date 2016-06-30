#!/bin/sh
curl  -H 'Content-Type: application/json' -H 'Accept: application/json' \
  -H 'X-User-Api-Key: <KEY>' \
  -X POST 'https://api.biocaching.com/users/sign_in' \
  -d '{"user" : { "email" : "<EMAIL>", "password" : "<PASSWORD>"}}' \
