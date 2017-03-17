#!/usr/bin/env bash

ps auxw | grep -v grep > /dev/null

if [ $? != 0 ]
then
    service nginx stop > /dev/null
    echo 'nginx stopped'
else
    service nginx start > /dev/null
    echo 'nginx started'
fi
