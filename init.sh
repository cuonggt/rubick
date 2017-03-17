#!/usr/bin/env bash

if [[ -n "$1" ]]; then
    cp -i resources/Rubick.json Rubick.json
else
    cp -i resources/Rubick.yaml Rubick.yaml
fi

cp -i resources/after.sh after.sh
cp -i resources/aliases aliases

echo "Rubick initialized!"
