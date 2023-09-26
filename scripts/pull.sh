#!/bin/sh

GIT="$(grep 'url =' .git/config | awk '{print $3}')"

cd ../ && rm -rf TS_Firmware

git clone "$GIT" && \
	echo "GIT $GIT update is done"
if [ -d TS_Firmware ]; then
    cd TS_Firmware || \
    exit 1
else
	echo "Update fail!"
fi
