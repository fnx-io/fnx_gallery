#!/bin/sh
pub build example &&
cd build;
rm `find . -name *.ng_*.json`;
cd example &&
gcloud --project ma-web compute copy-files * static-ma:/usr/share/nginx/www/demo.fnx.io/fnx_gallery --zone europe-west1-b;
