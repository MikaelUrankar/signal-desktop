cd /usr/local/poudriere/ports/default/multimedia/ringrtc

cp -f /root/signal-desktop.git/ports/multimedia/ringrtc/Makefile* .
cp -f /root/signal-desktop.git/ports/multimedia/ringrtc/distinfo .
cp -f /root/signal-desktop.git/ports/multimedia/ringrtc/webrtc_fetch.sh .

diff -drup /root/signal-desktop.git/ports/multimedia/ringrtc /usr/local/poudriere/ports/default/multimedia/ringrtc

***************************************************************************************************************************

cd /usr/local/poudriere/ports/default/net-im/libsignal-node

cp -f /root/signal-desktop.git/ports/net-im/libsignal-node/Makefile* .
cp -f /root/signal-desktop.git/ports/net-im/libsignal-node/distinfo .

diff -drup /root/signal-desktop.git/ports/net-im/libsignal-node /usr/local/poudriere/ports/default/net-im/libsignal-node

***************************************************************************************************************************

cd /usr/local/poudriere/ports/default/net-im/signal-desktop

cp -f /root/signal-desktop.git/ports/net-im/signal-desktop/Makefile* .
cp -f /root/signal-desktop.git/ports/net-im/signal-desktop/distinfo .
cp -f /root/signal-desktop.git/ports/net-im/signal-desktop/get_deps.sh .
cp -f /root/signal-desktop.git/ports/net-im/signal-desktop/files/patch-package.json files
cp -f /root/signal-desktop.git/ports/net-im/signal-desktop/files/pnpm-lock.yaml files
cp -f /root/signal-desktop.git/ports/net-im/signal-desktop/files/package-lock.json files

diff -drup /root/signal-desktop.git/ports/net-im/signal-desktop /usr/local/poudriere/ports/default/net-im/signal-desktop

***************************************************************************************************************************

cd /usr/local/poudriere/ports/default/security/node-sqlcipher

cp -f /root/signal-desktop.git/ports/security/node-sqlcipher/Makefile* .
cp -f /root/signal-desktop.git/ports/security/node-sqlcipher/distinfo .

diff -drup /root/signal-desktop.git/ports/security/node-sqlcipher /usr/local/poudriere/ports/default/security/node-sqlcipher

***************************************************************************************************************************

cd /usr/local/poudriere/ports/default/devel/signal-sqlcipher-extension

cp -f /root/signal-desktop.git/ports/devel/signal-sqlcipher-extension/Makefile* .
cp -f /root/signal-desktop.git/ports/devel/signal-sqlcipher-extension/distinfo .

diff -drup /root/signal-desktop.git/ports/devel/signal-sqlcipher-extension /usr/local/poudriere/ports/default/devel/signal-sqlcipher-extension
