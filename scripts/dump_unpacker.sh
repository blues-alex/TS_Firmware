#!/bin/sh

FILE="${1}"

echo "File: ${FILE}"
WORKDIR=`echo "${FILE}" | cut -d'.' -f -2`
echo "TRY read file ${FILE}"
DATA="`zcat ${FILE}`"

[ ! -d "${WORKDIR}" ] && \
	mkdir -p "${WORKDIR}"

for key in `echo "${DATA}" | jq 'keys' | jq -r '.[]' `; do
	echo "${DATA}" | jq -r ".$key" | base64 -d >"${WORKDIR}/$key"
	case `file --mime-type -b "${WORKDIR}/$key"` in
		"application/json")
			jq '.' "${WORKDIR}/$key" > "${WORKDIR}/$key.json"
			rm "${WORKDIR}/$key"
			;;
		"text/plain") 
			mv "${WORKDIR}/$key" "${WORKDIR}/$key.txt"
			;;
		"application/gzip")
			zcat "${WORKDIR}/$key" > "${WORKDIR}/$key.txt"
			rm "${WORKDIR}/$key"
			;;
		"inode/x-empty") 
			mv "${WORKDIR}/$key" "${WORKDIR}/$key.empty"
		;;
	esac
done
