--- ts/util/os/osMain.ts.orig	2025-05-23 14:04:11.448890000 +0200
+++ ts/util/os/osMain.ts	2025-05-23 14:04:49.883396000 +0200
@@ -6,7 +6,7 @@ function getLinuxName(): string | undefined {
 import { getOSFunctions } from './shared';
 
 function getLinuxName(): string | undefined {
-  if (os.platform() !== 'linux') {
+  if (os.platform() !== 'freebsd') {
     return undefined;
   }
 
@@ -24,7 +24,7 @@ function isLinuxUsingKDE(): boolean {
 }
 
 function isLinuxUsingKDE(): boolean {
-  return os.platform() === 'linux' && process.env.XDG_CURRENT_DESKTOP === 'KDE';
+  return os.platform() === 'freebsd' && process.env.XDG_CURRENT_DESKTOP === 'KDE';
 }
 
 const OS = {
