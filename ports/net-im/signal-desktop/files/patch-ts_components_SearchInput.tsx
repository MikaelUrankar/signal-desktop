--- ts/components/SearchInput.tsx.orig	2022-12-04 09:59:26.653818000 +0100
+++ ts/components/SearchInput.tsx	2022-12-04 09:59:58.177111000 +0100
@@ -67,7 +67,7 @@ export const SearchInput = forwardRef<HTMLInputElement
             const { ctrlKey, key } = event;
 
             // On Linux, this key combo selects all text.
-            if (window.platform === 'linux' && ctrlKey && key === '/') {
+            if ((window.platform === 'freebsd' || window.platform === 'linux') && ctrlKey && key === '/') {
               event.preventDefault();
               event.stopPropagation();
             } else if (key === 'Escape' && onClear) {
