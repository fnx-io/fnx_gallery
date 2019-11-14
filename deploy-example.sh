#!/bin/sh
webdev build -o example:build &&
cd build &&
gcloud --project ma-web compute scp * static-ma:/usr/share/nginx/www/demo.fnx.io/fnx_gallery --zone europe-west1-b --recurse
