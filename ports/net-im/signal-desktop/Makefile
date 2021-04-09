PORTNAME=	signal-desktop
PORTVERSION=	1.40.1
DISTVERSIONPREFIX=	v
CATEGORIES=	net-im
MASTER_SITES=	http://mikael.urankar.free.fr/signal-desktop/:yarn
DISTFILES=	signal-desktop-yarn-cache.tar.gz:yarn

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	signal-desktop

LICENSE=	AGPLv3
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	node12>0:www/node12 \
		npm-node12>0:www/npm-node12 \
		yarn-node12>0:www/yarn-node12 \
		electron11:devel/electron11 \
		zkgroup>0:net-im/zkgroup \
		app-builder>0:devel/app-builder \
		vips>0:graphics/vips \
		zip>0:archivers/zip \
		${LOCALBASE}/lib/libsignal_node.so:net-im/libsignal-client-node \
		${LOCALBASE}/lib/libringrtc.so:multimedia/ringrtc \
		openssl>0:security/openssl

USES=		python:2.7,build
USE_GITHUB=	yes
GH_ACCOUNT=	signalapp

WRKSRC=		${WRKDIR}/Signal-Desktop-${PORTVERSION}

MAKE_ENV+=	ELECTRON_SKIP_BINARY_DOWNLOAD=true \
		USE_SYSTEM_APP_BUILDER=true \
		HOME=${WRKDIR} \
		XDG_CACHE_HOME=${WRKDIR}/.cache

BINARY_ALIAS=	python=python2.7

pre-build:
# set up yarn to use offline mode
	${ECHO_CMD} 'yarn-offline-mirror "../yarn-offline-cache"' > ${WRKSRC}/.yarnrc

	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/package.json.patch || true

	# setup download cache for electron and chromedriver
	${MKDIR} ${WRKDIR}/.cache/electron/
	cd ${LOCALBASE}/share/electron11 && \
		zip -q -r ${WRKDIR}/.cache/electron/electron-v11.2.3-freebsd-x64.zip .
	cd ${LOCALBASE}/share/electron11 && \
		zip -q -r ${WRKDIR}/.cache/electron/chromedriver-v3.0.0-freebsd-x64.zip chromedriver
	cd ${WRKDIR}/.cache/electron && \
		${SHA256} -r *.zip | \
		${SED} -e 's/ / */' > SHASUMS256.txt-3.0.0

# install node_modules without executing post-installation scripts
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn --frozen-lockfile --offline --ignore-scripts

#	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_app-builder-lib.patch || true
#	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_electron_index.js.patch || true
#	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_electron-builder_out_cli_install-app-deps.js.patch || true
#	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_journeyapps_sqlcipher_deps_extract.py.patch || true
#	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_journeyapps_sqlcipher_deps_sqlite3.gyp.patch || true

do-build:
	# don't know why but the first yarn incantation fails
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn --frozen-lockfile --offline || ${TRUE}

	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_app-builder-lib.patch || true
	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_electron_index.js.patch || true
	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_electron-builder_out_cli_install-app-deps.js.patch || true
	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_journeyapps_sqlcipher_deps_extract.py.patch || true
	${PATCH} -f -s -d ${WRKSRC} -i ${FILESDIR}/node__modules_journeyapps_sqlcipher_deps_sqlite3.gyp.patch || true

	${RM} -r ${WRKSRC}/node_modules/@journeyapps/sqlcipher/build-tmp-napi-v6
	${RM} ${WRKSRC}/node_modules/@journeyapps/sqlcipher/lib/binding/napi-v6-freebsd-x64/node_sqlite3.node

	# don't know why but the first yarn incantation fails, do it again
	# maybe https://github.com/freebsd/freebsd-ports/blob/main/devel/electron11/Makefile#L171
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn --frozen-lockfile --offline

	${MKDIR} ${WRKSRC}/node_modules/ringrtc/build/freebsd
	${CP} /usr/local/lib/libringrtc.so ${WRKSRC}/node_modules/ringrtc/build/freebsd/libringrtc.node
	${CP} /usr/local/lib/libsignal_node.so ${WRKSRC}/node_modules/libsignal-client/build/libsignal_client_freebsd.node
	${CP} /usr/local/lib/libzkgroup.so ${WRKSRC}/node_modules/zkgroup

	cd ${WRKSRC} && \
		yarn grunt
	cd ${WRKSRC} && \
		yarn build:webpack

# from https://github.com/freebsd/freebsd-ports/blob/main/editors/vscode/Makefile#L242
# ### targets for port maintainer(s)
# make-yarn-cache:
# 	# do "make configure" before executing this target
# 	${RM} -r ${WRKDIR}/yarn-offline-cache
# 	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
# 		yarn --frozen-lockfile --ignore-scripts
# 	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
# 		yarn postinstall --frozen-lockfile
# 	cd ${WRKDIR} && ${TAR} -czf \
# 		yarn-offline-cache-${DISTVERSION}${EXTRACT_SUFX} yarn-offline-cache

.include <bsd.port.mk>
