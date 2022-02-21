# mempcpy is not present on FreeBSD 12
# https://bugs.freebsd.org/bugzilla//show_bug.cgi?id=262067

PORTNAME=	ringrtc
DISTVERSIONPREFIX=	v
DISTVERSION=	2.18.0
CATEGORIES=	multimedia
#MASTER_SITES=	http://mikael.urankar.free.fr/ringrtc/:base \
#		http://mikael.urankar.free.fr/ringrtc/:boringssl \
#		http://mikael.urankar.free.fr/ringrtc/:build \
#		http://mikael.urankar.free.fr/ringrtc/:buildtools \
#		http://mikael.urankar.free.fr/ringrtc/:catapult \
#		http://mikael.urankar.free.fr/ringrtc/:icu \
#		http://mikael.urankar.free.fr/ringrtc/:nasm \
#		http://mikael.urankar.free.fr/ringrtc/:libjpeg_turbo \
#		http://mikael.urankar.free.fr/ringrtc/:libsrtp \
#		http://mikael.urankar.free.fr/ringrtc/:libvpx \
#		http://mikael.urankar.free.fr/ringrtc/:libyuv \
#		http://mikael.urankar.free.fr/ringrtc/:third_party \
#		http://mikael.urankar.free.fr/ringrtc/:testing
DISTFILES=	base-${BASE_REV}.tar.gz:base \
		boringssl-${BORINGSSL_REV}.tar.gz:boringssl \
		build-${BUILD_REV}.tar.gz:build \
		buildtools-${BUILDTOOLS_REV}.tar.gz:buildtools \
		catapult-${CATAPULT_REV}.tar.gz:catapult \
		icu-${ICU_REV}.tar.gz:icu \
		nasm-${NASM_REV}.tar.gz:nasm \
		libjpeg_turbo-${LIBJPEG_REV}.tar.gz:libjpeg_turbo \
		libsrtp-${LIBSRTP_REV}.tar.gz:libsrtp \
		libvpx-${LIBVPX_REV}.tar.gz:libvpx \
		libyuv-${LIBYUV_REV}.tar.gz:libyuv \
		third_party-${THIRDPARTY_REV}.tar.gz:third_party \
		testing-${TESTING_REV}.tar.gz:testing

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Middleware library for Signal-Desktop

LICENSE=	AGPLv3
LICENSE_FILE=	${WRKSRC}/../../LICENSE

LIB_DEPENDS=	libfreetype.so:print/freetype2 \
		libpulse.so:audio/pulseaudio \
		libasound.so:audio/alsa-lib
BUILD_DEPENDS=	gn:devel/gn

USES=		cargo gnome localbase:ldflags pkgconfig ninja python:3.7+,build tar:xz
USE_GNOME=	glib20
USE_GITHUB=	yes
GH_ACCOUNT=	signalapp
GH_TUPLE=	signalapp:ringrtc:${DISTVERSIONPREFIX}${DISTVERSION} \
		signalapp:webrtc:${WEBRTC_REV}:webrtc


# Add extra-patch-no-mempcpy-nasm only when there's no mempcpy() in base.
# Nested variable expansion avoids executing the test when not needed for
# expanding EXTRA_PATCHES.
EXTRA_PATCHES+=	${"${:!${GREP} mempcpy ${CROSS_SYSROOT}/usr/include/string.h \
	|| ${TRUE}!}" == "":?${PATCHDIR}/extra-patch-no-mempcpy-nasm:}

WEBRTC_REV=4638f

# egrep "base@|boringssl.git@|build@|buildtools@|catapult.git@|icu.git@|libjpeg_turbo.git@|libsrtp.git@|libvpx.git|libyuv.git@|nasm.git@|testing@|third_party@" DEPS | grep https
BASE_REV=bdbd6f899ce50ac0efc87008384cf25a3eb0a03f
BORINGSSL_REV=dddb60eb9700110835ff6e2b429de40a17006429
BUILD_REV=f90eed6a5e137d43526c24eecfd96382a3233ee3
BUILDTOOLS_REV=7ea3a871db68ae2cbbeaf5433a3192a799ef3c11
CATAPULT_REV=d9a9ebbe89eaa7f479612b4e23ee38a313197d5e
ICU_REV=ece15d049f2d360721716089372e3749fb89e0f4
LIBJPEG_REV=ff19e5b2e176c61d552f68768e0e051867745321
LIBSRTP_REV=5b7c744eb8310250ccc534f3f86a2015b3887a0a
LIBVPX_REV=15a75b45304248f746634b43763c496322bf8968
LIBYUV_REV=49ebc996aa8c4bdf89c1b5ea461eb677234c61cc
NASM_REV=4e6fe9d1549e4ffb6c804494573e404849dfe7de
TESTING_REV=59835db543d03c36bafe56fb10d6a8b68e377621
THIRDPARTY_REV=a299c990bc6b40774066cb84281975a0371e7a8b

BINARY_ALIAS=	python3=${PYTHON_CMD}

# Keep in sync with https://github.com/signalapp/ringrtc/blob/${DISTVERSION}/bin/build-electron#L96
# Run "gn args out/Release --list" for all variables.
# Some parts don't have use_system_* flag, and can be turned on/off by using
# replace_gn_files.py script, some parts just turned on/off for target host
# OS "target_os == is_bsd", like libusb, libpci.
GN_ARGS+=	rtc_build_examples=false \
		rtc_build_tools=false \
		rtc_include_tests=false \
		rtc_enable_protobuf=false \
		rtc_use_x11=false \
		rtc_enable_sctp=false \
		rtc_libvpx_build_vp9=false \
		rtc_include_ilbc=false \
		use_custom_libcxx=false \
		is_debug=false \
		is_clang=true \
		clang_use_chrome_plugins=false \
		extra_cxxflags="${CXXFLAGS}" \
		extra_ldflags="${LDFLAGS}"

MAKE_ARGS=	-C out/${BUILDTYPE}

WRKSRC=		${WRKDIR}/${PORTNAME}-${DISTVERSION}/src/rust
WEBRTCDIR=	${WRKDIR}/${PORTNAME}-${DISTVERSION}/src/webrtc/src

# cd ${WRKSRC}/src/rust awk -f /usr/ports/Mk/Scripts/cargo-crates.awk Cargo.lock
CARGO_CRATES=	aes-0.7.5 \
		aho-corasick-0.7.18 \
		anyhow-1.0.44 \
		atty-0.2.14 \
		autocfg-1.0.1 \
		base64-0.13.0 \
		bitflags-1.3.2 \
		block-buffer-0.9.0 \
		bumpalo-3.7.1 \
		byteorder-1.4.3 \
		bytes-1.1.0 \
		cc-1.0.70 \
		cesu8-1.1.0 \
		cfg-if-1.0.0 \
		chunked_transfer-1.4.0 \
		cipher-0.3.0 \
		combine-4.6.1 \
		cpufeatures-0.2.1 \
		crypto-mac-0.11.1 \
		cslice-0.2.0 \
		ctr-0.8.0 \
		curve25519-dalek-3.2.0 \
		derivative-2.2.0 \
		digest-0.9.0 \
		either-1.6.1 \
		env_logger-0.8.4 \
		fixedbitset-0.2.0 \
		form_urlencoded-1.0.1 \
		futures-0.3.17 \
		futures-channel-0.3.17 \
		futures-core-0.3.17 \
		futures-executor-0.3.17 \
		futures-io-0.3.17 \
		futures-macro-0.3.17 \
		futures-sink-0.3.17 \
		futures-task-0.3.17 \
		futures-util-0.3.17 \
		generic-array-0.14.4 \
		getrandom-0.1.16 \
		getrandom-0.2.3 \
		hashbrown-0.11.2 \
		heck-0.3.3 \
		hermit-abi-0.1.19 \
		hex-0.4.3 \
		hkdf-0.11.0 \
		hmac-0.11.0 \
		humantime-2.1.0 \
		idna-0.2.3 \
		indexmap-1.7.0 \
		itertools-0.10.1 \
		itoa-0.4.8 \
		jni-0.19.0 \
		jni-sys-0.3.0 \
		js-sys-0.3.55 \
		lazy_static-1.4.0 \
		libc-0.2.103 \
		libloading-0.6.7 \
		log-0.4.14 \
		matches-0.1.9 \
		memchr-2.4.1 \
		multimap-0.8.3 \
		neon-0.9.1 \
		neon-build-0.9.1 \
		neon-macros-0.9.1 \
		neon-runtime-0.9.1 \
		num_cpus-1.13.0 \
		num_enum-0.5.4 \
		num_enum_derive-0.5.4 \
		once_cell-1.8.0 \
		opaque-debug-0.3.0 \
		percent-encoding-2.1.0 \
		petgraph-0.5.1 \
		pin-project-lite-0.2.7 \
		pin-utils-0.1.0 \
		ppv-lite86-0.2.10 \
		proc-macro-crate-1.1.0 \
		proc-macro-hack-0.5.19 \
		proc-macro-nested-0.1.7 \
		proc-macro2-1.0.29 \
		prost-0.8.0 \
		prost-build-0.8.0 \
		prost-derive-0.8.0 \
		prost-types-0.8.0 \
		quote-1.0.10 \
		rand-0.7.3 \
		rand-0.8.4 \
		rand_chacha-0.2.2 \
		rand_chacha-0.3.1 \
		rand_core-0.5.1 \
		rand_core-0.6.3 \
		rand_hc-0.2.0 \
		rand_hc-0.3.1 \
		redox_syscall-0.2.10 \
		regex-1.5.4 \
		regex-syntax-0.6.25 \
		remove_dir_all-0.5.3 \
		ring-0.16.20 \
		rustls-0.19.1 \
		ryu-1.0.5 \
		same-file-1.0.6 \
		sct-0.6.1 \
		semver-0.9.0 \
		semver-parser-0.7.0 \
		serde-1.0.130 \
		serde_derive-1.0.130 \
		serde_json-1.0.68 \
		sha2-0.9.9 \
		slab-0.4.4 \
		smallvec-1.7.0 \
		spin-0.5.2 \
		static_assertions-1.1.0 \
		subtle-2.4.1 \
		syn-1.0.78 \
		synstructure-0.12.5 \
		tempfile-3.2.0 \
		termcolor-1.1.2 \
		thiserror-1.0.29 \
		thiserror-impl-1.0.29 \
		tinyvec-1.5.0 \
		tinyvec_macros-0.1.0 \
		tokio-1.13.1 \
		toml-0.5.8 \
		typenum-1.14.0 \
		unicode-bidi-0.3.6 \
		unicode-normalization-0.1.19 \
		unicode-segmentation-1.8.0 \
		unicode-xid-0.2.2 \
		untrusted-0.7.1 \
		ureq-2.2.0 \
		url-2.2.2 \
		version_check-0.9.3 \
		walkdir-2.3.2 \
		wasi-0.9.0+wasi-snapshot-preview1 \
		wasi-0.10.2+wasi-snapshot-preview1 \
		wasm-bindgen-0.2.78 \
		wasm-bindgen-backend-0.2.78 \
		wasm-bindgen-macro-0.2.78 \
		wasm-bindgen-macro-support-0.2.78 \
		wasm-bindgen-shared-0.2.78 \
		web-sys-0.3.55 \
		webpki-0.21.4 \
		webpki-roots-0.21.1 \
		which-4.2.2 \
		winapi-0.3.9 \
		winapi-i686-pc-windows-gnu-0.4.0 \
		winapi-util-0.1.5 \
		winapi-x86_64-pc-windows-gnu-0.4.0 \
		x25519-dalek-1.2.0 \
		zeroize-1.3.0 \
		zeroize_derive-1.2.0

#CARGO_BUILDDEP=		no
CARGO_BUILD_ARGS=	--features electron
CARGO_INSTALL=		no

USE_LDCONFIG=		yes

MAKE_ENV=	OUTPUT_DIR=${WEBRTCDIR}/out

PLIST_FILES=	lib/libringrtc.so

post-extract:
	${MKDIR} ${WRKDIR}/${PORTNAME}-${DISTVERSION}/src/webrtc
	${MV} ${WRKDIR}/webrtc-${WEBRTC_REV} ${WEBRTCDIR}
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

	${ECHO} "# Generated from 'DEPS'" > ${WEBRTCDIR}/build/config/gclient_args.gni
	${ECHO} 1591703586 > ${WEBRTCDIR}/build/util/LASTCHANGE.committime
	${ECHO} "qqchose " > ${WEBRTCDIR}/build/util/LASTCHANGE

# https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=259334
# XXX use patch files instead
	${REINPLACE_CMD} -e 's|-D_XOPEN_SOURCE=700||' \
		${WRKSRC}/../webrtc/src/third_party/boringssl/src/util/BUILD.toplevel \
		${WRKSRC}/../webrtc/src/third_party/boringssl/src/util/generate_build_files.py \
		${WRKSRC}/../webrtc/src/third_party/boringssl/src/CMakeLists.txt
	${REINPLACE_CMD} -e 's|_XOPEN_SOURCE=700||' \
		${WRKSRC}/../webrtc/src/third_party/boringssl/BUILD.gn

pre-build:
	cd ${WEBRTCDIR} && \
		${SETENV} ${CONFIGURE_ENV} gn gen out/release --args='${GN_ARGS}'

# build webrtc first, ringrtc needs libwebrtc.a
	cd ${WEBRTCDIR} \
		&& ${MAKE_ENV} CC=ccache CXX=ccache ninja -C out/release

# it's not intended to be used outside of signal-desktop, put that in
# /usr/local/share/ringrtc instead?
do-install:
	${INSTALL_LIB} ${CARGO_TARGET_DIR}/${CARGO_BUILD_TARGET}/release/libringrtc.so \
		${STAGEDIR}${PREFIX}/lib/

.include <bsd.port.mk>
