#!/bin/sh
# shellcheck shell=dash

SCRIPTS_LOGFILE='/tmp/scripts.log'
MQTT_LOGFILE='/tmp/mqtt.log'
WORKDIR='/tmp'

# Leave the last 2000 lines in files larger than 500 Kb
clean_tmpfs() {
    cd "$WORKDIR"
    for i in "$SCRIPTS_LOGFILE" "$MQTT_LOGFILE"; do
        tmpName="$(mktemp)"
        tail -n 2000 "$i" > "$tmpName" && mv "$tmpName" "$i"
    done
}

log() {
	logger -t "[${0##*/}]" "$@"
	echo "[$(date +'%F %T')] [${0##*/}] $*" >> "${SCRIPTS_LOGFILE}"
	clean_tmpfs
}
