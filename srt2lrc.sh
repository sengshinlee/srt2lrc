#!/bin/bash

function srt2lrc() {
    TIME=$(cat ${FILENAME} | \
            grep "\-\->" | \
            awk '{print $1}' | \
            awk -F ':' '{print $2":"$3}' | \
            awk -F ',' '{print $1"."$2}' | \
            sed 's/.$//' | \
            awk '{print "["$0"]"}')

    SUBTITLES=$(cat ${FILENAME} | \
                awk '/\-\->/{getline a;print a}')

    FILENAME=${FILENAME::-4}

    paste -d " " <(echo "${TIME}") <(echo "${SUBTITLES}") | \
    tee ${FILENAME}.lrc >/dev/null 2>&1
}

function help() {
    echo '
USAGE
  bash srt2lrc.sh [OPTION] [<ARG>]

OPTION
  -h        Show help manual
  -f <path> Input filename path
'
}

function main() {
    local ARG="$1"

    if [ -z "${ARG}" ] || [ "${ARG}" == "-h" ]; then
        help
        exit 0
    fi

    if [ "$(echo ${ARG} | cut -c 1)" != "-" ] || [ "$(echo ${ARG} | cut -c 2)" == "-" ]; then
        echo "srt2lrc.sh: illegal option -- '${ARG}'"
        help
        exit 0
    fi

    while getopts f: ARG; do
        case "${ARG}" in
        f)
            FILENAME=${OPTARG}
            ;;
        *)
            help
            exit 0
            ;;
        esac
    done

    srt2lrc
}

main "$@"
