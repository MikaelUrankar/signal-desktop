--- ts/scripts/copy-language-packs.ts.orig	2022-12-04 09:58:27.360570000 +0100
+++ ts/scripts/copy-language-packs.ts	2022-12-04 09:58:40.984537000 +0100
@@ -31,6 +31,7 @@ export async function afterPack({
       'Resources'
     );
   } else if (
+    electronPlatformName === 'freebsd' ||
     electronPlatformName === 'linux' ||
     electronPlatformName === 'win32'
   ) {
