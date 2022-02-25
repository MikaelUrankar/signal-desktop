PORTNAME=	signal-desktop
DISTVERSIONPREFIX=	v
DISTVERSION=	5.32.0
CATEGORIES=	net-im
MASTER_SITES=	https://cocyte.westeurope.cloudapp.azure.com/signal-desktop/:yarn \
		https://cocyte.westeurope.cloudapp.azure.com/signal-desktop/:electron_gyp \
		https://cocyte.westeurope.cloudapp.azure.com/signal-desktop/:npm \
		https://cocyte.westeurope.cloudapp.azure.com/signal-desktop/:sqlite
DISTFILES=	signal-desktop-${DISTVERSION}-yarn-cache.tar.gz:yarn \
		signal-desktop-${DISTVERSION}-electron-gyp-cache.tar.gz:electron_gyp \
		signal-desktop-${DISTVERSION}-npm-cache.tar.gz:npm \
		sqlite3.tar.gz:sqlite

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Cross-platform centralized encrypted messaging service

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

USES=		desktop-file-utils
USE_GITHUB=	yes
GH_ACCOUNT=	signalapp

USE_GL=		gbm gl
USE_GNOME=	atk cairo gdkpixbuf2 glib20 gtk30 libxml2 libxslt pango
USE_XORG=	x11 xcb xcomposite xdamage xext xfixes xi xrandr xrender xtst gettext-runtime jpeg

WRKSRC=		${WRKDIR}/Signal-Desktop-${DISTVERSION}${DISTVERSIONSUFFIX}

PACKAGE_ENV=	SIGNAL_ENV=production
MAKE_ENV+=	ELECTRON_OVERRIDE_DIST_PATH=${LOCALBASE}/share/electron16 \
		HOME=${WRKDIR} \
		PLAYWRIGHT_BROWSERS_PATH=${WRKDIR}/.cache \
		PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=true \
		PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true \
		USE_SYSTEM_APP_BUILDER=true \
		XDG_CACHE_HOME=${WRKDIR}/.cache

# Don't download electron binary distribution on electron node_modules installation
MAKE_ENV+=	ELECTRON_SKIP_BINARY_DOWNLOAD=1

_BUILD_DATE=	$$(date +'%s')

post-patch:
	${REINPLACE_CMD} "s#%%EPOCH%%#${_BUILD_DATE}#" \
		${WRKSRC}/ts/scripts/get-expire-time.ts

do-build:
	# Replace these 2 binaries with their native one
	${CP} ${PREFIX}/lib/libsignal_node.so \
 		${WRKDIR}/.cache/yarn/v6/npm-@signalapp-signal-client-0.11.1-f1f859453c2d187e5f47ab02707ae4580edaa6fc-integrity/node_modules/@signalapp/signal-client/prebuilds/freebsd-x64/node.napi.node
	${CP} ${PREFIX}/lib/libringrtc.so \
		${WRKDIR}/.cache/yarn/v6/npm-ringrtc-2.18.0-561484a82f75f64391da5ce9f48217db30e9ba4b/node_modules/ringrtc/build/freebsd/libringrtc-x64.node

	# sqlite3.tar.gz requires git-lfs to fetch, just copy a previously downloaded one
	${CP} ${DISTDIR}/sqlite3.tar.gz \
	       ${WRKDIR}/.cache/yarn/v6/./npm-better-sqlite3-7.1.4-92ed9e36351577fe007d139fbd7b4f3e797a8454/node_modules/better-sqlite3/deps/sqlite3.tar.gz

	# patch-package can't patch playwright-core
	${CP} ${FILESDIR}/playwrigth-registry.js \
	 	${WRKDIR}/.cache/yarn/v6/npm-playwright-core-1.17.1-a16e0f89284a0ed8ae6d77e1c905c84b8a2ba022-integrity/node_modules/playwright-core/lib/utils/registry.js

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
			--linux --dir  --config.npmRebuild=false \
			--config.electronVersion=16 \
			--config.electronDist=${LOCALBASE}/share/electron16

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
