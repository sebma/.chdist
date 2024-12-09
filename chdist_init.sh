#!/usr/bin/env bash

set -u
for distribNumber in $(LC_NUMERIC=C seq 14.04 2 24.04);do
	if ! [ -d $distribNumber ];then
		echo "= chdist create $distribNumber ..."
		chdist create $distribNumber
	fi
done

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

sed -i "/.chdist/ s|\".*/.chdist/|\"$HOME/.chdist/|" */etc/apt/apt.conf

find -maxdepth 1 -type l | egrep -v '^.$|^./.git$' | sed 's|^./||' | while read distribName;do
	if [ -s /etc/apt/sources.list.d/ubuntu.sources ];then
		mkdir -p ~/.chdist/$distribName/etc/apt/sources.list.d/
		cat /etc/apt/sources.list.d/ubuntu.sources | sed "s/$(\lsb_release -sc)/$distribName/" > ~/.chdist/$distribName/etc/apt/sources.list.d/ubuntu.sources
	else
		cat /etc/apt/sources.list | sed "s/$(\lsb_release -sc)/$distribName/" > ~/.chdist/$distribName/etc/apt/sources.list
	fi
done

proxyFile=$(grep Proxy /etc/apt/apt.conf.d/* -m1 -l)
if [ -n "$proxyFile" ] && [ -s "$proxyFile" ];then
	for distribNumber in $(LC_NUMERIC=C seq 14.04 2 24);do mkdir -p ~/.chdist/$distribNumber/etc/apt/apt.conf.d/ && cp -puv $proxyFile ~/.chdist/$distribNumber/etc/apt/apt.conf.d/;done
fi

#Creating $HOME/.chdist/%s/etc/apt/apt.conf.d/ dirs cf. http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=578446
mkdir -p -v $(printf "$HOME/.chdist/%s/etc/apt/apt.conf.d/ " $(LC_NUMERIC=C seq 14.04 2 24.04))
[ $(lsb_release -sr 2>/dev/null | cut -d. -f1) -ge 24 ] && mkdir -p -v $(printf "$HOME/.chdist/%s/etc/apt/preferences.d/ " $(LC_NUMERIC=C seq 14.04 2 24.04))
