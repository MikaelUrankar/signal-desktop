rm -rf work/.cache/yarn/v6/.tmp

find work/.cache  -type f -perm 755 -exec file {} \; | egrep "ELF|PE32+|Mach-O" |awk -F ':' '{print $1}' | xargs rm

cd work

tar czf ../libsignal-node-0.15.0-yarn-cache.tar.gz .cache yarn-cache
