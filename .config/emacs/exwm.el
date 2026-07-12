;; =============================================================
;; exwm.el — EXWM configuration for Zachary's Emacs
;; Compatible avec Evil + Ivy + init.el existants
;; =============================================================

;; ------------------------------------------------------------
;; 1. GPG / Pinentry via Emacs
;; ------------------------------------------------------------
(setf epg-pinentry-mode 'loopback)
(defun pinentry-emacs (desc prompt ok error)
  (let ((str (read-passwd
              (concat (replace-regexp-in-string
                       "%22" "\""
                       (replace-regexp-in-string "%0A" "\n" desc))
                      prompt ": "))))
    str))

;; ------------------------------------------------------------
;; 2. Packages système requis par EXWM
;; ------------------------------------------------------------
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
         ;; FIXED: Use floating-point division before rounding
         (percentage (if (> max 0)
                         (round (* 100.0 (/ (float current) (float max))))
                       0)))
    (message "Brightness: %d%%" percentage)
    percentage))

;; Start dunst after EXWM initializes
(add-hook 'exwm-init-hook
          (lambda ()
            (start-process-shell-command "dunst" nil "dunst")))
;; ------------------------------------------------------------
;; 3. exwm-randr — gestion multi-écrans dynamique
;; ------------------------------------------------------------
(require 'exwm-randr)
(exwm-randr-mode)

;; Assigner les workspaces aux moniteurs
;; workspaces 1-4 → DP-1, 5-7 → HDMI-2, reste → eDP-1
;; (setq exwm-randr-workspace-monitor-plist
;;       '(0 "eDP-1" 1 "eDP-1"   2 "DP-1"   3 "DP-1"   4 "DP-1"
;;           5 "DP-1" 6 "DP-1" 7 "HDMI-2" 8 "HDMI-2" 9 "HDMI-2"))
(setq exwm-randr-workspace-monitor-plist
      '(0 "HDMI-2" 1 "HDMI-2"   2 "DP-1"   3 "DP-1"   4 "DP-1"
          5 "DP-1" 6 "DP-1" 7 "DP-1" 8 "DP-1" 9 "DP-1"))

;; (add-hook 'exwm-randr-screen-change-hook
;;           (lambda ()
;;             (let* ((connected (shell-command-to-string
;;                                "xrandr | grep ' connected' | awk '{print $1}'"))
;;                    (screens   (split-string connected "\n" t))
;;                    (has-dp1   (member "DP-1"   screens))
;;                    (has-hdmi2 (member "HDMI-2" screens)))
;;               (cond
;;                ;; 3 écrans
;;                ((and has-dp1 has-hdmi2)
;;                 (start-process-shell-command "xrandr" nil
;; 					     "xrandr --output eDP-1 --primary --auto \
;;                           --output DP-1 --right-of eDP-1 --auto \
;;                           --output HDMI-2 --right-of DP-1 --auto"))
;;                ;; laptop + DP-1
;;                (has-dp1
;;                 (start-process-shell-command "xrandr" nil
;; 					     "xrandr --output eDP-1 --primary --auto \
;;                           --output DP-1 --right-of eDP-1 --auto \
;;                           --output HDMI-2 --off"))
;;                ;; laptop + HDMI-2
;;                (has-hdmi2
;;                 (start-process-shell-command "xrandr" nil
;; 					     "xrandr --output eDP-1 --primary --auto \
;;                           --output HDMI-2 --right-of eDP-1 --auto \
;;                           --output DP-1 --off"))
;;                ;; laptop seul
;;                (t
;;                 (start-process-shell-command "xrandr" nil
;; 					     "xrandr --output eDP-1 --primary --auto \
;;                           --output DP-1 --off \
;;                           --output HDMI-2 --off"))))))
(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (let* ((connected (shell-command-to-string
                               "xrandr | grep ' connected' | awk '{print $1}'"))
                   (screens   (split-string connected "\n" t))
                   (has-dp1   (member "DP-1"   screens))
                   (has-hdmi2 (member "HDMI-2" screens)))
              (cond
               ;; 2 écrans externes : eDP-1 off, HDMI-2 vertical à gauche de DP-1
               ((and has-dp1 has-hdmi2)
                (start-process-shell-command "xrandr" nil
					     "xrandr --output eDP-1 --off \
                          --output DP-1 --primary --auto \
                          --output HDMI-2 --left-of DP-1 --rotate left --auto"))
               ;; laptop + DP-1
               (has-dp1
                (start-process-shell-command "xrandr" nil
					     "xrandr --output eDP-1 --primary --auto \
                          --output DP-1 --right-of eDP-1 --auto \
                          --output HDMI-2 --off"))
               ;; laptop + HDMI-2
               (has-hdmi2
                (start-process-shell-command "xrandr" nil
					     "xrandr --output eDP-1 --primary --auto \
                          --output HDMI-2 --left-of eDP-1 --auto \
                          --output DP-1 --off"))
               ;; laptop seul
               (t
                (start-process-shell-command "xrandr" nil
					     "xrandr --output eDP-1 --primary --auto \
                          --output DP-1 --off \
                          --output HDMI-2 --off"))))))


;; ------------------------------------------------------------
;; 4. EXWM core
;; ------------------------------------------------------------
(use-package exwm
  :ensure t
  :config

  ;; Fond d'écran
  ;; (start-process-shell-command "feh" nil
  ;; 			       "feh --bg-scale /home/zach/Pictures/wallpaper/ciel.png")

  ;; Workspaces
  (setq exwm-workspace-number 10)

  ;; Warp cursor when switching workspace
  (setq exwm-workspace-warp-cursor t)

  ;; Focus follows mouse (doit être AVANT exwm-enable)
  (setq mouse-autoselect-window nil
	focus-follows-mouse nil)

  (setq exwm-layout-show-all-buffers t)
  (setq exwm-workspace-show-all-buffers t)

  ;; -- Buffer naming -------------------------------------------
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (exwm-workspace-rename-buffer exwm-class-name)))

  ;; Navigateurs : titre de l'onglet
  (add-hook 'exwm-update-title-hook
            (lambda ()
              (when (or (not exwm-instance-name)
                        (string-prefix-p "chromium" exwm-instance-name)
                        (string-prefix-p "firefox"  exwm-instance-name)
                        (string-prefix-p "brave"    exwm-instance-name))
                (exwm-workspace-rename-buffer exwm-title))))

  ;; -- Auto-place apps on workspaces ---------------------------
  ;; (defun my/exwm-auto-place-windows ()
  ;;   (pcase exwm-class-name
  ;;     ("vial"  (exwm-workspace-move-window 0))
  ;;     ("qbitorrent" (exwm-workspace-move-window 0))))

  ;; (add-hook 'exwm-manage-finish-hook #'my/exwm-auto-place-windows)

  ;; -- xmodmap (appliqué une seule fois) -----------------------
  (defun my/exwm-apply-xmodmap ()
    (start-process "xmodmap" nil "xmodmap"
                   (expand-file-name "~/.Xmodmap.exwm"))
    (remove-hook 'exwm-manage-finish-hook #'my/exwm-apply-xmodmap))
  (add-hook 'exwm-manage-finish-hook #'my/exwm-apply-xmodmap)

  ;; (use-package exwm
  ;;   :config
  ;;   ;; ... your other EXWM configurations ...

  ;;   ;; Use the init hook to start background processes
  ;;   (add-hook 'exwm-init-hook #'my-exwm-start-processes))

  ;; (defun my-exwm-start-processes ()
  ;;   "Start background processes for the EXWM session."

  ;;   ;; Start lxsession (for Polkit authentication)
  ;;   ;; The '&' at the end makes it run in the background
  ;;   (start-process-shell-command "lxsession" nil "lxsession &")

  ;; -- Redimensionnement à la souris ---------------------------
  (setq window-divider-default-bottom-width 2
	window-divider-default-right-width  2)
  (window-divider-mode)

  ;; -- Mode line : line-mode / char-mode -----------------------
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

  ;; -- Global keybindings (Super) ------------------------------
  (setq exwm-input-global-keys
	`(
          ;; Mode clavier
          (,(kbd "s-i") . exwm-input-toggle-keyboard)

          ;; Fermer fenêtre X11
          (,(kbd "s-c") . (lambda () (interactive)
                            (kill-buffer (current-buffer))))
	  ;; ;; Screenshot
	  ;; ("s-<print>" . (lambda () (interactive)
	  ;; 		   (shell-command "scrot '/home/zach/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png' && xclip -selection clipboard -t image/png '/home/zach/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png'")
	  ;; 		   (message "Screenshot taken with success")))
	  ;; ("<print>" . (lambda () (interactive)
	  ;; 		 (shellcommand "scrot --select '/home/zach/Pictures/Shots/%Y-%m-%d_%H-%M-%S.png' && xclip -selection clipboard -t image/png '/home/zach/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png'")
	  ;; 		 (message "Screenshot taken with success")))

	  ;; playerctl
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

          ;; Luminosité
	  (,(kbd "<XF86MonBrightnessUp>")   . (lambda () (interactive)
						(backlight-inc, 151)
						(get-brightness-percentage)))
	  (,(kbd "<XF86MonBrightnessDown>") . (lambda () (interactive)
						(backlight-dec, 151)
						(get-brightness-percentage)))
          (,(kbd "s-<XF86MonBrightnessDown>") . (lambda () (interactive)
                                                  (backlight-set-raw)))

	  ;; Wifi
	  (,(kbd "<XF86Tools>") . (lambda () (interactive)
				    (my/wifi-menu)))

          ;; Workspaces 0-9
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
			(lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))

          ;; Lanceur d'applications
          (,(kbd "s-o") . (lambda () (interactive)
                            (if (fboundp 'counsel-linux-app)
                                (counsel-linux-app)
			      (start-process "dmenu" nil "dmenu_run"))))

          ;; Terminal
          (,(kbd "s-<return>") . (lambda () (interactive)
				   (my/open-new-vterm)))

          ;; Navigateur
          (,(kbd "s-b") . (lambda () (interactive)
                            (browse-url-xdg-open "about:blank")))

          ;; Splits Emacs
          (,(kbd "s-v") . split-window-right)
          (,(kbd "s-s") . split-window-below)
          (,(kbd "s-q") . delete-window)

          ;; Redimensionnement des fenêtres Emacs
          (,(kbd "s-=") . (lambda () (interactive) (enlarge-window-horizontally 5)))
          (,(kbd "s--") . (lambda () (interactive) (shrink-window-horizontally 5)))
          (,(kbd "s-+") . (lambda () (interactive) (enlarge-window 5)))
          (,(kbd "s-_") . (lambda () (interactive) (shrink-window 5)))

          ;; Navigation entre fenêtres
          (,(kbd "s-l") . windmove-right)
          (,(kbd "s-j") . windmove-down)
          (,(kbd "s-k") . windmove-up)
          (,(kbd "s-h") . windmove-left)

          ;; Plein écran / flottant
          (,(kbd "s-f") . exwm-layout-toggle-fullscreen)
          (,(kbd "s-t") . exwm-floating-toggle-floating)

          ;; Quitter EXWM
          (,(kbd "s-Q") . (lambda () (interactive)
                            (when (yes-or-no-p "Quitter EXWM ? ")
                              (kill-emacs))))))

  ;; -- Simulation keys (Hyper = Caps Lock remappé) -------------
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



  ;; -- helm-exwm -----------------------------------------------
  (use-package helm-exwm
    :ensure t
    :config
    (setq helm-exwm-emacs-buffers-source (helm-exwm-build-emacs-buffers-source))
    (setq helm-exwm-source              (helm-exwm-build-source))
    (setq helm-mini-default-sources
          `(helm-exwm-emacs-buffers-source
            helm-exwm-source
            helm-source-recentf)))
  ;; -- Lancer EXWM ---------------------------------------------
  ;; (exwm-wm-mode)
  )
(defun my/run-exwm-once-started ()
  "Safely initialize exwm when the first graphical frame is ready."
  (run-with-timer 0.5 nil
		  (lambda ()
		    (exwm-wm-mode 1)
		    ))
  (remove-hook 'server-after-make-frame-hook #'my/run-exwm-once-started))
(add-hook 'server-after-make-frame-hook #'my/run-exwm-once-started)
