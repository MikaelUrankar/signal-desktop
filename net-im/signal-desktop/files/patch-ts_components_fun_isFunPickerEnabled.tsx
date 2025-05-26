--- ./ts/components/fun/isFunPickerEnabled.tsx.orig	2025-05-26 15:01:58.189474000 +0200
+++ ./ts/components/fun/isFunPickerEnabled.tsx	2025-05-26 14:59:32.080186000 +0200
@@ -3,5 +3,5 @@ export function isFunPickerEnabled(): boolean {
 import * as RemoteConfig from '../../RemoteConfig';
 
 export function isFunPickerEnabled(): boolean {
-  return RemoteConfig.isEnabled('desktop.funPicker');
+  return RemoteConfig.isEnabled('desktop.funPicker.prod');
 }
