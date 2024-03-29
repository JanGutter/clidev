#!/bin/bash
# Copyright 2019, Jan Gutter
# SPDX-License-Identifier: GPL-3.0-only

####################################################
# Global configs: point these to your environments #
####################################################

# Directory where the global configs reside
CLIDEV_CONF_D=${CLIDEV_CONF_D:-../clidev-conf/conf.d}

# Directory where the container environments reside
CLIDEV_ENVS=${CLIDEV_ENVS:-../clidev-conf/env}

# Defaults that can be overridden here or per environment config:

# Container build command
BUILD_CMD=${BUILD_CMD:-docker build -t}

# Container run command
RUN_CMD=${RUN_CMD:-docker run -it --rm}

# Namespace prefix for container images
NAMESPACE=${NAMESPACE:-"$USER"}

# Which tag to use
TAG=${TAG:-latest}

# Shell (or any other entrypoint)
ENTRYPOINT=${ENTRYPOINT:-/bin/bash -l}
