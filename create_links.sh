#!/usr/bin/env bash

find -maxdepth 1 -type d | egrep -v '^.$|^./.git$' | sed 's|^./||' | while read distribNumber;do
	case $distribNumber in
		14.04) test -L trusty || ln -vs 14.04 trusty;continue;;
		16.04) test -L xenial || ln -vs 16.04 xenial;continue;;
		18.04) test -L bionic || ln -vs 18.04 bionic;continue;;
		20.04) test -L focal  || ln -vs 20.04 focal;continue;;
		22.04) test -L jammy  || ln -vs 22.04 jammy;continue;;
		24.04) test -L noble  || ln -vs 24.04 noble;continue;;
	esac
done