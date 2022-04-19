rm -rf work/.npm/_logs/ work/.npm/_update-notifier-last-checked
rm -rf work/.cache/yarn/v6/.tmp

find work/.cache  -type f -perm 755 -exec file {} \; | egrep "ELF|PE32+|Mach-O" |awk -F ':' '{print $1}' | xargs rm

cd work

tar czf ../signal-desktop-5.39.0-yarn-cache.tar.gz .cache yarn-cache
tar czf ../signal-desktop-5.39.0-electron-gyp-cache.tar.gz .electron-gyp
tar czf ../signal-desktop-5.39.0-npm-cache.tar.gz .npm
