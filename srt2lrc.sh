#!/bin/bash

function srt2lrc() {
    local TIME=$(cat ${FILENAME} | \
            grep "\-\->" | \
            awk '{ print $1 }' | \
            awk -F ':' '{ if ($1 != 0) { print ($1 * 60 + $2)":"$3 } else { print $2":"$3 } }' | \
            awk -F ',' '{ print $1"."$2 }' | \
            sed 's/.$//' | \
            awk '{ print "["$0"]" }')

    local SUBTITLES=$(cat ${FILENAME} | \
                awk '/\-\->/{ getline a; print a }')

    local FILENAME=${FILENAME::-4}

    paste -d " " <(echo "${TIME}") <(echo "${SUBTITLES}") | \
    tee ${FILENAME}.lrc >/dev/null 2>&1
}

function help() {
    cat <<EOF
USAGE
  bash srt2lrc.sh [OPTION] [<ARG>]

OPTION
  -h, --help        Show help manual
  -f, --file <path> Input filename path
EOF
    exit 0
}

function main() {
    local FILE_NAME=""

    if [ "$#" -eq 0 ]; then
        help
    fi

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -h|--help)
                help
                ;;
            -f|--file)
                if [ "$#" -lt 2 ]; then
                    echo "WARNING: Option \"$1\" requires an argument!"
                    exit 1
                fi
                FILE_NAME="$2"
                shift 2
                ;;
            *)
                echo "ERROR: Invalid option \"$1\"!"
                exit 1
                ;;
        esac
    done
    srt2lrc
}

main "$@"
