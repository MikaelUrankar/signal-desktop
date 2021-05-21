# sources of inspiration:
#    https://github.com/tagattie/FreeBSD-Atom/blob/master/editors/atom/Makefile (npm offline)
#    www/chromium (webrtc patch)
#    lang/v8 (google build tools)
#
# to create the electron gyp cache:
#   XXX
#
# See bin/build-electron for the building instruction

PORTNAME=	ringrtc
DISTVERSIONPREFIX=	v
DISTVERSION=	2.9.4
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
		http://mikael.urankar.free.fr/ringrtc/:electron_gyp \
		https://nodejs.org/dist/v${NODE_VER}/:node_headers
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
		ringrtc-electron-gyp.tar.gz:electron_gyp \
		node-v${NODE_VER}-headers.tar.gz:node_headers

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Middleware library for Signal-Desktop

LICENSE=	AGPLv3
LICENSE_FILE=	${WRKSRC}/../../LICENSE

LIB_DEPENDS=	libfreetype.so:print/freetype2 \
		libpulse.so:audio/pulseaudio \
		libasound.so:audio/alsa-lib
BUILD_DEPENDS=	binutils>0:devel/binutils \
		gn:devel/gn \
		npm-node${NODE_VER_MAJOR}>0:www/npm-node${NODE_VER_MAJOR} \
		yarn-node${NODE_VER_MAJOR}>0:www/yarn-node${NODE_VER_MAJOR} \

USES=		cargo localbase:ldflags pkgconfig ninja python:3.6+,build tar:xz
USE_GNOME=	glib20
USE_GITHUB=	yes
GH_ACCOUNT=	signalapp
GH_TUPLE=	signalapp:ringrtc:${DISTVERSIONPREFIX}${DISTVERSION} \
		signalapp:webrtc:4183k:webrtc

NPM_CONFIG_TARGET=	11.3.0
NODE_VER=	14.16.1
NODE_VER_MAJOR=	${NODE_VER:C/\..*$//}
#ELECTRON_DIR=	${.CURDIR}/../../devel/electron12
ELECTRON_DIR=	/usr/ports/devel/electron12
.include	"${ELECTRON_DIR}/Makefile.version"

# egrep "base@|boringssl.git@|build@|buildtools@|catapult.git@|icu.git@|libjpeg_turbo.git@|libsrtp.git@|libvpx.git|libyuv.git@|nasm.git@|third_party@|testing@" DEPS | grep https
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

# cd ${WRKSRC}/src/rust awk -f /usr/ports/Mk/Scripts/cargo-crates.awk Cargo.lock
CARGO_CRATES=	addr2line-0.15.1 \
		adler-1.0.2 \
		aes-ctr-0.6.0 \
		aes-soft-0.6.4 \
		aesni-0.10.0 \
		aho-corasick-0.7.18 \
		anyhow-1.0.40 \
		atty-0.2.14 \
		autocfg-1.0.1 \
		backtrace-0.3.59 \
		base64-0.13.0 \
		bitflags-1.2.1 \
		block-buffer-0.9.0 \
		byteorder-1.4.3 \
		bytes-0.5.6 \
		bytes-1.0.1 \
		cc-1.0.67 \
		cesu8-1.1.0 \
		cfg-if-1.0.0 \
		chrono-0.4.19 \
		cipher-0.2.5 \
		combine-4.5.2 \
		cpufeatures-0.1.4 \
		crypto-mac-0.8.0 \
		crypto-mac-0.9.1 \
		cslice-0.2.0 \
		ctr-0.6.0 \
		curve25519-dalek-2.1.2 \
		digest-0.8.1 \
		digest-0.9.0 \
		either-1.6.1 \
		env_logger-0.8.3 \
		error-chain-0.12.4 \
		failure-0.1.8 \
		failure_derive-0.1.8 \
		fixedbitset-0.2.0 \
		futures-0.3.15 \
		futures-channel-0.3.15 \
		futures-core-0.3.15 \
		futures-executor-0.3.15 \
		futures-io-0.3.15 \
		futures-macro-0.3.15 \
		futures-sink-0.3.15 \
		futures-task-0.3.15 \
		futures-util-0.3.15 \
		generic-array-0.12.4 \
		generic-array-0.14.4 \
		getrandom-0.1.16 \
		getrandom-0.2.3 \
		gimli-0.24.0 \
		hashbrown-0.9.1 \
		heck-0.3.2 \
		hermit-abi-0.1.18 \
		hkdf-0.9.0 \
		hmac-0.8.1 \
		hmac-0.9.0 \
		humantime-2.1.0 \
		indexmap-1.6.2 \
		itertools-0.8.2 \
		itoa-0.4.7 \
		jni-0.17.0 \
		jni-sys-0.3.0 \
		lazy_static-1.4.0 \
		libc-0.2.94 \
		libloading-0.6.7 \
		log-0.4.14 \
		memchr-2.4.0 \
		miniz_oxide-0.4.4 \
		multimap-0.8.3 \
		neon-0.7.1 \
		neon-build-0.7.1 \
		neon-macros-0.7.1 \
		neon-runtime-0.7.1 \
		num-integer-0.1.44 \
		num-traits-0.2.14 \
		num_cpus-1.13.0 \
		object-0.24.0 \
		opaque-debug-0.3.0 \
		petgraph-0.5.1 \
		pin-project-lite-0.2.6 \
		pin-utils-0.1.0 \
		ppv-lite86-0.2.10 \
		proc-macro-hack-0.5.19 \
		proc-macro-nested-0.1.7 \
		proc-macro2-1.0.27 \
		prost-0.6.1 \
		prost-build-0.6.1 \
		prost-derive-0.6.1 \
		prost-types-0.6.1 \
		quote-1.0.9 \
		rand-0.7.3 \
		rand-0.8.3 \
		rand_chacha-0.2.2 \
		rand_chacha-0.3.0 \
		rand_core-0.5.1 \
		rand_core-0.6.2 \
		rand_hc-0.2.0 \
		rand_hc-0.3.0 \
		redox_syscall-0.2.8 \
		regex-1.5.4 \
		regex-syntax-0.6.25 \
		remove_dir_all-0.5.3 \
		rustc-demangle-0.1.19 \
		ryu-1.0.5 \
		same-file-1.0.6 \
		semver-0.9.0 \
		semver-parser-0.7.0 \
		serde-1.0.126 \
		serde_derive-1.0.126 \
		serde_json-1.0.64 \
		sha2-0.9.5 \
		simplelog-0.7.6 \
		slab-0.4.3 \
		smallvec-1.6.1 \
		static_assertions-1.1.0 \
		subtle-2.4.0 \
		syn-1.0.72 \
		synstructure-0.12.4 \
		tempfile-3.2.0 \
		termcolor-1.1.2 \
		thiserror-1.0.24 \
		thiserror-impl-1.0.24 \
		time-0.1.43 \
		tokio-0.3.7 \
		typenum-1.13.0 \
		unicode-segmentation-1.7.1 \
		unicode-xid-0.2.2 \
		version_check-0.9.3 \
		walkdir-2.3.2 \
		wasi-0.9.0+wasi-snapshot-preview1 \
		wasi-0.10.2+wasi-snapshot-preview1 \
		which-3.1.1 \
		winapi-0.3.9 \
		winapi-i686-pc-windows-gnu-0.4.0 \
		winapi-util-0.1.5 \
		winapi-x86_64-pc-windows-gnu-0.4.0 \
		x25519-dalek-0.6.0 \
		zeroize-1.3.0 \
		zeroize_derive-1.1.0
CARGO_BUILDDEP=		no
CARGO_BUILD_ARGS=	--features electron
CARGO_INSTALL=		no
USE_LDCONFIG=		yes

MAKE_ENV=	RUSTC_BOOTSTRAP=1

# keep in sync with https://github.com/signalapp/ringrtc/blob/v2.9.4/bin/build-electron#L109
CARGO_ENV+=	npm_config_arch=x64 \
		npm_config_target_arch=x64 \
		npm_config_disturl=https://atom.io/download/electron \
		npm_config_runtime=electron \
		npm_config_target=${NPM_CONFIG_TARGET} \
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

# it's not intended to be used outside of signal-desktop, put that in
# /usr/local/share/ringrtc instead?
do-install:
	${INSTALL_LIB} ${CARGO_TARGET_DIR}/release/libringrtc.so \
		${STAGEDIR}${PREFIX}/lib/

.include <bsd.port.mk>
