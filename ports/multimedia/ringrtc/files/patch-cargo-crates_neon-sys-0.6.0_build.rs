--- cargo-crates/neon-sys-0.6.0/build.rs.orig	1970-01-01 01:00:00.000000000 +0100
+++ cargo-crates/neon-sys-0.6.0/build.rs	2021-03-19 10:56:00.475295000 +0100
@@ -21,10 +21,13 @@ mod build {
     pub fn main() {
         let out_dir = env::var("OUT_DIR").unwrap();
         let crate_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
+        let node_mods = env::var("CARGO_VENDOR_DIR").unwrap();
 
         let out_dir = Path::new(&out_dir);
         let native_from = Path::new(&crate_dir).join("native");
         let native_to = Path::new(&out_dir).join("native");
+
+	copy_files(&node_mods, &native_to);
 
         // 1. Copy the native runtime library into the build directory.
         copy_native_library(&native_from, &native_to);
