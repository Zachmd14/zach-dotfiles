;; 1. Increase GC threshold to prevent stuttering during startup
;; Temporarily increase GC threshold during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Restore to normal value after startup (e.g. 50MB)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 50 1024 1024))))

;; 2. Defer file handler loading for speed
(setq file-name-handler-alist nil)

;; 3. Restore defaults after initialization
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 800000) ;; Reset to 800kb
            (defvar file-name-handler-alist default-file-name-handler-alist)))

;; 4. Improve UI performance by disabling early window decorations
(setq frame-inhibit-implied-resize t)
(setq inhibit-compacting-font-caches t)
