#!/usr/bin/env bash

# Clear The Old Environment Variables

sed -i '/# Set Rubick Environment Variable/,+1d' /home/vagrant/.profile
