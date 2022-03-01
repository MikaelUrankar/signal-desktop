--- base/native_library_unittest.cc.orig	2021-01-07 00:36:18 UTC
+++ base/native_library_unittest.cc
@@ -118,7 +118,7 @@ TEST(NativeLibraryTest, LoadLibrary) {
 // Android dlopen() requires further investigation, as it might vary across
 // versions with respect to symbol resolution scope.
 // TSan and MSan error out on RTLD_DEEPBIND, https://crbug.com/705255
-#if !defined(OS_ANDROID) && !defined(THREAD_SANITIZER) && \
+#if !defined(OS_ANDROID) && !defined(OS_BSD) && !defined(THREAD_SANITIZER) && \
     !defined(MEMORY_SANITIZER)
 
 // Verifies that the |prefer_own_symbols| option satisfies its guarantee that
