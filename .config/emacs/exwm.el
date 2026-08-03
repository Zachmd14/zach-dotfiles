;; ============================================================================
;; EXWM.EL — EXWM Window Manager Configuration for Emacs
;; ============================================================================

;; ---------------------------------------------------------------------------
;; GPG / Pinentry via Emacs
;; ---------------------------------------------------------------------------
(setf epg-pinentry-mode 'loopback)
(defun pinentry-emacs (desc prompt ok error)
  (let ((str (read-passwd
              (concat (replace-regexp-in-string
                       "%22" "\""
                       (replace-regexp-in-string "%0A" "\n" desc))
                      prompt ": "))))
    str))

;; ---------------------------------------------------------------------------
;; System packages — Volume, Backlight
;; ---------------------------------------------------------------------------
(use-package volume   :ensure t)
(use-package backlight :ensure t)

(defun get-brightness-percentage ()
  "Get screen brightness as a percentage from sysfs."
  (interactive)
  (let* ((backlight-dir (car (directory-files "/sys/class/backlight" t "^[^.]")))
         (brightness-file (concat backlight-dir "/brightness"))
         (max-brightness-file (concat backlight-dir "/max_brightness"))
         (current (string-to-number (with-temp-buffer
                                      (insert-file-contents brightness-file)
                                      (buffer-string))))
         (max (string-to-number (with-temp-buffer
                                  (insert-file-contents max-brightness-file)
                                  (buffer-string))))
         (percentage (if (> max 0)
                         (round (* 100.0 (/ (float current) (float max))))
                       0)))
    (message "Brightness: %d%%" percentage)
    percentage))

;; ---------------------------------------------------------------------------
;; Notifications — Dunst
;; ---------------------------------------------------------------------------
(add-hook 'exwm-init-hook
          (lambda ()
            (start-process-shell-command "dunst" nil "dunst")))

;; ---------------------------------------------------------------------------
;; Multi-monitor — EXWM Randr
;; ---------------------------------------------------------------------------
(require 'exwm-randr)
(exwm-randr-mode)

(setq exwm-randr-workspace-monitor-plist
      '(0 "HDMI2" 1 "HDMI2"   2 "DP1"   3 "DP1"   4 "DP1"
          5 "DP1" 6 "DP1" 7 "DP1" 8 "DP1" 9 "DP1"))

(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (let* ((connected (shell-command-to-string
                               "xrandr | grep ' connected' | awk '{print $1}'"))
                   (screens   (split-string connected "\n" t))
                   (has-dp1   (member "DP1"   screens))
                   (has-hdmi2 (member "HDMI2" screens)))
              (cond
               ((and has-dp1 has-hdmi2)
                (start-process-shell-command "xrandr" nil
					     "xrandr --output eDP1 --off \
                          --output DP1 --primary --auto \
                          --output HDMI2 --left-of DP1 --rotate left --auto"))
               (has-dp1
                (start-process-shell-command "xrandr" nil
					     "xrandr --output eDP1 --primary --auto \
                          --output DP1 --right-of eDP1 --auto \
                          --output HDMI2 --off"))
               (has-hdmi2
                (start-process-shell-command "xrandr" nil
					     "xrandr --output eDP1 --primary --auto \
                          --output HDMI2 --left-of eDP1 --auto \
                          --output DP1 --off"))
               (t
                (start-process-shell-command "xrandr" nil
					     "xrandr --output eDP1 --primary --auto \
                          --output DP1 --off \
                          --output HDMI2 --off"))))))

;; ---------------------------------------------------------------------------
;; EXWM Core — workspace, keybindings, simulation keys, helm
;; ---------------------------------------------------------------------------
(use-package exwm
  :ensure t
  :config

  ;; Workspaces
  (setq exwm-workspace-number 10)

  (setq exwm-workspace-warp-cursor t)

  (setq mouse-autoselect-window nil
	focus-follows-mouse nil)

  (setq exwm-layout-show-all-buffers t)
  (setq exwm-workspace-show-all-buffers t)

  ;; Buffer naming — class name
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))

  ;; Buffer naming — browser tab title
  (add-hook 'exwm-update-title-hook
            (lambda ()
              (when (or (not exwm-instance-name)
                        (string-prefix-p "chromium" exwm-instance-name)
                        (string-prefix-p "firefox"  exwm-instance-name)
                        (string-prefix-p "brave"    exwm-instance-name))
                (exwm-workspace-rename-buffer exwm-title))))

  ;; xmodmap — apply once on first window
  (defun my/exwm-apply-xmodmap ()
    (start-process "xmodmap" nil "xmodmap"
                   (expand-file-name "~/.Xmodmap.exwm"))
    (remove-hook 'exwm-manage-finish-hook #'my/exwm-apply-xmodmap))
  (add-hook 'exwm-manage-finish-hook #'my/exwm-apply-xmodmap)

  ;; Window dividers for mouse resize
  (setq window-divider-default-bottom-width 2
	window-divider-default-right-width  2)
  (window-divider-mode)

  ;; Mode line — line-mode / char-mode indicator
  (add-hook 'exwm-input--input-mode-change-hook #'force-mode-line-update)

  (use-package exwm-modeline)
  (add-hook 'exwm-init-hook #'exwm-modeline-mode)

  (defun my/exwm-mode-line-input-mode ()
    (when (eq major-mode 'exwm-mode)
      (if (bound-and-true-p exwm--input-mode)
          (if (eq exwm--input-mode 'char-mode) " [CHAR]" " [LINE]")
	"")))

  (unless (member '(:eval (my/exwm-mode-line-input-mode)) mode-line-format)
    (setq-default mode-line-format
                  (append mode-line-format
                          '((:eval (my/exwm-mode-line-input-mode))))))

  ;; Global keybindings — Super key prefix
  (setq exwm-input-global-keys
	`(
          ;; Keyboard mode toggle
          (,(kbd "s-i") . exwm-input-toggle-keyboard)

          ;; Close X11 window
          (,(kbd "s-c") . (lambda () (interactive)
                            (kill-buffer (current-buffer))))

          ;; Media keys
          (,(kbd "<XF86AudioNext>") . (lambda () (interactive)
                                        (playerctl-next-song)))
          (,(kbd "<XF86AudioPrev>") . (lambda () (interactive)
                                        (playerctl-previous-song)))

          ;; Volume
          (,(kbd "<XF86AudioRaiseVolume>") . (lambda () (interactive)
                                               (volume-raise-10)))
          (,(kbd "<XF86AudioLowerVolume>") . (lambda () (interactive)
                                               (volume-lower-10)))
          (,(kbd "<XF86AudioMute>")        . (lambda () (interactive)
                                               (volume-minimize)))
          (,(kbd "s-<XF86AudioMute>")        . (lambda () (interactive)
						 (volume-maximise)))

          ;; Brightness
	  (,(kbd "<XF86MonBrightnessUp>")   . (lambda () (interactive)
						(backlight-inc, 151)
						(get-brightness-percentage)))
	  (,(kbd "<XF86MonBrightnessDown>") . (lambda () (interactive)
						(backlight-dec, 151)
						(get-brightness-percentage)))
          (,(kbd "s-<XF86MonBrightnessDown>") . (lambda () (interactive)
                                                  (backlight-set-raw)))

	  ;; WiFi
	  (,(kbd "<XF86Tools>") . (lambda () (interactive)
				    (my/wifi-menu)))

          ;; Workspaces 0-9
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
			(lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))

          ;; App launcher
          (,(kbd "s-o") . (lambda () (interactive)
                            (if (fboundp 'counsel-linux-app)
                                (counsel-linux-app)
			      (start-process "dmenu" nil "dmenu_run"))))

          ;; Terminal
          (,(kbd "s-<return>") . (lambda () (interactive)
				   (my/open-new-vterm)))

          ;; Browser
          (,(kbd "s-b") . (lambda () (interactive)
                            (browse-url-xdg-open "about:blank")))

          ;; Emacs window splits
          (,(kbd "s-v") . split-window-right)
          (,(kbd "s-s") . split-window-below)
          (,(kbd "s-q") . delete-window)

          ;; Emacs window resize
          (,(kbd "s-=") . (lambda () (interactive) (enlarge-window-horizontally 5)))
          (,(kbd "s--") . (lambda () (interactive) (shrink-window-horizontally 5)))
          (,(kbd "s-+") . (lambda () (interactive) (enlarge-window 5)))
          (,(kbd "s-_") . (lambda () (interactive) (shrink-window 5)))

          ;; Window navigation
          (,(kbd "s-l") . windmove-right)
          (,(kbd "s-j") . windmove-down)
          (,(kbd "s-k") . windmove-up)
          (,(kbd "s-h") . windmove-left)

          ;; Fullscreen / floating
          (,(kbd "s-f") . exwm-layout-toggle-fullscreen)
          (,(kbd "s-t") . exwm-floating-toggle-floating)

          ;; Quit EXWM
          (,(kbd "s-Q") . (lambda () (interactive)
                            (when (yes-or-no-p "Quitter EXWM ? ")
                              (kill-emacs))))))

  ;; Simulation keys — Hyper (remapped Caps Lock) for X11 apps
  (setq exwm-input-simulation-keys
	`((,(kbd "H-b") . [left])
          (,(kbd "H-f") . [right])
          (,(kbd "H-p") . [up])
          (,(kbd "H-n") . [down])
          (,(kbd "H-a") . [home])
          (,(kbd "H-e") . [end])
          (,(kbd "H-d") . [delete])
          (,(kbd "H-k") . [S-end delete])
          (,(kbd "H-w") . [?\C-c])
          (,(kbd "H-y") . [?\C-v])))

  ;; helm-exwm — EXWM buffer management
  (use-package helm-exwm
    :ensure t
    :config
    (setq helm-exwm-emacs-buffers-source (helm-exwm-build-emacs-buffers-source))
    (setq helm-exwm-source              (helm-exwm-build-source))
    (setq helm-mini-default-sources
          `(helm-exwm-emacs-buffers-source
            helm-exwm-source
            helm-source-recentf))))

;; ---------------------------------------------------------------------------
;; Custom
;; ---------------------------------------------------------------------------
(add-to-list 'exwm-manage-configurations
  '((string-match "mouseless_overlay" exwm-title) floating t))

;; ---------------------------------------------------------------------------
;; Startup — safely initialize EXWM when the first graphical frame is ready
;; ---------------------------------------------------------------------------
(defun my/run-exwm-once-started ()
  "Safely initialize exwm when the first graphical frame is ready."
  (run-with-timer 0.5 nil
		  (lambda ()
		    (exwm-wm-mode 1)))
  (remove-hook 'server-after-make-frame-hook #'my/run-exwm-once-started))
(add-hook 'server-after-make-frame-hook #'my/run-exwm-once-started)
