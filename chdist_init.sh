#!/usr/bin/env bash

set -u

seq="env LC_NUMERIC=C seq"
distribVersionList=$($seq 14.04 2 $(($(lsb_release -sr 2>/dev/null | cut -d. -f1)-2)).04)

for distribNumber in $distribVersionList;do
	if ! [ -d $distribNumber ];then
		echo "=> chdist create $distribNumber ..."
		chdist create $distribNumber 2>&1 | grep -v "deprecated"
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

mkdir -p -v $(printf "$HOME/.chdist/%s/etc/apt/ " $distribVersionList)

#sed -i "/.chdist/ s|\".*/.chdist/|\"$HOME/.chdist/|" */etc/apt/apt.conf

majorVersion=$(lsb_release -sr | cut -d. -f1)
arch=$(dpkg --print-architecture)

nobleMajorVersion=24
if [ $majorVersion -ge $nobleMajorVersion ];then
	find -maxdepth 1 -type l | egrep -v '^.$|^./.git$' | sed 's|^./||' | while read distribName;do
		distribNumber=$(readlink $distribName | cut -d. -f1)
		if [ $distribNumber -ge $nobleMajorVersion ];then
			test -d ~/.chdist/$distribName/etc/apt/sources.list.d/ || mkdir -pv ~/.chdist/$distribName/etc/apt/sources.list.d/
			cat /etc/apt/sources.list.d/ubuntu.sources | sed "s/$(\lsb_release -sc)/$distribName/" > ~/.chdist/$distribName/etc/apt/sources.list.d/ubuntu.sources
		else
			cat <<EOF > ~/.chdist/$distribName/etc/apt/sources.list
deb [arch=$arch] http://fr.archive.ubuntu.com/ubuntu/ $distribName main universe restricted multiverse
# deb-src [arch=$arch] http://fr.archive.ubuntu.com/ubuntu/ $distribName main universe restricted multiverse
deb [arch=$arch] http://fr.archive.ubuntu.com/ubuntu/ $distribName-updates multiverse universe main restricted
# deb-src [arch=$arch] http://fr.archive.ubuntu.com/ubuntu/ $distribName-updates multiverse universe main restricted
deb [arch=$arch] http://fr.archive.ubuntu.com/ubuntu/ $distribName-backports multiverse universe main restricted
# deb-src [arch=$arch] http://fr.archive.ubuntu.com/ubuntu/ $distribName-backports multiverse universe main restricted
deb [arch=$arch] http://fr.archive.ubuntu.com/ubuntu/ $distribName-security multiverse universe main restricted
# deb-src [arch=$arch] http://fr.archive.ubuntu.com/ubuntu/ $distribName-security multiverse universe main restricted
EOF
		fi
	done
else
	find -maxdepth 1 -type l | egrep -v '^.$|^./.git$' | sed 's|^./||' | while read distribName;do
		cat /etc/apt/sources.list | sed "s/$(\lsb_release -sc)/$distribName/" > ~/.chdist/$distribName/etc/apt/sources.list
	done
fi

proxyFile=$(grep Proxy /etc/apt/apt.conf.d/* -m1 -l)
if [ -n "$proxyFile" ] && [ -s "$proxyFile" ];then
	for distribNumber in $distribVersionList;do
		mkdir -p ~/.chdist/$distribNumber/etc/apt/apt.conf.d/ && cp -puv $proxyFile ~/.chdist/$distribNumber/etc/apt/apt.conf.d/
	done
fi

#Creating $HOME/.chdist/%s/etc/apt/apt.conf.d/ dirs cf. http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=578446
mkdir -p -v $(printf "$HOME/.chdist/%s/etc/apt/apt.conf.d/ " $distribVersionList)
mkdir -p -v $(printf "$HOME/.chdist/%s/etc/apt/preferences.d/ " $distribVersionList)

for distribNumber in $distribVersionList;do
	if [ -f $distribNumber/etc/apt/apt.conf ];then
		echo "=> chdist apt $distribNumber update ..."
		chdist apt $distribNumber update 2>&1 | grep -v "deprecated"
	fi
done
