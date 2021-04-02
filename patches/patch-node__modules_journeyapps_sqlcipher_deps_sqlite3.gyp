--- node_modules/@journeyapps/sqlcipher/deps/sqlite3.gyp.orig	2021-04-02 16:43:23.149414000 +0200
+++ node_modules/@journeyapps/sqlcipher/deps/sqlite3.gyp	2021-04-02 16:45:13.158254000 +0200
@@ -69,6 +69,14 @@
           ]
         }
       },
+      'OS == "freebsd"', {
+        'link_settings': {
+          'libraries': [
+            # This statically links libcrypto, whereas -lcrypto would dynamically link it
+            '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgamation-<@(sqlite_version)/OpenSSL-FreeBSD/libcrypto.a'
+          ]
+        }
+      },
       { # Linux
         'link_settings': {
           'libraries': [
@@ -94,7 +102,7 @@
           'outputs': [
             '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgamation-<@(sqlite_version)/sqlite3.c'
           ],
-          'action': ['python','./extract.py','./sqlcipher-amalgamation-<@(sqlite_version).tar.gz','<(SHARED_INTERMEDIATE_DIR)']
+          'action': ['python2.7','./extract.py','./sqlcipher-amalgamation-<@(sqlite_version).tar.gz','<(SHARED_INTERMEDIATE_DIR)']
         }
       ],
       'direct_dependent_settings': {
@@ -133,6 +141,12 @@
           ]
         },
         "OS == \"mac\"", {
+          'include_dirs': [
+            '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgamation-<@(sqlite_version)/',
+            '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgamation-<@(sqlite_version)/openssl-include/'
+          ]
+        },
+        "OS == \"freebsd\"", {
           'include_dirs': [
             '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgamation-<@(sqlite_version)/',
             '<(SHARED_INTERMEDIATE_DIR)/sqlcipher-amalgamation-<@(sqlite_version)/openssl-include/'
