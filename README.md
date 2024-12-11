# .chdist
`sources.list` file for some Linux Ubuntu distributions for the `chdist` tool.

To update one distrib apt lists, type this command :

`chdist apt-get $distribNumber update`

To update all the distribs apt lists, type this command :

`find -maxdepth 1 -type d | egrep -v '^.$|^./.git$' | sed 's|^./||' | while read distribNumber;do chdist apt-get $distribNumber update; done`
