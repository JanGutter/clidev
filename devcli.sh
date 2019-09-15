#!/bin/bash
# Copyright 2019, Jan Gutter
# SPDX-License-Identifier: GPL-3.0-only

###########################################################################
# devcli.sh: a thin wrapper around docker to help manage multiple CLI dev #
# environments                                                            #
###########################################################################

# Undocumented debug option: if the first argument is '-d', enable tracing

if [ "$1x" == "-dx" ]; then
    set -xe
    shift 1
fi

ENVS=()
MOUNTS=()
source config.sh
source functions.sh
check_config
load_config
scan_envs

usage () {
    cat << '    EOF' | sed 's/^        //'
        Syntax
        ------
        ./devcli.sh command [args]

        command
        -------
        help:             this output
        list:             list available environments
        build ENV:        build environment "ENV"
        run ENV [args]:   run environment "ENV" with optional args
    EOF
    exit 0
}


[ "$#" == "0" ] && usage

ACTION=$1
case $ACTION in
    build )
        build_image $2
        ;;
    run )
        shift 1
        run_image $*
        ;;
    list )
        list_envs
        ;;
    * )
        usage
        ;;

esac
exit 0
# vim: tabstop=4 shiftwidth=4 softtabstop=4 expandtab:
