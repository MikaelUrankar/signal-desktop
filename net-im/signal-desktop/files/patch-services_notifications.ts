--- ts/services/notifications.ts.orig	2025-05-23 12:14:12.582421000 +0200
+++ ts/services/notifications.ts	2025-05-23 12:14:29.526852000 +0200
@@ -196,7 +196,7 @@ class NotificationService extends EventEmitter {
       this.#lastNotification?.close();
 
       const notification = new window.Notification(title, {
-        body: OS.isLinux() ? filterNotificationText(message) : message,
+        body: (OS.isLinux() || OS.isFreeBSD()) ? filterNotificationText(message) : message,
         icon: iconUrl,
         silent: true,
         tag: messageId,
