# .chdist
`sources.list` file for some Linux Ubuntu distributions for the `chdist` tool.

To update one distrib apt lists, type this command :

`chdist apt-get $distribNumber update`

To update all the distribs apt lists, type this command :

```shell
find . -maxdepth 1 -path ./.git -prune -o -type d -print | sed 's|^./||' | while read distribNumber;do chdist apt-get $distribNumber update; done
find . -maxdepth 1 -path ./.git -prune -o -type d -print | sed 's|^./||' | while read distribNumber;do chdist apt-file $distribNumber update; done
```
