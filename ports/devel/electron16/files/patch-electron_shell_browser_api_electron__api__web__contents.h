--- electron/shell/browser/api/electron_api_web_contents.h.orig	2022-01-27 17:43:12 UTC
+++ electron/shell/browser/api/electron_api_web_contents.h
@@ -707,7 +707,7 @@ class WebContents : public ExclusiveAccessContext,
 #if defined(TOOLKIT_VIEWS) && !defined(OS_MAC)
   ui::ImageModel GetDevToolsWindowIcon() override;
 #endif
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) || defined(OS_BSD)
   void GetDevToolsWindowWMClass(std::string* name,
                                 std::string* class_name) override;
 #endif
