#!/usr/bin/env bash

set -u
for distribNumber in $(LC_NUMERIC=C seq 14.04 2 24);do
	if ! [ -d $distribNumber ] && ! [ -L $distribNumber ];then
		echo "= chdist create $distribNumber ..."
		chdist create $distribNumber
#		distribName=""
#		ln -s $distribNumber $distribName
	fi
done
