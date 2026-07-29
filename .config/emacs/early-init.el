;; ============================================================================
;; EARLY-INIT.EL — Performance optimizations loaded before package init
;; ============================================================================

;; ---------------------------------------------------------------------------
;; GC threshold — temporarily boost during startup to avoid stutter
;; ---------------------------------------------------------------------------
(setq gc-cons-threshold most-positive-fixnum)

(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 50 1024 1024))))

;; ---------------------------------------------------------------------------
;; File handler — defer loading during startup
;; ---------------------------------------------------------------------------
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 800000)
            (setq file-name-handler-alist default-file-name-handler-alist)))

;; ---------------------------------------------------------------------------
;; UI performance — disable early window decorations
;; ---------------------------------------------------------------------------
(setq frame-inhibit-implied-resize t)
(setq inhibit-compacting-font-caches t)
