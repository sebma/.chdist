#!/usr/bin/env bash

for distrib in precise trusty noble jammy bionic xenial focal
do
	if ! [ -d $distrib ] && ! [ -L $distrib ];then
		echo "= chdist create $distrib ..."
		chdist create $distrib
	fi
done
