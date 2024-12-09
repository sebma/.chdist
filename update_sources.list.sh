#!/usr/bin/env bash

find -maxdepth 1 -type l | egrep -v '^.$|^./.git$' | sed 's|^./||' | while read distrib;do
	cat /etc/apt/sources.list | sed "s/$(\lsb_release -sc)/$distrib/" | tee ~/.chdist/$distrib/etc/apt/sources.list >/dev/null
done
