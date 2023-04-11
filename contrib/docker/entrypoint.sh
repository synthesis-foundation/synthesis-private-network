#!/usr/bin/env sh

set -e

CONF_DIR="/etc/synthesis-network"

if [ ! -f "$CONF_DIR/config.conf" ]; then
  echo "generate $CONF_DIR/config.conf"
  synthesis --genconf > "$CONF_DIR/config.conf"
fi

synthesis --useconf < "$CONF_DIR/config.conf"
exit $?
