#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1071,SC1091
#
CONTAINER_SPLASH_TEXT=$(echo "$1" | figlet -f slant -w 120 | sed -E "s/^/  /g")
COMMIT_SHA=$(echo "$CONTAINER_REPOSITORY_COMMIT_SHA" | cut -c -7)

echo -e "\e[34m\e[1m
\e[32m$CONTAINER_SPLASH_TEXT\e[93m

  Author:   ${CONTAINER_BUILD_AUTHOR:-}
  Reviewer: ${CONTAINER_BUILD_REVIEWER:-}
  Version:  ${CONTAINER_BUILD_VERSION:-undefined} @$COMMIT_SHA

  \e[34m
  Enjoy!
\e[0m"
