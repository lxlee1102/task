#!/bin/sh

DOCKER_DIR=/open-falcon
of_bin=$DOCKER_DIR/open-falcon

m=$FALCON_MODULE
if [ ! -f $DOCKER_DIR/$m/config/cfg.json ]; then
	$DOCKER_DIR/$m/cfgmaker -i $DOCKER_DIR/$m/$m.tpl -o $DOCKER_DIR/$m/config/cfg.json
fi

if [ -z "$SYSLOG_SERVER_PORT" ] ; then
        SYSLOG_SERVER_PORT=514
fi

OPT=
if [ -n "$SYSLOG_SERVER_TCP" ] ; then
        OPT=--tcp
fi

if [ -z "$SYSLOG_SERVER_ADDR" ] ; then
        exec $DOCKER_DIR/$m/bin/falcon-$m -c $DOCKER_DIR/$m/config/cfg.json 2>&1
        exit 0
else
        exec $DOCKER_DIR/$m/bin/falcon-$m -c $DOCKER_DIR/$m/config/cfg.json 2>&1 | logger -st falcon-$m --server $SYSLOG_SERVER_ADDR $OPT --port $SYSLOG_SERVER_PORT
        exit 0
fi

#exec "$@"
