#!/bin/sh
DOC=`ls /opt/app/lib/neoscan_web-*/priv/static/docs/index.html`
sed -i.bak 's/main_net/test_net/g' $DOC
sed -i.bak "s/neoscan.io/$HOST/g" $DOC
mv $DOC /tmp/file
rm /opt/app/lib/neoscan_web-*/priv/static/docs/*
mv /tmp/file $DOC

/opt/app/bin/neoscan migrate
/opt/app/bin/neoscan foreground
