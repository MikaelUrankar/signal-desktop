XXX try to set ELECTRON_OVERRIDE_DIST_PATH instead?

--- node_modules/electron/index.js.orig	2021-03-16 18:36:23.069412000 +0100
+++ node_modules/electron/index.js	2021-03-16 18:36:42.992382000 +0100
@@ -4,6 +4,7 @@ var path = require('path')
 var pathFile = path.join(__dirname, 'path.txt')
 
 function getElectronPath () {
+  return path.join("/usr/local/share/electron11/electron")
   if (fs.existsSync(pathFile)) {
     var executablePath = fs.readFileSync(pathFile, 'utf-8')
     if (process.env.ELECTRON_OVERRIDE_DIST_PATH) {
