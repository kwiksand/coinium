#!/bin/sh
set -e
cd /home/coinium/CoiniumServ/bin/Release

echo
exec gosu coinium /usr/bin/mono ./CoiniumServ.exe "$@"
