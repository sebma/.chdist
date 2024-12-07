#!/usr/bin/env bash

sed -i "/.chdist/ s|\".*/.chdist/|\"$HOME/.chdist/|" */etc/apt/apt.conf
