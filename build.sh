#!/bin/sh

if [ -n "$1" ] ; then
    tag=":$1"
fi

docker build -t somax/rethinkdb-backup$tag .