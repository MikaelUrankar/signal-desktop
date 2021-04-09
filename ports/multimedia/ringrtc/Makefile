# keep it at v2.9.2, newer version is not compatible with Signal-Desktop 1.40.1
# sources of inspiration:
#    https://github.com/tagattie/FreeBSD-Atom/blob/master/editors/atom/Makefile (npm offline)
#    www/chromium (webrtc patch)
#    lang/v8 (google build tools)
#
# XXX
#   enable sndio in webrtc (see chromium's patches)
#   remove hardcoded version v12.21.0, npm_config_target=11.3.0
#
# to create the npm cache:
#   cd src/rust/cargo-crates/neon-sys-0.6.0/native
#   npm install --ignore-scripts --offline
#   cd ${WRKDIR}
#   tar czf signalapp-npm-offline-cache.tar.gz .npm
#
# to create the electron gyp cache:
#   XXX    

PORTNAME=	ringrtc
DISTVERSIONPREFIX=	v
DISTVERSION=	2.9.2
CATEGORIES=	multimedia
MASTER_SITES=	http://mikael.urankar.free.fr/ringrtc/:base \
		http://mikael.urankar.free.fr/ringrtc/:boringssl \
		http://mikael.urankar.free.fr/ringrtc/:build \
		http://mikael.urankar.free.fr/ringrtc/:buildtools \
		http://mikael.urankar.free.fr/ringrtc/:catapult \
		http://mikael.urankar.free.fr/ringrtc/:icu \
		http://mikael.urankar.free.fr/ringrtc/:nasm \
		http://mikael.urankar.free.fr/ringrtc/:libjpeg_turbo \
		http://mikael.urankar.free.fr/ringrtc/:libsrtp \
		http://mikael.urankar.free.fr/ringrtc/:libvpx \
		http://mikael.urankar.free.fr/ringrtc/:libyuv \
		http://mikael.urankar.free.fr/ringrtc/:third_party \
		http://mikael.urankar.free.fr/ringrtc/:testing \
		http://mikael.urankar.free.fr/ringrtc/:npm_cache \
		http://mikael.urankar.free.fr/ringrtc/:electron_gyp \
		https://nodejs.org/dist/v12.21.0/:node_headers
DISTFILES=	base-${BASE_HASH}.tar.gz:base \
		boringssl-${BORINGSSL_HASH}.tar.gz:boringssl \
		build-${BUILD_HASH}.tar.gz:build \
		buildtools-${BUILDTOOLS_HASH}.tar.gz:buildtools \
		catapult-${CATAPULT_HASH}.tar.gz:catapult \
		icu-${ICU_HASH}.tar.gz:icu \
		nasm-${NASM_HASH}.tar.gz:nasm \
		libjpeg_turbo-${LIBJPEG_HASH}.tar.gz:libjpeg_turbo \
		libsrtp-${LIBSRTP_HASH}.tar.gz:libsrtp \
		libvpx-${LIBVPX_HASH}.tar.gz:libvpx \
		libyuv-${LIBYUV_HASH}.tar.gz:libyuv \
		third_party-${THIRDPARTY_HASH}.tar.gz:third_party \
		testing-${TESTING_HASH}.tar.gz:testing \
		ringrtc-npm-offline-cache.tar.gz:npm_cache \
		ringrtc-electron-gyp.tar.gz:electron_gyp \
		node-v12.21.0-headers.tar.gz:node_headers

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Middleware library for Signal-Desktop

LICENSE=	AGPLv3
LICENSE_FILE=	${WRKSRC}/../../LICENSE

LIB_DEPENDS=	libfreetype.so:print/freetype2 \
		libpulse.so:audio/pulseaudio \
		libasound.so:audio/alsa-lib
BUILD_DEPENDS=	binutils>0:devel/binutils \
		gn:devel/gn \
		rust-nightly>=0:lang/rust-nightly \
		npm-node12>0:www/npm-node12 \
		yarn-node12>0:www/yarn-node12

USES=		cargo localbase:ldflags pkgconfig ninja python:3.6+,build tar:xz
USE_GNOME=	glib20
USE_GITHUB=	yes
GH_ACCOUNT=	signalapp
GH_TUPLE=	signalapp:ringrtc:${DISTVERSIONPREFIX}${DISTVERSION} \
		signalapp:webrtc:4183k:webrtc

# egrep "src/build|src/buildtools|src/testing|etc" src/webrtc/src/DEPS
BASE_HASH=	2df7267880bf7d4086d55c0e56cd72c394bfda36
BORINGSSL_HASH=	88024df12147e56b6abd66b743ff441a0aaa09a8
BUILD_HASH=	a03951acb996e9cea78b4ab575896bf1bfcd9668
BUILDTOOLS_HASH=1b066f021638735d72aa799ae6bc37e0b8963c67
CATAPULT_HASH=	2ad47493f833c5191f56c74d3f1aac10e7c105e8
ICU_HASH=	630b884f84d1d5e92aeda3463dca99fe2befd30e
LIBJPEG_HASH=	7e3ad79800a7945fb37173149842b494ab8982b2
LIBSRTP_HASH=	650611720ecc23e0e6b32b0e3100f8b4df91696c
LIBVPX_HASH=	c1765573149e2c0fe2acabc224c0f9085b9e7f2b
LIBYUV_HASH=	6afd9becdf58822b1da6770598d8597c583ccfad
NASM_HASH=	4fa54ca5f7fc3a15a8c78ac94688e64d3e4e4fa1
THIRDPARTY_HASH=e0df6e10adc084f88dda51c0cbab84645db6c135
TESTING_HASH=	502600d41a00af23dd09e02ea358061e3c951634

BUILDTYPE=	Release

BINARY_ALIAS=	python=${PYTHON_CMD}

# Keep in sync with https://github.com/signalapp/ringrtc/blob/${DISTVERSION}/bin/build-electron#L96
# Run "gn args out/Release --list" for all variables.
# Some parts don't have use_system_* flag, and can be turned on/off by using
# replace_gn_files.py script, some parts just turned on/off for target host
# OS "target_os == is_bsd", like libusb, libpci.
GN_ARGS+=	use_custom_libcxx=false \
		rtc_build_examples=false \
		rtc_build_tools=false \
		rtc_include_tests=false \
		rtc_enable_protobuf=false \
		rtc_use_x11=false \
		is_debug=false \
		rtc_enable_sctp=false \
		clang_use_chrome_plugins=false \
		rtc_disable_logging=false \
		extra_cxxflags="${CXXFLAGS}" \
		extra_ldflags="${LDFLAGS}"

MAKE_ARGS=	-C out/${BUILDTYPE}

WRKSRC=	${WRKDIR}/${PORTNAME}-${DISTVERSION}/src/rust
WEBRTCDIR=	${WRKDIR}/${PORTNAME}-${DISTVERSION}/src/webrtc/src

CARGO_CRATES=	addr2line-0.14.0 \
		adler-0.2.3 \
		aes-ctr-0.6.0 \
		aes-soft-0.6.3 \
		aesni-0.10.0 \
		aho-corasick-0.7.15 \
		anyhow-1.0.34 \
		atty-0.2.14 \
		autocfg-1.0.1 \
		backtrace-0.3.54 \
		base64-0.13.0 \
		block-buffer-0.9.0 \
		byteorder-1.3.4 \
		bytes-0.5.6 \
		cc-1.0.61 \
		cesu8-1.1.0 \
		cfg-if-0.1.10 \
		cfg-if-1.0.0 \
		chrono-0.4.19 \
		cipher-0.2.5 \
		combine-4.3.2 \
		cpuid-bool-0.1.2 \
		crypto-mac-0.8.0 \
		crypto-mac-0.9.1 \
		cslice-0.2.0 \
		ctr-0.6.0 \
		curve25519-dalek-2.1.0 \
		digest-0.8.1 \
		digest-0.9.0 \
		either-1.6.1 \
		env_logger-0.8.1 \
		error-chain-0.12.4 \
		failure-0.1.8 \
		failure_derive-0.1.8 \
		fixedbitset-0.2.0 \
		futures-0.3.7 \
		futures-channel-0.3.7 \
		futures-core-0.3.7 \
		futures-executor-0.3.7 \
		futures-io-0.3.7 \
		futures-macro-0.3.7 \
		futures-sink-0.3.7 \
		futures-task-0.3.7 \
		futures-util-0.3.7 \
		generic-array-0.12.3 \
		generic-array-0.14.4 \
		getrandom-0.1.15 \
		gimli-0.23.0 \
		hashbrown-0.9.1 \
		heck-0.3.1 \
		hermit-abi-0.1.17 \
		hkdf-0.9.0 \
		hmac-0.8.1 \
		hmac-0.9.0 \
		humantime-2.0.1 \
		indexmap-1.6.0 \
		itertools-0.8.2 \
		itoa-0.4.6 \
		jni-0.17.0 \
		jni-sys-0.3.0 \
		lazy_static-1.4.0 \
		libc-0.2.80 \
		log-0.4.11 \
		memchr-2.3.4 \
		miniz_oxide-0.4.3 \
		multimap-0.8.2 \
		neon-0.6.0 \
		neon-build-0.6.0 \
		neon-runtime-0.6.0 \
		neon-sys-0.6.0 \
		num-integer-0.1.44 \
		num-traits-0.2.14 \
		num_cpus-1.13.0 \
		object-0.22.0 \
		once_cell-1.4.1 \
		opaque-debug-0.3.0 \
		petgraph-0.5.1 \
		pin-project-1.0.1 \
		pin-project-internal-1.0.1 \
		pin-project-lite-0.1.11 \
		pin-utils-0.1.0 \
		ppv-lite86-0.2.10 \
		proc-macro-hack-0.5.19 \
		proc-macro-nested-0.1.6 \
		proc-macro2-1.0.24 \
		prost-0.6.1 \
		prost-build-0.6.1 \
		prost-derive-0.6.1 \
		prost-types-0.6.1 \
		quote-1.0.7 \
		rand-0.7.3 \
		rand_chacha-0.2.2 \
		rand_core-0.5.1 \
		rand_hc-0.2.0 \
		redox_syscall-0.1.57 \
		regex-1.4.2 \
		regex-syntax-0.6.21 \
		remove_dir_all-0.5.3 \
		rustc-demangle-0.1.18 \
		ryu-1.0.5 \
		same-file-1.0.6 \
		semver-0.9.0 \
		semver-parser-0.7.0 \
		serde-1.0.117 \
		serde_derive-1.0.117 \
		serde_json-1.0.59 \
		sha2-0.9.2 \
		simplelog-0.7.6 \
		slab-0.4.2 \
		smallvec-1.5.1 \
		static_assertions-1.1.0 \
		subtle-2.3.0 \
		syn-1.0.48 \
		synstructure-0.12.4 \
		tempfile-3.1.0 \
		termcolor-1.1.0 \
		thiserror-1.0.22 \
		thiserror-impl-1.0.22 \
		thread_local-1.0.1 \
		time-0.1.44 \
		tokio-0.3.3 \
		typenum-1.12.0 \
		unicode-segmentation-1.6.0 \
		unicode-xid-0.2.1 \
		version_check-0.9.2 \
		walkdir-2.3.1 \
		wasi-0.9.0+wasi-snapshot-preview1 \
		wasi-0.10.0+wasi-snapshot-preview1 \
		which-3.1.1 \
		winapi-0.3.9 \
		winapi-i686-pc-windows-gnu-0.4.0 \
		winapi-util-0.1.5 \
		winapi-x86_64-pc-windows-gnu-0.4.0 \
		x25519-dalek-0.6.0 \
		zeroize-1.1.1 \
		zeroize_derive-1.0.1

# CARGO_BUILDDEP=no is needed to force the use of rust-nightly.
CARGO_BUILDDEP=		no
CARGO_BUILD_ARGS=	--features electron
CARGO_INSTALL=		no
USE_LDCONFIG=		yes

# keep in sync with https://github.com/signalapp/ringrtc/blob/v2.9.2/bin/build-electron#L109
CARGO_ENV+=	npm_config_arch=x64 \
		npm_config_target_arch=x64 \
		npm_config_disturl=https://atom.io/download/electron \
		npm_config_runtime=electron \
		npm_config_target=11.3.0 \
		npm_config_build_from_source=true \
		npm_config_devdir=${WRKDIR}/electron-gyp

PLIST_FILES=	lib/libringrtc.so

post-extract:
	${MKDIR} ${WRKDIR}/${PORTNAME}-${DISTVERSION}/src/webrtc
	${MV} ${WRKDIR}/webrtc-4183k ${WEBRTCDIR}
	${MV} ${WRKDIR}/base ${WEBRTCDIR}
	${MV} ${WRKDIR}/build ${WEBRTCDIR}
	${MV} ${WRKDIR}/buildtools ${WEBRTCDIR}
	${MV} ${WRKDIR}/testing ${WEBRTCDIR}
	${MV} ${WRKDIR}/third_party ${WEBRTCDIR}
	${MV} ${WRKDIR}/catapult ${WEBRTCDIR}/third_party
	${MV} ${WRKDIR}/boringssl ${WEBRTCDIR}/third_party/boringssl/src
	${MV} ${WRKDIR}/icu ${WEBRTCDIR}/third_party
	${MV} ${WRKDIR}/libjpeg_turbo ${WEBRTCDIR}/third_party
	${MV} ${WRKDIR}/libsrtp ${WEBRTCDIR}/third_party
	${MV} ${WRKDIR}/libvpx ${WEBRTCDIR}/third_party/libvpx/source
	${MV} ${WRKDIR}/libyuv ${WEBRTCDIR}/third_party
	${MV} ${WRKDIR}/nasm ${WEBRTCDIR}/third_party

post-patch:
	${REINPLACE_CMD} "s|LOCALBASE|${LOCALBASE}|" \
		${WEBRTCDIR}/build/toolchain/gcc_toolchain.gni \
		${WEBRTCDIR}/buildtools/third_party/libc++/BUILD.gn

	${TOUCH} ${WEBRTCDIR}/build/config/gclient_args.gni
	${ECHO} "# Generated from 'DEPS'" >> ${WEBRTCDIR}/build/config/gclient_args.gni

	${ECHO} 1591703586 > ${WEBRTCDIR}/build/util/LASTCHANGE.committime
	${ECHO} "qqchose " > ${WEBRTCDIR}/build/util/LASTCHANGE

pre-build:
	cd ${WEBRTCDIR} && \
		${SETENV} ${CONFIGURE_ENV} gn gen out/${BUILDTYPE} --args='${GN_ARGS}'

# build webrtc first, ringrtc needs libwebrtc.a
	cd ${WEBRTCDIR} \
		&& ${MAKE_ENV} CC=ccache CXX=ccache ninja -C out/Release

# build ringrtc
	cd ${WRKSRC}/cargo-crates/neon-sys-0.6.0/native && \
		${SETENV} ${MAKE_ENV} \
		npm_config_target=11.3 \
		npm_config_build_from_source=true \
		npm_config_nodedir=${LOCALBASE}/share/electron11/node_headers \
		npm_config_offline=true \
		npm install --ignore-scripts --offline

# it's not intended to be used outside of signal-desktop, put that in
# /usr/local/share/ringrtc instead?
do-install:
	${INSTALL_LIB} ${CARGO_TARGET_DIR}/release/libringrtc.so \
		${STAGEDIR}${PREFIX}/lib/

.include <bsd.port.mk>
