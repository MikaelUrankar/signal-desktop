--- services/network/network_context.cc.orig	2021-12-18 06:49:11 UTC
+++ services/network/network_context.cc
@@ -2582,7 +2582,7 @@ NetworkContext::MakeSessionCleanupCookieStore() const 
 
   net::CookieCryptoDelegate* crypto_delegate = nullptr;
   if (params_->enable_encrypted_cookies) {
-#if (defined(OS_LINUX) || BUILDFLAG(IS_CHROMEOS_LACROS)) && \
+#if (defined(OS_LINUX) || BUILDFLAG(IS_CHROMEOS_LACROS) || defined(OS_BSD)) && \
     !BUILDFLAG(IS_CHROMECAST)
     DCHECK(network_service_->os_crypt_config_set())
         << "NetworkService::SetCryptConfig must be called before creating a "