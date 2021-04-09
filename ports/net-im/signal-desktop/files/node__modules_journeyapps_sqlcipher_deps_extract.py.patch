--- node_modules/@journeyapps/sqlcipher/deps/extract.py.orig	2021-04-02 17:23:53.779243000 +0200
+++ node_modules/@journeyapps/sqlcipher/deps/extract.py	2021-04-02 17:37:30.113054000 +0200
@@ -1,9 +1,20 @@
 import sys
 import tarfile
 import os
+import shutil
 
 tarball = os.path.abspath(sys.argv[1])
 dirname = os.path.abspath(sys.argv[2])
+openssl_dir = os.path.join(dirname, "sqlcipher-amalgamation-3033000", "OpenSSL-FreeBSD")
 tfile = tarfile.open(tarball,'r:gz');
 tfile.extractall(dirname)
+
+os.mkdir(openssl_dir)
+
+try:
+    shutil.copyfile(os.path.join("/usr", "local", "lib", "libcrypto.a"), os.path.join(openssl_dir, "libcrypto.a"))
+except:
+    print("Unexpected error:", sys.exc_info())
+    sys.exit(1)
+
 sys.exit(0)
