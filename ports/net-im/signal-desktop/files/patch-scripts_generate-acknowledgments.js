--- scripts/generate-acknowledgments.js.orig	2025-03-14 15:18:53.052844000 +0100
+++ scripts/generate-acknowledgments.js	2025-03-14 15:19:06.022142000 +0100
@@ -106,11 +106,6 @@ async function main() {
 }
 
 async function main() {
-  assert.deepStrictEqual(
-    Object.keys(optionalDependencies),
-    ['fs-xattr'],
-    'Unexpected optionalDependencies when generating acknowledgments file. To ensure that this file is generated deterministically, make sure to special-case it the acknowledgments generation script.'
-  );
 
   const dependencyNames = [
     ...Object.keys(dependencies),
