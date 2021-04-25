PORTNAME=	signal-desktop
PORTVERSION=	1.40.1
DISTVERSIONPREFIX=	v
CATEGORIES=	net-im
MASTER_SITES=	http://mikael.urankar.free.fr/signal-desktop/:yarn
DISTFILES=	signal-desktop-yarn-modules-1.40.1.tar.gz:yarn

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Cross-platform centralized encrypted messaging service

LICENSE=	AGPLv3
LICENSE_FILE=	${WRKSRC}/LICENSE

BUILD_DEPENDS=	${LOCALBASE}/lib/libringrtc.so:multimedia/ringrtc \
		${LOCALBASE}/lib/libsignal_node.so:net-im/libsignal-client-node \
		app-builder>0:devel/app-builder \
		electron11:devel/electron11 \
		node12>0:www/node12 \
		npm-node12>0:www/npm-node12 \
		openssl>0:security/openssl \
		vips>0:graphics/vips \
		yarn-node12>0:www/yarn-node12 \
		zip>0:archivers/zip \
		zkgroup>0:net-im/zkgroup

# XXX try to update node-gyp and drop python2.7 dep
USES=		desktop-file-utils python:2.7,build
USE_GITHUB=	yes
GH_ACCOUNT=	signalapp

WRKSRC=		${WRKDIR}/Signal-Desktop-${PORTVERSION}

MAKE_ENV+=	ELECTRON_SKIP_BINARY_DOWNLOAD=true \
		HOME=${WRKDIR} \
		SIGNAL_ENV=production \
		USE_SYSTEM_7ZA=true \
		USE_SYSTEM_APP_BUILDER=true \
		XDG_CACHE_HOME=${WRKDIR}/.cache

BINARY_ALIAS=	python=python2.7

# Taken from https://github.com/tagattie/FreeBSD-Electron
# XXX convert to Taggatie's framework
PREFETCH_TIMESTAMP=	1616313125
PKGJSONSDIR=		${FILESDIR}/packagejsons
YARN_CMD=		${LOCALBASE}/bin/${_YARN_BASE_CMD}
_YARN_BASE_CMD=		yarn

pre-fetch:
	@if [ ! -f ${DISTDIR}/${PORTNAME}-yarn-modules-${DISTVERSION}${EXTRACT_SUFX} ]; then \
		${ECHO_MSG} "===>  Pre-fetching and archiving node modules"; \
		${MKDIR} ${WRKDIR}; \
		${ECHO_CMD} 'yarn-offline-mirror "./yarn-offline-cache"' >> \
			${WRKDIR}/.yarnrc; \
		${CP} -r ${PKGJSONSDIR}/* ${WRKDIR}; \
		cd ${PKGJSONSDIR} && \
		for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
			cd ${WRKDIR}/$${dir} && \
			${SETENV} HOME=${WRKDIR} XDG_CACHE_HOME=${WRKDIR}/.cache \
				${YARN_CMD} --frozen-lockfile --ignore-scripts && \
			${RM} package.json yarn.lock; \
		done; \
		cd ${WRKDIR}; \
		${MTREE_CMD} -cbnSp yarn-offline-cache | ${MTREE_CMD} -C | ${SED} \
			-e 's:time=[0-9.]*:time=${PREFETCH_TIMESTAMP}.000000000:' \
			-e 's:\([gu]id\)=[0-9]*:\1=0:g' \
			-e 's:flags=.*:flags=none:' \
			-e 's:^\.:./yarn-offline-cache:' > yarn-offline-cache.mtree; \
		${TAR} -cz --options 'gzip:!timestamp' \
			-f ${DISTDIR}/${PORTNAME}-yarn-modules-${DISTVERSION}${EXTRACT_SUFX} @yarn-offline-cache.mtree; \
		${RM} -r ${WRKDIR}; \
	fi

pre-build:
	@${ECHO_MSG} "===>  Copying package.json and yarn.lock to WRKSRC"
	@cd ${PKGJSONSDIR} && \
	for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
		for f in package.json yarn.lock; do \
	 		if [ -f ${WRKSRC}/$${dir}/$${f} ]; then \
				${MV} -f ${WRKSRC}/$${dir}/$${f} ${WRKSRC}/$${dir}/$${f}.bak; \
			fi; \
			${CP} -f $${dir}/$${f} ${WRKSRC}/$${dir}; \
		done; \
	done

	@${ECHO_MSG} "===>  Setting up download cache for electron and chromedriver"
	${MKDIR} ${WRKDIR}/.cache/electron/
	cd ${LOCALBASE}/share/electron11 && \
		zip -q -r ${WRKDIR}/.cache/electron/electron-v11.2.3-freebsd-x64.zip .
	cd ${LOCALBASE}/share/electron11 && \
		zip -q -r ${WRKDIR}/.cache/electron/chromedriver-v3.0.0-freebsd-x64.zip chromedriver
	cd ${WRKDIR}/.cache/electron && \
		${SHA256} -r *.zip | \
		${SED} -e 's/ / */' > SHASUMS256.txt-3.0.0

	@${ECHO_MSG} "===>  Installing node modules from pre-fetched cache"
	@${ECHO_CMD} 'yarn-offline-mirror "../yarn-offline-cache"' >> ${WRKSRC}/.yarnrc
	@cd ${PKGJSONSDIR} && \
	for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
		cd ${WRKSRC}/$${dir} && ${SETENV} HOME=${WRKDIR} XDG_CACHE_HOME=${WRKDIR}/.cache \
			${YARN_CMD} --frozen-lockfile --ignore-scripts --offline; \
	done

do-build:
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn --frozen-lockfile --offline || ${TRUE}

	${MKDIR} ${WRKSRC}/node_modules/ringrtc/build/freebsd
	${CP} ${PREFIX}/lib/libringrtc.so ${WRKSRC}/node_modules/ringrtc/build/freebsd/libringrtc.node
	${CP} ${PREFIX}/lib/libsignal_node.so ${WRKSRC}/node_modules/libsignal-client/build/libsignal_client_freebsd.node
	${CP} ${PREFIX}/lib/libzkgroup.so ${WRKSRC}/node_modules/zkgroup

	cd ${WRKSRC} && \
		yarn grunt
	cd ${WRKSRC} && \
		yarn build:webpack

do-install:
	# taken from https://github.com/tagattie/FreeBSD-Electron/blob/master/Mk/Uses/electron.mk#L387
	# and editors/vscode
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn run electron-builder \
			--linux --dir  --config.npmRebuild=false \
			--config.electronVersion=11.2.3 \
			--config.electronDist=${LOCALBASE}/share/electron11

	${MKDIR} ${STAGEDIR}${DATADIR}
	cd ${BUILD_WRKSRC}/dist/linux-unpacked && \
		${COPYTREE_SHARE} . ${STAGEDIR}${DATADIR}

	${MKDIR} ${STAGEDIR}${PREFIX}/share/pixmaps
	${INSTALL_DATA} ${WRKSRC}/images/signal-logo-desktop-linux.png \
		${STAGEDIR}${PREFIX}/share/pixmaps/signal-desktop.png
	${INSTALL_DATA} ${FILESDIR}/${PORTNAME}.desktop \
		${STAGEDIR}${PREFIX}/share/applications

	cd ${STAGEDIR}${DATADIR}/resources/app.asar.unpacked && \
		${FIND} . -type f -name '*.node' -exec ${STRIP_CMD} {} ';'
.for f in chromedriver mksnapshot v8_context_snapshot_generator
	${RM} ${STAGEDIR}${DATADIR}/${f}
.endfor
	${RM} -r ${STAGEDIR}${DATADIR}/gen
	${RM} -r ${STAGEDIR}${DATADIR}/node_headers
	${RM} -r ${STAGEDIR}${DATADIR}/resources/completions
	${RLN} ${STAGEDIR}${DATADIR}/signal-desktop ${STAGEDIR}${PREFIX}/bin
	${CHMOD} a+x ${STAGEDIR}${DATADIR}/signal-desktop

.include <bsd.port.mk>
