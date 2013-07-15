#!/bin/bash
echo "Launching debug PSGI app"
export CATALYST_DEBUG=1
export EVENTBOT_CONFIG=$PWD/eventbot.conf
export CATALYST_CONFIG=$PWD/eventbot.conf
export PERL5LIB="$PWD/lib:$PERL5LIB"
plackup --app eventbot.psgi --port 3000 --reload
