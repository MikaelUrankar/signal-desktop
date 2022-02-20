# for testing the app, set these env (do not use them for building, especially NODE_ENV)
# setenv NODE_ENV production
# setenv SIGNAL_ENV production
# setenv USE_SYSTEM_7ZA true
# setenv USE_SYSTEM_APP_BUILDER true
# setenv ELECTRON_SKIP_BINARY_DOWNLOAD 1
# setenv ELECTRON_OVERRIDE_DIST_PATH /home/miki/.cache/electron
#
# set for building
# setenv PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD true
# setenv PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS true
# PLAYWRIGHT_BROWSERS_PATH

# essayer de virer @chanzuckerberg/axe-storybook-testing et remettre playwright?

PORTNAME=	signal-desktop
DISTVERSION=	5.32.0
DISTVERSIONPREFIX=	v
CATEGORIES=	net-im
#MASTER_SITES=	http://mikael.urankar.free.fr/signal-desktop/:yarn \
#		https://nodejs.org/dist/v${NODE_VER}/:node_headers
#DISTFILES=	signal-desktop-yarn-modules-${DISTVERSION}.tar.gz:yarn \
#		node-v${NODE_VER}-headers.tar.gz:node_headers

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Cross-platform centralized encrypted messaging service

LICENSE=	AGPLv3
LICENSE_FILE=	${WRKSRC}/LICENSE

#BUILD_DEPENDS=	${LOCALBASE}/lib/libringrtc.so:multimedia/ringrtc \
#		${LOCALBASE}/lib/libsignal_node.so:net-im/libsignal-client-node \
#		app-builder>0:devel/app-builder \
#		electron${ELECTRON_VER_MAJOR}:devel/electron${ELECTRON_VER_MAJOR} \
#		npm-node${NODE_VER_MAJOR}>0:www/npm-node${NODE_VER_MAJOR} \
#		openssl>0:security/openssl \
#		vips>0:graphics/vips \
#		yarn-node${NODE_VER_MAJOR}>0:www/yarn-node${NODE_VER_MAJOR} \
#		zip>0:archivers/zip \
#		zkgroup>0:net-im/zkgroup

# XXX try to update node-gyp and drop python2.7 dep
USES=		desktop-file-utils python:2.7,build
USE_GITHUB=	yes
GH_ACCOUNT=	signalapp

WRKSRC=		${WRKDIR}/Signal-Desktop-${DISTVERSION}${DISTVERSIONSUFFIX}

MAKE_ENV+=	HOME=${WRKDIR} \
		SIGNAL_ENV=production \
		USE_SYSTEM_7ZA=true \
		USE_SYSTEM_APP_BUILDER=true \
		XDG_CACHE_HOME=${WRKDIR}/.cache \
		npm_config_python=python2.7

# Don't download electron binary distribution on electron node_modules installation
MAKE_ENV+=	ELECTRON_SKIP_BINARY_DOWNLOAD=1
# Don't create __pycache__ directory when executing node-gyp
# This is a workaround to avoid filesystem violations during poudriere build
MAKE_ENV+=	PYTHONDONTWRITEBYTECODE=1

#NODE_VER=	14.16.1
#NODE_VER_MAJOR=	${NODE_VER:C/\..*$//}
##ELECTRON_DIR=	${.CURDIR}/../../devel/electron12
#ELECTRON_DIR=	/usr/ports/devel/electron12
#.include	"${ELECTRON_DIR}/Makefile.version"

BINARY_ALIAS=	python=python2.7

# Taken from https://github.com/tagattie/FreeBSD-Electron
# XXX convert to Taggatie's framework
PREFETCH_TIMESTAMP=	1616313125 # epoch ??? Sunday, 21 March 2021
PKGJSONSDIR=		${FILESDIR}/packagejsons
YARN_CMD=		${LOCALBASE}/bin/${_YARN_BASE_CMD}
_YARN_BASE_CMD=		yarn

# XXX remove unsafe-disable-integrity-migration when they fixed their shit
#pre-fetch:
#	@if [ ! -f ${DISTDIR}/${PORTNAME}-yarn-modules-${DISTVERSION}${EXTRACT_SUFX} ]; then \
#		${ECHO_MSG} "===>  Distfile ${DISTDIR}/${PORTNAME}-yarn-modules-${DISTVERSION}${EXTRACT_SUFX} not found"; \
#		${ECHO_MSG} "===>  Pre-fetching and archiving node modules"; \
#		${MKDIR} ${WRKDIR}; \
#		${ECHO_CMD} 'yarn-offline-mirror "./yarn-offline-cache"' >> \
#			${WRKDIR}/.yarnrc; \
#		${ECHO_CMD} 'unsafe-disable-integrity-migration false' >> \
#			${WRKDIR}/.yarnrc; \
#		${CP} -r ${PKGJSONSDIR}/* ${WRKDIR}; \
#		cd ${PKGJSONSDIR} && \
#		for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
#			cd ${WRKDIR}/$${dir} && \
#			${SETENV} HOME=${WRKDIR} XDG_CACHE_HOME=${WRKDIR}/.cache \
#				${YARN_CMD} --frozen-lockfile --ignore-scripts && \
#			${RM} package.json yarn.lock; \
#		done; \
#		cd ${WRKDIR}; \
#		${MTREE_CMD} -cbnSp yarn-offline-cache | ${MTREE_CMD} -C | ${SED} \
#			-e 's:time=[0-9.]*:time=${PREFETCH_TIMESTAMP}.000000000:' \
#			-e 's:\([gu]id\)=[0-9]*:\1=0:g' \
#			-e 's:flags=.*:flags=none:' \
#			-e 's:^\.:./yarn-offline-cache:' > yarn-offline-cache.mtree; \
#		${TAR} -cz --options 'gzip:!timestamp' \
#			-f ${DISTDIR}/${PORTNAME}-yarn-modules-${DISTVERSION}${EXTRACT_SUFX} @yarn-offline-cache.mtree; \
#		${RM} -r ${WRKDIR}; \
#	fi

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
	${MKDIR} ${WRKDIR}/.cache/electron
#	@if [ ! -f ${LOCALBASE}/share/electron${ELECTRON_VER_MAJOR} ]; then \
#		cd ${LOCALBASE}/share/electron${ELECTRON_VER_MAJOR} && \
#			zip -q -r ${WRKDIR}/.cache/electron/electron-v${ELECTRON_VER_MAJOR}-freebsd-x64.zip .
#	fi
#	cd ${LOCALBASE}/share/electron${ELECTRON_VER_MAJOR} && \
#		zip -q -r ${WRKDIR}/.cache/electron/chromedriver-v3.0.0-freebsd-x64.zip chromedriver
	cd ${WRKDIR}/.cache/electron && \
		${SHA256} -r *.zip | \
		${SED} -e 's/ / */' > SHASUMS256.txt-3.0.0
# XXX sigh, node scripts/fuse-electron.js tries to open electron in RW
# copy electron in /tmp, see also files/patch-electron
	${MKDIR} /tmp/electron12
	(cd ${LOCALBASE}/share/electron${ELECTRON_VER_MAJOR} && \
		${COPYTREE_SHARE} . /tmp/electron12)
	${CHMOD} -R a+rw /tmp/electron12

	@${ECHO_MSG} "===>  Installing node modules from pre-fetched cache"
	@${ECHO_CMD} 'yarn-offline-mirror "../yarn-offline-cache"' >> ${WRKSRC}/.yarnrc
	@${ECHO_CMD} 'nodedir "${WRKDIR}/node-v${NODE_VER}"' >> ${WRKSRC}/.yarnrc
	@cd ${PKGJSONSDIR} && \
	for dir in `${FIND} . -type f -name package.json -exec dirname {} ';'`; do \
		cd ${WRKSRC}/$${dir} && ${SETENV} HOME=${WRKDIR} XDG_CACHE_HOME=${WRKDIR}/.cache \
			${YARN_CMD} --frozen-lockfile --ignore-scripts --offline; \
	done

do-build:
	@${ECHO_MSG} "===>  do-build"
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn --frozen-lockfile --offline

	${MKDIR} ${WRKSRC}/node_modules/ringrtc/build/freebsd
	${CP} ${PREFIX}/lib/libringrtc.so ${WRKSRC}/node_modules/ringrtc/build/freebsd/libringrtc.node
	${CP} ${PREFIX}/lib/libsignal_node.so ${WRKSRC}/node_modules/libsignal-client/build/libsignal_client_freebsd.node
	${CP} ${PREFIX}/lib/libzkgroup.so ${WRKSRC}/node_modules/zkgroup

	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn install --frozen-lockfile --ignore-optional
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn generate
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn build:webpack

do-install:
	# taken from https://github.com/tagattie/FreeBSD-Electron/blob/master/Mk/Uses/electron.mk#L387
	# and editors/vscode
	cd ${WRKSRC} && \
		${SETENV} ${MAKE_ENV} yarn run electron-builder \
			--linux --dir  --config.npmRebuild=false \
			--config.electronVersion=${ELECTRON_VER} \
			--config.electronDist=${LOCALBASE}/share/electron${ELECTRON_VER_MAJOR}

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
