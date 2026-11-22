#!/bin/sh
set -eu
/app/scripts/init.sh
exec "$@"
