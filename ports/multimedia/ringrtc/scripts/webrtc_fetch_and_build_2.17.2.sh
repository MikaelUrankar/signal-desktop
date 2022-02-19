#!/bin/sh
# ringrtc has to be extracted first, say ringrtc-2.17.2
# then mkdir -p ringrtc-2.17.2/src/webrtc/src
# tar xf webrtc-4638e -C src/webrtc/src

# patch testing/test.gni: tests_have_location_tags = false
# remove test.gni everywhere
#    BUILD.gn
#    third_party/libyuv/BUILD.gn
#    third_party/libsrtp/BUILD.gn
#    testing/libfuzzer/fuzzer_test.gni

# libyuv: libyuv_unittest unknown func
# third_party/libyuv/libyuv.gni:  libyuv_include_tests = !build_with_chromium
#
# benchmark not needed?
# https://chromium.googlesource.com/chromium/src/+/refs/tags/87.0.4280.63/third_party/google_benchmark/buildconfig.gni

BASE_REV=bdbd6f899ce50ac0efc87008384cf25a3eb0a03f
BUILD_REV=f90eed6a5e137d43526c24eecfd96382a3233ee3
BUILDTOOLS_REV=7ea3a871db68ae2cbbeaf5433a3192a799ef3c11
ICU_REV=ece15d049f2d360721716089372e3749fb89e0f4
TESTING_REV=59835db543d03c36bafe56fb10d6a8b68e377621
THIRDPARTY_REV=a299c990bc6b40774066cb84281975a0371e7a8b
LIBYUV_REV=49ebc996aa8c4bdf89c1b5ea461eb677234c61cc
LIBSRTP_REV=5b7c744eb8310250ccc534f3f86a2015b3887a0a
LIBJPEG_REV=ff19e5b2e176c61d552f68768e0e051867745321
NASM_REV=4e6fe9d1549e4ffb6c804494573e404849dfe7de
CATAPULT_REV=d9a9ebbe89eaa7f479612b4e23ee38a313197d5e
BORINGSSL_REV=dddb60eb9700110835ff6e2b429de40a17006429
LIBVPX_REV=15a75b45304248f746634b43763c496322bf8968

#BENCHMARK_REV=e991355c02b93fe17713efe04cbc2e278e00fdbd

RINGRTC_REV=2.17.2
WEBRTC_REV=4638e

DISTDIR=/usr/ports/distfiles/ringrtc-${RINGRTC_REV}
WRKSRC=ringrtc-${RINGRTC_REV}/src/webrtc/src
ECHO=echo
TOUCH=touch
MV=mv
TAR=tar
FETCH_CMD=fetch
MKDIR=mkdir


# Fetch
#${FETCH_CMD} -o ${DISTDIR}/base-${BASE_REV}.tar.gz \
#        https://chromium.googlesource.com/chromium/src/base.git/+archive/${BASE_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/build-${BUILD_REV}.tar.gz \
#        https://chromium.googlesource.com/chromium/src/build.git/+archive/${BUILD_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/buildtools-${BUILDTOOLS_REV}.tar.gz \
#        https://chromium.googlesource.com/chromium/src/buildtools.git/+archive/${BUILDTOOLS_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/testing-${TESTING_REV}.tar.gz \
#        https://chromium.googlesource.com/chromium/src/testing.git/+archive/${TESTING_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/icu-${ICU_REV}.tar.gz \
#        https://chromium.googlesource.com/chromium/deps/icu.git/+archive/${ICU_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/thirdparty-${THIRDPARTY_REV}.tar.gz \
#	https://chromium.googlesource.com/chromium/src/third_party.git/+archive/${THIRDPARTY_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/libyuv-${LIBYUV_REV}.tar.gz \
#	https://chromium.googlesource.com/libyuv/libyuv.git/+archive/${LIBYUV_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/libsrtp-${LIBSRTP_REV}.tar.gz \
#	https://chromium.googlesource.com/chromium/deps/libsrtp.git/+archive/${LIBSRTP_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/libjpeg_turbo-${LIBJPEG_REV}.tar.gz \
#	https://chromium.googlesource.com/chromium/deps/libjpeg_turbo.git/+archive/${LIBJPEG_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/nasm-${NASM_REV}.tar.gz \
#	https://chromium.googlesource.com/chromium/deps/nasm.git/+archive/${NASM_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/catapult-${CATAPULT_REV}.tar.gz \
#	https://chromium.googlesource.com/catapult.git/+archive/${CATAPULT_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/boringssl-${BORINGSSL_REV}.tar.gz \
#	https://boringssl.googlesource.com/boringssl.git/+archive/${BORINGSSL_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/libvpx-${LIBVPX_REV}.tar.gz \
#	https://chromium.googlesource.com/webm/libvpx.git/+archive/${LIBVPX_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/webrtc-${WEBRTC_REV}.tar.gz \
#	https://github.com/signalapp/webrtc/archive/refs/tags/${WEBRTC_REV}.tar.gz
#${FETCH_CMD} -o ${DISTDIR}/ringrtc-${RINGRTC_REV}.tar.gz \
#	https://github.com/signalapp/ringrtc/archive/refs/tags/v${RINGRTC_REV}.tar.gz

#${FETCH_CMD} -o ${DISTDIR}/benchmark-${BENCHMARK_REV}.tar.gz \
#	https://chromium.googlesource.com/external/github.com/google/benchmark.git/+archive/${BENCHMARK_REV}.tar.gz

#Extract
${TAR} xf ${DISTDIR}/ringrtc-${RINGRTC_REV}.tar.gz
${MKDIR} -p ringrtc-${RINGRTC_REV}/src/webrtc
${TAR} xf ${DISTDIR}/webrtc-${WEBRTC_REV}.tar.gz
${MV} webrtc-${WEBRTC_REV} ringrtc-${RINGRTC_REV}/src/webrtc/src

${MKDIR} -p \
        ${WRKSRC}/base \
        ${WRKSRC}/build \
        ${WRKSRC}/buildtools \
        ${WRKSRC}/third_party \
        ${WRKSRC}/third_party/icu \
        ${WRKSRC}/third_party/libyuv \
        ${WRKSRC}/third_party/libsrtp \
        ${WRKSRC}/third_party/libvpx/source/libvpx \
        ${WRKSRC}/third_party/libjpeg_turbo \
        ${WRKSRC}/third_party/nasm \
        ${WRKSRC}/third_party/catapult \
        ${WRKSRC}/third_party/boringssl/src \
        ${WRKSRC}/testing

#        ${WRKSRC}/third_party/google_benchmark \

${TAR} -xf ${DISTDIR}/testing-${TESTING_REV}.tar.gz -C ${WRKSRC}/testing
${TAR} -xf ${DISTDIR}/base-${BASE_REV}.tar.gz -C ${WRKSRC}/base
${TAR} -xf ${DISTDIR}/build-${BUILD_REV}.tar.gz -C ${WRKSRC}/build
${TAR} -xf ${DISTDIR}/buildtools-${BUILDTOOLS_REV}.tar.gz -C ${WRKSRC}/buildtools
${TAR} -xf ${DISTDIR}/thirdparty-${THIRDPARTY_REV}.tar.gz -C ${WRKSRC}/third_party
${TAR} -xf ${DISTDIR}/icu-${ICU_REV}.tar.gz -C ${WRKSRC}/third_party/icu
${TAR} -xf ${DISTDIR}/libyuv-${LIBYUV_REV}.tar.gz -C ${WRKSRC}/third_party/libyuv
${TAR} -xf ${DISTDIR}/libsrtp-${LIBSRTP_REV}.tar.gz -C ${WRKSRC}/third_party/libsrtp
${TAR} -xf ${DISTDIR}/libvpx-${LIBVPX_REV}.tar.gz -C ${WRKSRC}/third_party/libvpx/source/libvpx
${TAR} -xf ${DISTDIR}/libjpeg_turbo-${LIBJPEG_REV}.tar.gz -C ${WRKSRC}/third_party/libjpeg_turbo
${TAR} -xf ${DISTDIR}/nasm-${NASM_REV}.tar.gz -C ${WRKSRC}/third_party/nasm
${TAR} -xf ${DISTDIR}/catapult-${CATAPULT_REV}.tar.gz -C ${WRKSRC}/third_party/catapult
${TAR} -xf ${DISTDIR}/boringssl-${BORINGSSL_REV}.tar.gz -C ${WRKSRC}/third_party/boringssl/src

#${TAR} -xf ${DISTDIR}/benchmark-${BENCHMARK_REV}.tar.gz -C ${WRKSRC}/third_party/google_benchmark

${ECHO} "# Generated from 'DEPS'" > ${RINGRTC_REV}/src/webrtc/src/build/config/gclient_args.gni
${ECHO} 1591703586 > ${RINGRTC_REV}/src/webrtc/src/build/util/LASTCHANGE.committime
${ECHO} "qqchose " > ${RINGRTC_REV}/src/webrtc/src/build/util/LASTCHANGE

# Patch
patches="patch-build_config_BUILD.gn
patch-build_config_BUILDCONFIG.gn
patch-build_config_compiler_BUILD.gn
patch-build_config_compiler_compiler.gni
patch-build_config_features.gni
patch-build_config_freetype_freetype.gni
patch-build_config_linux_BUILD.gn
patch-build_config_linux_pkg-config.py
patch-build_config_rust.gni
patch-build_config_sysroot.gni
patch-build_detect__host__arch.py
patch-build_gn__run__binary.py
patch-build_linux_chrome.map
patch-build_linux_libpci_BUILD.gn
patch-build_linux_unbundle_libusb.gn
patch-build_linux_unbundle_replace__gn__files.py
patch-build_toolchain_gcc__toolchain.gni
patch-build_toolchain_get__concurrent__links.py
patch-build_toolchain_linux_BUILD.gn
patch-buildtools_third__party_libc++_BUILD.gn"

for p in ${patches}
do
	echo $p
	patch -Cs -d ringrtc-${RINGRTC_REV}/src/webrtc/src -i ../../../../patches/${p}
done

patches="patch-src_webrtc_src_base_third__party_libevent_BUILD.gn
patch-src_webrtc_src_BUILD.gn
patch-src_webrtc_src_modules_rtp__rtcp_source_forward__error__correction.cc
patch-src_webrtc_src_modules_video__capture_BUILD.gn
patch-src_webrtc_src_rtc__base_byte__order.h
patch-src_webrtc_src_rtc__base_ifaddrs__converter.h
patch-src_webrtc_src_rtc__base_ip__address.cc
patch-src_webrtc_src_rtc__base_ip__address.h
patch-src_webrtc_src_rtc__base_network.cc
patch-src_webrtc_src_rtc__base_network.h
patch-src_webrtc_src_rtc__base_physical__socket__server.cc
patch-src_webrtc_src_rtc__base_physical__socket__server.h
patch-src_webrtc_src_rtc__base_platform__thread__types.cc
patch-src_webrtc_src_rtc__base_third__party_sigslot_sigslot.h
patch-src_webrtc_src_system__wrappers_BUILD.gn
patch-src_webrtc_src_third__party_nasm_config_config-linux.h
patch-src_webrtc_src_third__party_opus_BUILD.gn"

for p in $patches
do
	echo $p
	patch -p5 -Cs -d ringrtc-${RINGRTC_REV}/src/webrtc/src -i ../../../../ports_patches/$p
done

# Build
cd ringrtc-${RINGRTC_REV}/src/webrtc/src
gn gen out/Release --args='rtc_build_examples=false rtc_build_tools=false rtc_include_tests=false rtc_enable_protobuf=false rtc_use_x11=false rtc_enable_sctp=false rtc_libvpx_build_vp9=false rtc_include_ilbc=false use_custom_libcxx=false is_debug=false is_clang=true clang_use_chrome_plugins=false extra_cxxflags="-isystem /usr/local/include" extra_ldflags="-L/usr/local/lib"'
ninja -C out/Release

cd ringrtc-${RINGRTC_REV}/src/rust
cargo build --release
