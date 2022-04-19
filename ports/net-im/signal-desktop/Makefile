PORTNAME=	signal-desktop
DISTVERSIONPREFIX=	v
DISTVERSION=	5.39.0
CATEGORIES=	net-im
MASTER_SITES=	https://cocyte.westeurope.cloudapp.azure.com/signal-desktop/:yarn \
		https://cocyte.westeurope.cloudapp.azure.com/signal-desktop/:electron_gyp \
		https://cocyte.westeurope.cloudapp.azure.com/signal-desktop/:npm \
		https://cocyte.westeurope.cloudapp.azure.com/signal-desktop/:sqlite
DISTFILES=	signal-desktop-${DISTVERSION}-yarn-cache.tar.gz:yarn \
		signal-desktop-${DISTVERSION}-electron-gyp-cache.tar.gz:electron_gyp \
		signal-desktop-${DISTVERSION}-npm-cache.tar.gz:npm \
		sqlcipher.tar.gz:sqlite

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Cross-platform centralized encrypted messaging service

BROKEN=		fails to run: requires electron17: https://github.com/signalapp/Signal-Desktop/commit/f7c3a44056229a4206d814de72befab4b5ca07c7

LICENSE=	AGPLv3
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	${LOCALBASE}/lib/libringrtc.so:multimedia/ringrtc \
		${LOCALBASE}/lib/libsignal_node.so:net-im/libsignal-client-node \
		app-builder>0:devel/app-builder \
		electron16:devel/electron16 \
		npm:www/npm-node16 \
		openssl>0:security/openssl \
		vips>0:graphics/vips \
		yarn:www/yarn-node16
LIB_DEPENDS=	libasound.so:audio/alsa-lib \
		libatk-bridge-2.0.so:accessibility/at-spi2-atk \
		libatspi.so:accessibility/at-spi2-core \
		libcups.so:print/cups \
		libdbus-1.so:devel/dbus \
		libdrm.so:graphics/libdrm \
		libexpat.so:textproc/expat2 \
		libFLAC.so:audio/flac \
		libfontconfig.so:x11-fonts/fontconfig \
		libharfbuzz-subset.so:print/harfbuzz \
		libharfbuzz.so:print/harfbuzz \
		libnspr4.so:devel/nspr \
		libnss3.so:security/nss \
		libnssutil3.so:security/nss \
		libopenh264.so:multimedia/openh264 \
		libopus.so:audio/opus \
		libpci.so:devel/libpci \
		libplc4.so:devel/nspr \
		libplds4.so:devel/nspr \
		libpng16.so:graphics/png \
		libsmime3.so:security/nss \
		libsnappy.so:archivers/snappy \
		libwebp.so:graphics/webp \
		libwebpdemux.so:graphics/webp \
		libwebpmux.so:graphics/webp \
		libxkbcommon.so:x11/libxkbcommon \
		libxshmfence.so:x11/libxshmfence

USES=		desktop-file-utils jpeg gettext-runtime gl gnome xorg
USE_GITHUB=	yes
GH_ACCOUNT=	signalapp
GH_PROJECT=	Signal-Desktop

USE_GL=		gbm gl
USE_GNOME=	atk cairo gdkpixbuf2 glib20 gtk30 libxml2 libxslt pango
USE_XORG=	x11 xcb xcomposite xdamage xext xfixes xi xrandr xrender xtst

PACKAGE_ENV=	SIGNAL_ENV=production
MAKE_ENV+=	ELECTRON_OVERRIDE_DIST_PATH=${LOCALBASE}/share/electron16 \
		HOME=${WRKDIR} \
		PLAYWRIGHT_BROWSERS_PATH=${WRKDIR}/.cache \
		PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=true \
		PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true \
		USE_SYSTEM_APP_BUILDER=true \

TMPDIR=		/tmp

# Don't download electron binary distribution on electron node_modules installation
MAKE_ENV+=	ELECTRON_SKIP_BINARY_DOWNLOAD=1

# Don't create __pycache__ directory when executing node-gyp
# This is a workaround to avoid filesystem violations during poudriere build
MAKE_ENV+=	PYTHONDONTWRITEBYTECODE=1

_BUILD_DATE=	$$(date +'%s')

NPM_SIGNAL_DIR=		npm-@signalapp-libsignal-client-0.15.0-e35c949e390d76497acad7ac8b033a68899ae11e-integrity
NPM_RINGRTC_DIR=	npm-ringrtc-2.20.1-0464fe30a74b0617c976b66528c9a033fa80ad38
NPM_SQLITE3_DIR=	npm-better-sqlite3-7.5.0-3c4a7eebba3d5f5d8cb88fe83be1c01b8c0dea7d
NPM_PLAYWRITE_DIR=	npm-playwright-core-1.17.1-a16e0f89284a0ed8ae6d77e1c905c84b8a2ba022-integrity
NPM_ESBUILD_VERS=	0.14.28
NPM_ESBUILD_DIR=	npm-esbuild-${NPM_ESBUILD_VERS}-7738635d2ea19e446bd319d83a1802545e6aebb8-integrity

post-patch:
	${REINPLACE_CMD} "s#%%EPOCH%%#${_BUILD_DATE}#" \
		${WRKSRC}/ts/scripts/get-expire-time.ts

do-build:
	${ECHO} 'yarn-offline-mirror "../yarn-cache"' > ${WRKSRC}/.yarnrc

# electron-builder is stupid and tries to open ${LOCALBASE}/share/electron16/electron with WRITE priv
# copy ${LOCALBASE}/share/electron16 in WRKDIR
# it's needed for the do-install phase, it's here because of this issue
# https://github.com/MikaelUrankar/signal-desktop/issues/6 (I don't know why it fails though)
	@${CP} -pR ${LOCALBASE}/share/electron16 ${WRKDIR}/electron16
	${CHMOD} -R a+w ${WRKDIR}/electron16

	# Replace these 2 binaries with their native one
	${MKDIR} ${WRKDIR}/.cache/yarn/v6/${NPM_SIGNAL_DIR}/node_modules/@signalapp/libsignal-client/prebuilds/freebsd-x64 \
		 ${WRKDIR}/.cache/yarn/v6/${NPM_RINGRTC_DIR}/node_modules/ringrtc/build/freebsd

	${CP} ${LOCALBASE}/lib/libsignal_node.so \
		${WRKDIR}/.cache/yarn/v6/${NPM_SIGNAL_DIR}/node_modules/@signalapp/libsignal-client/prebuilds/freebsd-x64/node.napi.node
	${CP} ${LOCALBASE}/lib/libringrtc.so \
		${WRKDIR}/.cache/yarn/v6/${NPM_RINGRTC_DIR}/node_modules/ringrtc/build/freebsd/libringrtc-x64.node

	# sqlcipher.tar.gz requires git-lfs to fetch, just copy a previously downloaded one (I have to use ubuntu for that,
	# as I didn't manage to do it with FreeBSD, see https://github.com/signalapp/Signal-Desktop/blob/development/CONTRIBUTING.md for instructions)
	mkdir -p ${WRKDIR}/.cache/yarn/v6/${NPM_SQLITE3_DIR}/node_modules/better-sqlite3/deps
	${CP} ${DISTDIR}/sqlcipher.tar.gz \
		${WRKDIR}/.cache/yarn/v6/${NPM_SQLITE3_DIR}/node_modules/better-sqlite3/deps/sqlcipher.tar.gz

	# patch-package can't patch playwright-core
	${CP} ${FILESDIR}/playwrigth-registry.js \
	 	${WRKDIR}/.cache/yarn/v6/${NPM_PLAYWRITE_DIR}/node_modules/playwright-core/lib/utils/registry.js

	# npm sucks
	# also, patch .cache/yarn/v6/npm-esbuild-0.14.3-38db1d26aaeccc43f478225974538e2c4de9d6b1-integrity/node_modules/esbuild/install.js
	# (downloadDirectlyFromNPM) to not throw an error
	# XXX arch
	${TAR} -xf ${WRKDIR}/yarn-cache/esbuild-freebsd-64-${NPM_ESBUILD_VERS}.tgz -C ${TMPDIR}
	${CP} ${TMPDIR}/package/bin/esbuild \
		${WRKDIR}/.cache/yarn/v6/${NPM_ESBUILD_DIR}/node_modules/esbuild/lib/downloaded-esbuild-freebsd-64-esbuild

# 	# Uncomment for online build
#	${RM} ${WRKDIR}/.npmrc
#	cd ${WRKSRC} && \
#		${SETENV} ${MAKE_ENV} yarn install --frozen-lockfile --ignore-optional
#	cd ${WRKSRC} && \
#		${SETENV} ${MAKE_ENV} yarn generate
#	cd ${WRKSRC} && \
#		${SETENV} ${MAKE_ENV} yarn build:webpack

 	# Uncomment for offline build
	${ECHO} offline=true > ${WRKDIR}/.npmrc
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn install --frozen-lockfile --ignore-optional --offline
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn --offline generate
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn --offline build:webpack

do-install:
# taken from https://github.com/tagattie/FreeBSD-Electron/blob/master/Mk/Uses/electron.mk#L387
# and editors/vscode
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} ${PACKAGE_ENV} yarn run electron-builder \
			--linux --dir --config.npmRebuild=false \
			--config.electronVersion=16 \
			--config.electronDist=${WRKDIR}/electron16

	${MKDIR} ${STAGEDIR}${DATADIR}
	cd ${BUILD_WRKSRC}/dist/linux-unpacked && \
		${COPYTREE_SHARE} . ${STAGEDIR}${DATADIR}

	${MKDIR} ${STAGEDIR}${PREFIX}/share/pixmaps
	${INSTALL_DATA} ${WRKSRC}/images/signal-logo-desktop-linux.png \
		${STAGEDIR}${PREFIX}/share/pixmaps/signal-desktop.png
	${INSTALL_DATA} ${FILESDIR}/${PORTNAME}.desktop \
		${STAGEDIR}${PREFIX}/share/applications

.for f in chromedriver mksnapshot v8_context_snapshot_generator
	${RM} ${STAGEDIR}${DATADIR}/${f}
.endfor
	${RM} -r ${STAGEDIR}${DATADIR}/gen
	${RM} -r ${STAGEDIR}${DATADIR}/node_headers
	${RM} -r ${STAGEDIR}${DATADIR}/resources/completions
	${RLN} ${STAGEDIR}${DATADIR}/signal-desktop ${STAGEDIR}${PREFIX}/bin

.include <bsd.port.mk>
