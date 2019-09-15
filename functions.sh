#!/bin/bash
# Copyright 2019, Jan Gutter
# SPDX-License-Identifier: GPL-3.0-only

###########################
# Functions for devcli.sh #
###########################

die () {
    echo $* 1>&2
    exit 1
}

check_config () {
    [ -d "$DEVCLI_CONF_D" ] || die DEVCLI_CONF_D directory not found
    [ -d "$DEVCLI_ENVS" ] || die DEVCLI_ENVS directory not found
}

load_config () {
    for I in "$DEVCLI_CONF_D"/*.sh; do
        if [ -x "$I" ]; then
            source "$I"
        fi
    done
}

scan_envs () {
    for i in "$DEVCLI_ENVS"/*; do
        if [ -d "$i" ]; then
            ENVS+=($i)
        fi
    done
}

list_envs () {
    echo Environments available
    echo ----------------------
    for i in ${ENVS[@]}; do
        local conf_override="${i}/devcli-conf.sh"
        unset DESCRIPTION
        [ -x "$conf_override" ] && source $conf_override
        echo $(basename $i) : $DESCRIPTION
    done
    exit 0
}

in_array() {
    # https://raymii.org/s/snippets/Bash_Bits_Check_If_Item_Is_In_Array.html
    local haystack=${1}[@]
    local needle=${2}
    for i in ${!haystack}; do
        if [[ ${i} == ${needle} ]]; then
            return 0
        fi
    done
    return 1
}

build_image () {
    IMAGE=$1
    ENVPATH="${DEVCLI_ENVS}/$IMAGE"
    in_array ENVS "$ENVPATH" || die $ENVPATH not found
    local conf_override="${ENVPATH}/devcli-conf.sh"
    [ -x "$conf_override" ] && source $conf_override
    local imagename="${NAMESPACE}/${IMAGE}:${TAG}"
    local build_cmd=("${BUILD_CMD[@]}")
    build_cmd+=("$imagename")
    build_cmd+=(.)
    cd "${ENVPATH}" && ${build_cmd[@]}
    exit $?
}

run_image () {
    IMAGE=$1
    ENVPATH="${DEVCLI_ENVS}/$IMAGE"
    in_array ENVS "$ENVPATH" || die $ENVPATH not found
    local conf_override="${ENVPATH}/devcli-conf.sh"
    [ -x "$conf_override" ] && source $conf_override
    local imagename="${NAMESPACE}/${IMAGE}:${TAG}"
    local run_cmd=("${RUN_CMD[@]}")
    for i in ${MOUNTS[@]}; do
        run_cmd+=(-v)
        run_cmd+=(${i})
    done
    run_cmd+=("$imagename")
    run_cmd+=("$ENTRYPOINT")
    ${run_cmd[@]}
    exit $?
}

# vim: tabstop=4 shiftwidth=4 softtabstop=4 expandtab:
