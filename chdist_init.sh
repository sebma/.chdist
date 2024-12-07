#!/usr/bin/env bash

set -u
for distrib in trusty xenial bionic focal jammy noble;do
	if ! [ -d $distrib ] && ! [ -L $distrib ];then
		echo "= chdist create $distrib ..."
		chdist create $distrib
#		distribNumber=""
#		ln -s $distrib $distribNumber
	fi
done
