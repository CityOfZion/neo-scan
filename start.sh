#!/bin/sh

if [ "$APP" = "neoscan_api" ]; then
    DOC=`ls /opt/app/lib/neoscan_web-*/priv/static/docs/index.html`
    [ "$TEST_NET" == "true" ] && sed -i.bak 's/main_net/test_net/g' $DOC
    sed -i.bak "s/https\:\/\/neoscan.io/https\:\/\/$HOST/g" $DOC
    mv $DOC /tmp/file
    rm /opt/app/lib/neoscan_web-*/priv/static/docs/*
    mv /tmp/file $DOC
fi

/opt/app/bin/${APP} migrate
/opt/app/bin/${APP} foreground
