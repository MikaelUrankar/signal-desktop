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

# Taken from https://github.com/tagattie/FreeBSD-Electron
# XXX convert to Taggatie's framework
PREFETCH_TIMESTAMP=     1616313125
PKGJSONSDIR=	${FILESDIR}/packagejsons
YARN_CMD=	${LOCALBASE}/bin/${_YARN_BASE_CMD}
_YARN_BASE_CMD=	yarn

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

	# XXX convert to patch files
	# yarn run patch-package @journeyapps/sqlcipher
	cp ${FILESDIR}/@journeyapps+sqlcipher+5.0.0.patch ${WRKSRC}/patches
	cp ${FILESDIR}/electron-builder+22.9.1.patch ${WRKSRC}/patches
	cp ${FILESDIR}/electron+11.2.3.patch ${WRKSRC}/patches

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
	${CP} /usr/local/lib/libringrtc.so ${WRKSRC}/node_modules/ringrtc/build/freebsd/libringrtc.node
	${CP} /usr/local/lib/libsignal_node.so ${WRKSRC}/node_modules/libsignal-client/build/libsignal_client_freebsd.node
	${CP} /usr/local/lib/libzkgroup.so ${WRKSRC}/node_modules/zkgroup

	cd ${WRKSRC} && \
		yarn grunt
	cd ${WRKSRC} && \
		yarn build:webpack

.include <bsd.port.mk>
