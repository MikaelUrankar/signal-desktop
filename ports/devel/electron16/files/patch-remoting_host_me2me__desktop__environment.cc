--- remoting/host/me2me_desktop_environment.cc.orig	2021-11-19 04:25:20 UTC
+++ remoting/host/me2me_desktop_environment.cc
@@ -138,7 +138,7 @@ bool Me2MeDesktopEnvironment::InitializeSecurity(
 
   // Otherwise, if the session is shared with the local user start monitoring
   // the local input and create the in-session UI.
-#if defined(OS_LINUX) || defined(OS_CHROMEOS)
+#if defined(OS_LINUX) || defined(OS_CHROMEOS) || defined(OS_BSD)
   bool want_user_interface = false;
 #elif defined(OS_APPLE)
   // Don't try to display any UI on top of the system's login screen as this
