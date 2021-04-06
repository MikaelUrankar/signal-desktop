#!/bin/sh
FETCH_CMD=fetch
DISTDIR=/tmp

BASE_HASH=2df7267880bf7d4086d55c0e56cd72c394bfda36
BORINGSSL_HASH=88024df12147e56b6abd66b743ff441a0aaa09a8
BUILD_HASH=a03951acb996e9cea78b4ab575896bf1bfcd9668
BUILDTOOLS_HASH=1b066f021638735d72aa799ae6bc37e0b8963c67
CATAPULT_HASH=2ad47493f833c5191f56c74d3f1aac10e7c105e8
ICU_HASH=630b884f84d1d5e92aeda3463dca99fe2befd30e
LIBJPEG_HASH=7e3ad79800a7945fb37173149842b494ab8982b2
LIBSRTP_HASH=650611720ecc23e0e6b32b0e3100f8b4df91696c
LIBVPX_HASH=c1765573149e2c0fe2acabc224c0f9085b9e7f2b
LIBYUV_HASH=6afd9becdf58822b1da6770598d8597c583ccfad
NASM_HASH=4fa54ca5f7fc3a15a8c78ac94688e64d3e4e4fa1
THIRDPARTY_HASH=e0df6e10adc084f88dda51c0cbab84645db6c135
TESTING_HASH=502600d41a00af23dd09e02ea358061e3c951634

cd /tmp

${FETCH_CMD} -o base.tar.gz https://chromium.googlesource.com/chromium/src/base.git/+archive/${BASE_HASH}.tar.gz
${FETCH_CMD} -o boringssl.tar.gz https://boringssl.googlesource.com/boringssl.git/+archive/${BORINGSSL_HASH}.tar.gz
${FETCH_CMD} -o build.tar.gz https://chromium.googlesource.com/chromium/src/build.git/+archive/${BUILD_HASH}.tar.gz
${FETCH_CMD} -o buildtools.tar.gz https://chromium.googlesource.com/chromium/src/buildtools.git/+archive/${BUILDTOOLS_HASH}.tar.gz
${FETCH_CMD} -o catapult.tar.gz https://chromium.googlesource.com/catapult.git/+archive/${CATAPULT_HASH}.tar.gz
${FETCH_CMD} -o icu.tar.gz https://chromium.googlesource.com/chromium/deps/icu.git/+archive/${ICU_HASH}.tar.gz
${FETCH_CMD} -o libjpeg_turbo.tar.gz https://chromium.googlesource.com/chromium/deps/libjpeg_turbo.git/+archive/${LIBJPEG_HASH}.tar.gz
${FETCH_CMD} -o libsrtp.tar.gz https://chromium.googlesource.com/chromium/deps/libsrtp.git/+archive/${LIBSRTP_HASH}.tar.gz
${FETCH_CMD} -o libvpx.tar.gz https://chromium.googlesource.com/webm/libvpx.git/+archive/${LIBVPX_HASH}.tar.gz
${FETCH_CMD} -o libyuv.tar.gz https://chromium.googlesource.com/libyuv/libyuv.git/+archive/${LIBYUV_HASH}.tar.gz
${FETCH_CMD} -o nasm.tar.gz https://chromium.googlesource.com/chromium/deps/nasm.git/+archive/${NASM_HASH}.tar.gz
${FETCH_CMD} -o third_party.tar.gz https://chromium.googlesource.com/chromium/src/third_party.git/+archive/${THIRDPARTY_HASH}.tar.gz
${FETCH_CMD} -o testing.tar.gz https://chromium.googlesource.com/chromium/src/testing.git/+archive/${TESTING_HASH}.tar.gz

for i in base boringssl build buildtools catapult icu libjpeg_turbo libsrtp libvpx libyuv nasm third_party testing
do
	mkdir ${i}
	tar xf ${i}.tar.gz -C ${i}
done
tar cjf base-${BASE_HASH}.tar.gz base
tar cjf boringssl-${BORINGSSL_HASH}
tar cjf build-${BUILD_HASH}
tar cjf buildtools-${BUILDTOOLS_HASH}
tar cjf catapult-${CATAPULT_HASH}
tar cjf icu-${ICU_HASH}
tar cjf libjpeg_turbo-${LIBJPEG_HASH}
tar cjf libsrtp-${LIBSRTP_HASH}
tar cjf libvpx-${LIBVPX_HASH}
tar cjf libyuv-${LIBYUV_HASH}
tar cjf nasm-${NASM_HASH}
tar cjf third_party-${THIRDPARTY_HASH}
tar cjf testing-${TESTING_HASH}

fetch http://mikael.urankar.free.fr/ringrtc/signalapp-npm-offline-cache.tar.gz
fetch http://mikael.urankar.free.fr/ringrtc/signalapp-electron-gyp.tar.gz
