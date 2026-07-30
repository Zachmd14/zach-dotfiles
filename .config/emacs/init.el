;; ---------------------------------------------------------------------------
;; File loading
;; ---------------------------------------------------------------------------
(load-file "~/.config/emacs/secrets.el")
(load-file "~/.config/emacs/exwm.el")

;; ---------------------------------------------------------------------------
;; Startup & UI basics
;; ---------------------------------------------------------------------------
(setq inhibit-startup-message t)
(setq initial-scratch-message
      "; Welcome to Emacs.
; Use 'C-x C-f' to open a file.")
(setq project-vc-extra-root-markers '(".project"))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(setq visible-bell t)
(column-number-mode)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode +1)

(setq browse-url-browser-function 'browse-url-generic)
(setq browse-url-generic-program "/home/zach/Apps/zen/zen")

(dolist (face '(window-divider
                window-divider-first-pixel
                window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))

;; ---------------------------------------------------------------------------
;; Fonts & encoding
;; ---------------------------------------------------------------------------
(set-face-attribute 'default nil :font "Fira Code")
(set-fontset-font "fontset-default" 'unicode "Noto Color Emoji" nil 'prepend)
(set-fontset-font "fontset-default" 'symbol  "Noto Color Emoji" nil 'prepend)
(set-fontset-font "fontset-default" 'emoji   "Noto Color Emoji" nil 'prepend)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))

;; ---------------------------------------------------------------------------
;; Package management
;; ---------------------------------------------------------------------------
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(setq use-package-always-ensure t)

;; ---------------------------------------------------------------------------
;; Theme — Doom themes
;; ---------------------------------------------------------------------------
(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  (doom-themes-treemacs-theme "doom-atom")
  :config
  (load-theme 'doom-homage-black t)
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(defun switch-to-doom-homage-white ()
  "Switch to doom-homage-white theme."
  (interactive)
  (disable-theme 'doom-homage-black)
  (load-theme 'doom-homage-white t))

(defun switch-to-doom-homage-black ()
  "Switch to doom-homage-black theme."
  (interactive)
  (disable-theme 'doom-homage-white)
  (load-theme 'doom-homage-black t))

(global-set-key (kbd "C-c t w") 'switch-to-doom-homage-white)
(global-set-key (kbd "C-c t b") 'switch-to-doom-homage-black)

;; ---------------------------------------------------------------------------
;; Modeline — Doom modeline
;; ---------------------------------------------------------------------------
(use-package doom-modeline
  :defer t
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 15))

;; ---------------------------------------------------------------------------
;; AI — DeepSeek
;; ---------------------------------------------------------------------------

(use-package deepseek
  :load-path "/home/zach/.config/emacs/lisp/deepseek.el")

;; ---------------------------------------------------------------------------
;; Dashboard
;; ---------------------------------------------------------------------------

(use-package dashboard
  :defer t
  :config
  (dashboard-setup-startup-hook)
  (add-hook 'server-after-make-frame-hook 'dashboard-open)
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-banner-logo-title nil)
  (setq dashboard-startup-banner "/home/zach/.config/emacs/ascii/ascii_art_smaller.png")
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-navigation-cycle t)
  (setq dashboard-show-shortcuts t)
  (setq dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-navigator
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    dashboard-insert-items
                                    dashboard-insert-newline))
  (setq dashboard-items '((recents   . 4)
			  (agenda . 9)
			  ))
  (setq dashboard-item-shortcuts '((recents   . "r")
				   (agenda . "a")
				   ))
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t))

(defun my/startup-split-layout ()
  (require 'dashboard)
  (dashboard-open)
  (split-window-right)
  (other-window 1)
  (org-agenda nil "d")
  )

(add-hook 'after-init-hook #'my/startup-split-layout)

;; ---------------------------------------------------------------------------
;; Evil mode — Vim keybindings
;; ---------------------------------------------------------------------------
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; ---------------------------------------------------------------------------
;; Navigation — Flash, Hydra
;; ---------------------------------------------------------------------------
(use-package flash
  :commands (flash-jump flash-treesitter)
  :init
  (with-eval-after-load 'evil
    (require 'flash-evil)
    (flash-evil-setup t))
  :config
  (require 'flash-isearch)
  (flash-isearch-mode 1))

(use-package hydra :defer t)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

;; ---------------------------------------------------------------------------
;; Leader keys — General
;; ---------------------------------------------------------------------------
(use-package general
  :after evil
  :config
  (global-unset-key (kbd "C-SPC"))
  (general-create-definer zach/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (zach/leader-keys
    "f"   '(:ignore t :which-key "files")
    "t"   '(:ignore t :which-key "toggle")
    "w"   '(:ignore t :which-key "window")
    "a"   '(:ignore t :which-key "anki")
    "o"   '(:ignore t :which-key "org")
    "ac"  '(:ignore t :which-key "anki cloze actions")
    "fp"  (list (lambda () (interactive)
                  (counsel-find-file "~/.config/emacs/"))
                :which-key "find file in config")
    "ai"  '(anki-editor-insert-note         :which-key "insert note")
    "ap"  '(anki-editor-push-new-notes      :which-key "push note")
    "aa"  '(anki-editor-gui-browse          :which-key "browse gui")
    "ao"  '(lambda () (interactive) (counsel-find-file "~/Documents/orgmode/anki.org")
             :which-key "open anki.org")
    "aci" '(anki-editor-cloze-region-auto-incr  :which-key "cloze region incr")
    "acr" '(anki-editor-reset-cloze-number      :which-key "cloze region reset number")
    "acd" '(anki-editor-cloze-region-dont-incr  :which-key "cloze dont incr")
    "oo"  '(lambda () (interactive) (counsel-find-file "~/org/")
             :which-key "open org file")
    "td"  '(deepseek-query                  :which-key "deepseek")
    "tn"  '(org-num-mode :which-key "toggle numbered headers")
    "tu"  '(vundo                           :which-key "undo graph")
    "ts"  '(hydra-text-scale/body           :which-key "scale text")
    "tf"  '(format-all-buffer               :which-key "format buffer")
    "tl"  '(display-line-numbers-mode       :which-key "display line numbers")
    "ty"  '(counsel-yank-pop                :which-key "browse kill-ring")
    ))

;; ---------------------------------------------------------------------------
;; Global keybindings
;; ---------------------------------------------------------------------------
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-c e r") 'eval-region)
(global-set-key (kbd "C-c e b") 'eval-buffer)
(global-set-key (kbd "M-s s") 'shell-command-on-region)
(global-set-key (kbd "M-s a") 'async-shell-command)

;; ---------------------------------------------------------------------------
;; Tab bar
;; ---------------------------------------------------------------------------
(define-prefix-command 'my-tab-map)
(global-set-key (kbd "s-<tab>") 'my-tab-map)
(define-key my-tab-map (kbd "s") 'tab-switch)
(define-key my-tab-map (kbd "n") 'tab-new)
(define-key my-tab-map (kbd "c") 'tab-close)
(define-key my-tab-map (kbd "h") 'tab-bar-switch-to-prev-tab)
(define-key my-tab-map (kbd "l") 'tab-bar-switch-to-next-tab)
(define-key my-tab-map (kbd "g") 'tab-group)
(define-key my-tab-map (kbd "r") 'tab-bar-rename-tab)
(define-key my-tab-map (kbd "d") 'tab-bar-duplicate-tab)

;; ---------------------------------------------------------------------------
;; Completion — Ivy, Counsel
;; ---------------------------------------------------------------------------
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1))

(use-package counsel
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config (counsel-mode 1))

;; ---------------------------------------------------------------------------
;; Completion — Company
;; ---------------------------------------------------------------------------

(use-package company
  :config
  (global-company-mode 1)
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 1
        company-show-numbers nil
        company-tooltip-limit 10
        company-selection-wrap-around t
        company-require-match nil
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case t
        company-dabbrev-code-other-buffers t)
  (define-key company-active-map (kbd "C-l") 'company-complete-selection)
  (define-key company-active-map (kbd "C-j") 'company-select-next)
  (define-key company-active-map (kbd "C-k") 'company-select-previous)
  (define-key company-active-map (kbd "<tab>") nil)
  (define-key company-active-map (kbd "TAB") nil))

(setq-default company-backends
	      '((company-files :with company-yasnippet)
                company-dabbrev
                company-keywords
                company-etags
                company-dabbrev-code))

;; ---------------------------------------------------------------------------
;; LSP & Debug
;; ---------------------------------------------------------------------------
(use-package lsp-mode
  :defer t
  :init (setq lsp-keymap-prefix "C-c l")
  :hook ((c-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration)
         (lsp-mode . lsp-headerline-breadcrumb-mode))
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-headerline-breadcrumb-icons-enable nil)
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (setq lsp-completion-provider :none))

(use-package lsp-ui       :commands lsp-ui-mode)
(use-package helm-lsp     :commands helm-lsp-workspace-symbol)
(use-package lsp-ivy      :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
(use-package dap-mode
  :defer t
  :after lsp-mode
  :config
  (dap-mode 1)
  (dap-ui-mode 1))

(with-eval-after-load 'lsp-mode
  (remove-hook 'lsp-managed-mode-hook #'lsp-completion-mode)
  (yas-global-mode 1)
  (add-hook 'lsp-managed-mode-hook
            (lambda ()
	      (setq-local company-backends '((company-capf :with company-yasnippet)))))
  (add-hook 'lsp-completion-mode-hook
            (lambda ()
	      (setq-local company-backends '((company-capf :with company-yasnippet)
                                             (company-files :with company-yasnippet))))))

;; ---------------------------------------------------------------------------
;; Snippets — YASnippet
;; ---------------------------------------------------------------------------
(use-package yasnippet
  :hook ((text-mode prog-mode conf-mode snippet-mode) . yas-minor-mode-on)
  :init (setq yas-snippet-dir "~/.config/emacs/snippets")
  )

;; ---------------------------------------------------------------------------
;; Formatting — Format-all
;; ---------------------------------------------------------------------------
(use-package format-all
  :preface
  (defun ian/format-code ()
    "Auto-format whole buffer."
    (interactive)
    (if (derived-mode-p 'prolog-mode)
        (prolog-indent-buffer)
      (format-all-buffer)))
  :config
  (global-set-key (kbd "M-F") #'ian/format-code)
  (add-hook 'prog-mode-hook #'format-all-ensure-formatter))

;; ---------------------------------------------------------------------------
;; Projects — Projectile
;; ---------------------------------------------------------------------------
(use-package projectile)

;; ---------------------------------------------------------------------------
;; Terminal — VTerm
;; ---------------------------------------------------------------------------
(use-package vterm
  :config
  (add-hook 'vterm-mode-hook
            (lambda ()
	      (display-line-numbers-mode -1)
	      (setq display-line-numbers nil))))

(defun my/open-new-vterm ()
  "Launch a brand new, uniquely named vterm instance every time."
  (interactive)
  (vterm t))

;; ---------------------------------------------------------------------------
;; Environment — Load-env-vars
;; ---------------------------------------------------------------------------
(use-package load-env-vars
  :ensure t
  :config
  (load-env-vars "~/.env"))

;; ---------------------------------------------------------------------------
;; Which-key
;; ---------------------------------------------------------------------------
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

;; ---------------------------------------------------------------------------
;; Utility packages — Vundo, Recentf, Browse-kill-ring, Flex-autopair,
;;                    Page-break-lines, Nerd-icons, All-the-icons-dired,
;;                    Surround, Google-translate, Impatient-mode
;; ---------------------------------------------------------------------------
(use-package vundo)
(use-package recentf)
(global-set-key (kbd "C-x C-r") 'recentf-open)

(use-package browse-kill-ring)
(use-package flex-autopair)
(use-package page-break-lines)
(use-package nerd-icons)
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package surround
  :bind-keymap ("C-c s" . surround-keymap))

(use-package google-translate)
(global-set-key (kbd "C-c g t") 'google-translate-query-translate)

(use-package impatient-mode)

;; ---------------------------------------------------------------------------
;; Browser & search
;; ---------------------------------------------------------------------------

(defvar my-search-engine-url "https://duckduckgo.com/?t=ffab&q=%s"
  "Search engine URL template. %s will be replaced with the query.")

(defun search-in-browser ()
  "Prompt for a search query and open it in the zen browser."
  (interactive)
  (let ((query (read-string "Search for: " nil nil nil t)))
    (when (and query (not (string-empty-p query)))
      (let ((browse-url-browser-function
             (lambda (url &optional _new-window)
	       (start-process "zen-browser" nil
			      "/home/zach/Apps/zen/zen" url))))
        (browse-url
         (format my-search-engine-url
                 (url-hexify-string query)))))))

;; ---------------------------------------------------------------------------
;; GDB debugging
;; ---------------------------------------------------------------------------
(setq gdb-many-windows t)
(setq gdb-restore-windows t)

(defun my/gud-toggle-break ()
  "Toggle breakpoint on current line via GDB CLI."
  (interactive)
  (let* ((line (line-number-at-pos))
         (file (file-name-nondirectory (buffer-file-name)))
         (found (cl-find-if
                 (lambda (bp)
                   (let ((data (cdr bp)))
                     (and (string-suffix-p
                           file
                           (or (cdr (assoc 'fullname data)) ""))
                          (equal (number-to-string line)
                                 (cdr (assoc 'line data))))))
                 gdb-breakpoints-list)))
    (if found
        (gud-call (format "clear %s:%d" file line))
      (gud-call (format "break %s:%d" file line)))))

(defun my/kill-gdb-buffers ()
  "Kill all GDB-related buffers and the GDB process, then close current source buffer."
  (interactive)
  (when (and (boundp 'gud-comint-buffer)
             gud-comint-buffer
             (buffer-live-p gud-comint-buffer))
    (let ((proc (get-buffer-process gud-comint-buffer)))
      (when proc
        (delete-process proc))))

  (let ((current-buf (current-buffer)))

    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (or (derived-mode-p 'gdb-mode)
                  (derived-mode-p 'gud-mode)
                  (string-match-p "\\*gud\\*\\|\\*gdb\\|\\*breakpoints\\*"
                                  (buffer-name buffer)))
          (kill-buffer buffer))))

    (when (and (buffer-live-p current-buf)
	       (not (string-match-p "\\*" (buffer-name current-buf))))
      (kill-buffer current-buf)))

  (message "GDB process and all related buffers (including source) killed"))

(define-prefix-command 'gdb-map)
(global-set-key (kbd "C-c C-g") 'gdb-map)
(define-key gdb-map (kbd "g") 'gdb)
(define-key gdb-map (kbd "w") 'gdb-many-windows)
(define-key gdb-map (kbd "b") 'my/gud-toggle-break)
(define-key gdb-map (kbd "q") 'my/kill-gdb-buffers)

;; ---------------------------------------------------------------------------
;; LaTeX & PDF
;; ---------------------------------------------------------------------------

(setq TeX-PDF-mode t)
(setq TeX-source-correlate-mode t)

(setq TeX-view-program-selection '((output-pdf "Zathura")))

;; ---------------------------------------------------------------------------
;; Markdown
;; ---------------------------------------------------------------------------
(with-eval-after-load 'markdown-mode
  (evil-define-key 'normal markdown-mode-map (kbd "q") 'self-insert-command))

;; ---------------------------------------------------------------------------
;; Misc UI & performance
;; ---------------------------------------------------------------------------
(global-set-key (kbd "C-c w o") 'eww)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq fast-but-imprecise-scrolling nil)
(setq auto-window-vscroll nil)

(use-package gcmh :config (gcmh-mode 1))
(defun my/set-frame-opacity (opacity)
  (set-frame-parameter (selected-frame) 'alpha opacity))

(setq backup-inhibited t)

(add-hook 'focus-in-hook  (lambda () (my/set-frame-opacity '(89 . 75))))
(add-hook 'focus-out-hook (lambda () (my/set-frame-opacity '(89 . 75))))
(add-to-list 'default-frame-alist '(alpha . (89 . 75)))
(display-battery-mode 1)
(display-time-mode 1)

(add-hook 'after-init-hook #'fancy-battery-mode)

;; ---------------------------------------------------------------------------
;; Org mode — core
;; ---------------------------------------------------------------------------

(setq org-directory "~/org")

(use-package org
  :hook (
         (org-mode . org-indent-mode)
         )
  :config
  (setq-default org-ellipsis " …")
  (setq org-startup-folded 'content)
  (setq org-hide-emphasis-markers t)
  (setq org-image-actual-width '(0.5))
  (setq org-num-skip-unnumbered t)
  (setq org-num-max-level 8)
  (setq org-startup-indented t)
  (setq org-preview-latex-default-process 'dvipng)
  (setq org-preview-latex-remove-previous-images nil)
  (with-eval-after-load 'org
    (add-to-list 'org-latex-packages-alist '("" "amsmath"   t))
    (add-to-list 'org-latex-packages-alist '("" "amssymb"   t))
    (add-to-list 'org-latex-packages-alist '("" "mathtools" t))
    (add-to-list 'org-latex-packages-alist '("" "mathrsfs"  t))
    (add-to-list 'org-latex-packages-alist '("" "mhchem"    t))))

;; ---------------------------------------------------------------------------
;; Org agenda
;; ---------------------------------------------------------------------------
(add-hook 'org-agenda-mode-hook
          (lambda ()
            (visual-line-mode -1)
            (setq truncate-lines 1)))
(setq org-agenda-remove-tags t)
(setq org-agenda-block-separator 32)
(setq org-agenda-custom-commands
      '(("d" "Dashboard"
         (
          (tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "\n HIGHEST PRIORITY")
                 (org-agenda-prefix-format "   %i %?-2 t%s")
                 )
                )
          (agenda ""
                  (
                   (org-agenda-start-day "+0d")
                   (org-agenda-span 1)
                   (org-agenda-time)
                   (org-agenda-remove-tags t)
                   (org-agenda-todo-keyword-format "")
                   (org-agenda-scheduled-leaders '("" ""))
                   (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈┈┈ NOW")
                   (org-agenda-overriding-header "\n TODAY'S SCHEDULE")
                   (org-agenda-prefix-format "   %i %?-2 t%s")
                   )
                  )
          (tags-todo  "-STYLE=\"habit\""
		      (
		       (org-agenda-overriding-header "\n ALL TODO")
		       (org-agenda-sorting-strategy '(priority-down))
		       (org-agenda-remove-tags t)
		       (org-agenda-prefix-format "   %i %?-2 t%s")
		       )
		      )))))


(setq org-agenda-scheduled-leaders '("" ""))
(setq org-agenda-include-diary nil)

(setq org-agenda-file "~/org/calendar.org")

;; ---------------------------------------------------------------------------
;; Org capture
;; ---------------------------------------------------------------------------
(setq org-capture-templates
      '(("t" "Todo" entry
         (file+headline "~/org/inbox.org" "Inbox")
         "* TODO %^{Task}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?\n"
         :empty-lines 1)

        ("e" "Event" entry
         (file+headline "~/org/calendar.org" "Events")
         "* %^{Event}\n%^{SCHEDULED}T\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?\n"
         :empty-lines 1)

        ("d" "Deadline" entry
         (file+headline "~/org/calendar.org" "Deadlines")
         "* TODO %^{Task}\nDEADLINE: %^{Deadline}T\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?\n"
         :empty-lines 1)

        ("p" "Project" entry
         (file+headline "~/org/projects.org" "Projects")
         "* PROJ %^{Project name}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n** TODO %?\n"
         :empty-lines 1)

        ("i" "Idea" entry
         (file+headline "~/org/ideas.org" "Ideas")
         "** IDEA %^{Idea}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?\n"
         :empty-lines 1)

        ("b" "Bookmark" entry
         (file+headline "~/org/bookmarks.org" "Inbox")
         "** [[%^{URL}][%^{Title}]]\n:PROPERTIES:\n:CREATED: %U\n:TAGS: %(org-capture-bookmark-tags)\n:END:\n\n"
         :empty-lines 0)

        ("n" "Note" entry
         (file+headline "~/org/notes.org" "Inbox")
         "* [%<%Y-%m-%d %a>] %^{Title}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?\n"
         :prepend t
         :empty-lines 1)))
(setq org-capture-templates
      '(("t" "Todo" entry
         (file+headline "~/org/inbox.org" "Inbox")
         "* TODO %^{Task}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?")

        ("e" "Event" entry
         (file+headline "~/org/calendar.org" "Events")
         "* %^{Event}\n%^{SCHEDULED}T\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?")

        ("d" "Deadline" entry
         (file+headline "~/org/calendar.org" "Deadlines")
         "* TODO %^{Task}\nDEADLINE: %^{Deadline}T\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?")

        ("p" "Project" entry
         (file+headline "~/org/projects.org" "Projects")
         "* PROJ %^{Project name}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n** TODO %?")

        ("i" "Idea" entry
         (file+headline "~/org/ideas.org" "Ideas")
         "** IDEA %^{Idea}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?")

        ("b" "Bookmark" entry
         (file+headline "~/org/bookmarks.org" "Inbox")
         "** [[%^{URL}][%^{Title}]]\n:PROPERTIES:\n:CREATED: %U\n:TAGS: %(org-capture-bookmark-tags)\n:END:\n\n"
         :empty-lines 0)

        ("n" "Note" entry
         (file+headline "~/org/notes.org" "Inbox")
         "* [%<%Y-%m-%d %a>] %^{Title}\n:PROPERTIES:\n:CREATED: %U\n:CAPTURED: %a\n:END:\n%?"
         :prepend t)))

;; ---------------------------------------------------------------------------
;; Org agenda styling — SVG tags
;; ---------------------------------------------------------------------------

(defun my/svg-tag-timestamp (&rest args)
  "Create a timestamp SVG tag for the time at point."

  (interactive)
  (let ((inhibit-read-only t))

    (goto-char (point-min))
    (while (search-forward-regexp
            "\\(\([0-9]/[0-9]\):\\)" nil t)
      (set-text-properties (match-beginning 1) (match-end 1)
                           `(display ,(svg-tag-make "ANYTIME"
                                                    :face 'nano-faded
                                                    :inverse nil
                                                    :padding 3 :alignment 0))))

    (goto-char (point-min))
    (while (search-forward-regexp
            "\\([0-9]+:[0-9]+\\)\\(\\.+\\)" nil t)

      (set-text-properties (match-beginning 1) (match-end 2)
                           `(display ,(svg-tag-make (match-string 1)
                                                    :face 'nano-faded
                                                    :margin 4 :alignment 0))))

    (goto-char (point-min))
    (while (search-forward-regexp
            "\\([0-9]+:[0-9]+\\)\\(\\.*\\)" nil t)

      (set-text-properties (match-beginning 1) (match-end 2)
                           `(display ,(svg-tag-make (match-string 1)
                                                    :face 'nano-default
                                                    :inverse t
                                                    :margin 4 :alignment 0))))
    (goto-char (point-min))
    (while (search-forward-regexp
            "\\([0-9]+:[0-9]+\\)\\(-[0-9]+:[0-9]+\\)" nil t)
      (let* ((t1 (parse-time-string (match-string 1)))
             (t2 (parse-time-string (substring (match-string 2) 1)))
             (t1 (+ (* (nth 2 t1) 60) (nth 1 t1)))
             (t2 (+ (* (nth 2 t2) 60) (nth 1 t2)))
             (d  (- t2 t1)))

        (set-text-properties (match-beginning 1) (match-end 1)
                             `(display ,(svg-tag-make (match-string 1)
                                                      :face 'nano-faded
                                                      :crop-right t)))
        (if (< d 60)
            (set-text-properties (match-beginning 2) (match-end 2)
                                 `(display ,(svg-tag-make (format "%2dm" d)
                                                          :face 'nano-faded
                                                          :crop-left t :inverse t)))
          (set-text-properties (match-beginning 2) (match-end 2)
                               `(display ,(svg-tag-make (format "%1dH" (/ d 60))
                                                        :face 'nano-faded
                                                        :crop-left t :inverse t
                                                        :padding 2 :alignment 0))))))))

(add-hook 'org-agenda-mode-hook #'my/svg-tag-timestamp)
(advice-add 'org-agenda-redo :after #'my/svg-tag-timestamp)


(defun my/org-agenda-custom-date ()
  (interactive)
  (let* ((timestamp (org-entry-get nil "TIMESTAMP"))
         (timestamp (or timestamp (org-entry-get nil "DEADLINE"))))
    (if timestamp
        (let* ((delta (- (org-time-string-to-absolute (org-read-date nil nil timestamp))
                         (org-time-string-to-absolute (org-read-date nil nil ""))))
               (delta (/ (+ 1 delta) 30.0))
               (face (cond
                       ((< delta 1.00) 'nano-default)
                       (t 'nano-faded))))
          (concat
           (propertize " " 'face nil
                       'display (svg-lib-progress-pie
                                 delta nil
                                 :background (face-background face nil 'default)
                                 :foreground (face-foreground face)
                                 :margin 0 :stroke 2 :padding 1))
           " "
           (propertize
            (format-time-string "%d/%m" (org-time-string-to-time timestamp))
            'face 'nano-popout)))
      "     ")))


(defun org-capture-bookmark-tags ()
  "Get tags from existing bookmarks and prompt for tags with completion."
  (save-window-excursion
    (let ((tags-list '()))
      (with-current-buffer (find-file-noselect "~/org/bookmarks.org")
        (save-excursion
          (goto-char (point-min))
          (while (re-search-forward "^:TAGS:\\s-*\\(.+\\)$" nil t)
            (let ((tag-string (match-string 1)))
	      (dolist (tag (split-string tag-string "[,;]" t "[[:space:]]"))
                (push (string-trim tag) tags-list))))))
      (setq tags-list (sort (delete-dups tags-list) 'string<))
      (let ((selected-tags (completing-read-multiple "Tags (comma-separated): " tags-list)))
        (mapconcat 'identity selected-tags ", ")))))

(defun my/archive-done-task ()
  "Archive current task to done.org under today's date"
  (interactive)
  (let* ((date-header (format-time-string "%Y-%m-%d %A"))
         (archive-file (expand-file-name "~/org/done.org"))
         (location (format "%s::* %s" archive-file date-header)))
    (org-set-property "COMPLETED" (format-time-string "[%Y-%m-%d %a %H:%M]"))
    (setq org-archive-location location)
    (org-archive-subtree)))

(add-hook 'org-after-todo-state-change-hook
          (lambda ()
            (when (string= org-state "DONE")
	      (my/archive-done-task))))

(global-set-key (kbd "C-c n") 'org-capture)

;; ---------------------------------------------------------------------------
;; Org caldav — iCloud calendar sync
;; ---------------------------------------------------------------------------

(use-package org-caldav
  :ensure t
  :config
  (setq org-caldav-show-sync-results nil)
  (setq org-caldav-url "https://caldav.icloud.com/10721069014/calendars")
  (setq org-caldav-calendar-id "262F4B9C-F5B0-4471-A635-32B52E3F2ECE")
  (setq org-caldav-files '("~/org/calendar.org"))
  (setq org-caldav-inbox "~/org/calendar.org")
  (setq url-http-real-basic-auth-storage
        (list (list "caldav.icloud.com:443"
                    (cons "iCloud" (base64-encode-string
                                    (concat my-icloud-email ":" my-icloud-app-password)))))))

(global-set-key (kbd "C-c c s") 'org-caldav-sync)
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-span 'week)

(with-eval-after-load 'url-dav
  (advice-add 'url-dav-process-DAV:prop :around
	      (lambda (orig-fn node &rest args)
                (if (xml-node-children node)
                    (apply orig-fn node args)
                  nil))))


(setq calendar-week-start-day 1)
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (run-with-timer 0 (* 45 60) 'org-caldav-sync)
	    ))
(setq network-security-level 'low)

;; ---------------------------------------------------------------------------
;; Org images
;; ---------------------------------------------------------------------------

(defun my/org-insert-image ()
  "Select and insert an image into org file."
  (interactive)
  (let ((selected-file (read-file-name "Select image: " "~/Pictures/" nil t)))
    (when selected-file
      (insert (format "[[file:%s]]\n" selected-file))
      (org-display-inline-images))))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c c C-i") #'my/org-insert-image))

;; ---------------------------------------------------------------------------
;; Org styling — org-modern, svg, org-fragtog, indent-guide
;; ---------------------------------------------------------------------------

(use-package org-modern
  :custom
  (org-modern-hide-stars nil)
  (org-modern-table nil)
  (org-modern-list '((?- . "•") (?* . "•") (?+ . "‣")))
  :hook ((org-mode          . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda)))

(use-package org-modern-indent
  :load-path "/home/zach/.config/emacs/lisp/org-modern-indent"
  :config (add-hook 'org-mode-hook #'org-modern-indent-mode 90))
(use-package svg-lib :ensure t)
(use-package svg-tag-mode :ensure t)

(use-package org-fragtog
  :after org
  :hook (org-mode . org-fragtog-mode))

(use-package indent-guide)
(use-package aggressive-indent)

;; ---------------------------------------------------------------------------
;; Org LaTeX export
;; ---------------------------------------------------------------------------

(defhydra hydra-org-latex (:color blue :hint nil)
  ("p" org-latex-preview "toggle all previews")
  ("c" org-clear-latex-preview "clear previews")
  ("r" (org-latex-preview t "regenerate preview"))
  ("q" nil "finished" :exit t))

(defun my/org-export-pdf-mirror ()
  "On save, export org file to PDF and move it to mirrored PDF/ folder."
  (interactive)
  (if (and buffer-file-name
           (string-match "\\.org\\'" buffer-file-name)
           (string-match "/fiches/\\(?:\\([^/]+\\)/\\)?[^/]+\\.org\\'" buffer-file-name))
      (let* ((subdir (or (match-string 1 buffer-file-name) ""))
             (base (file-name-base buffer-file-name))
             (target-dir (expand-file-name
                          subdir
                          (replace-regexp-in-string
                           "/fiches/.*" "/fiches/PDF/" buffer-file-name)))
             (target-pdf (expand-file-name (concat base ".pdf") target-dir))
             (source-pdf (concat (file-name-sans-extension buffer-file-name) ".pdf")))
        (condition-case err
            (progn
	      (org-latex-export-to-pdf)
	      (make-directory target-dir t)
	      (rename-file source-pdf target-pdf t)))

	(add-hook 'org-mode-hook
		  (lambda () (add-hook 'after-save-hook #'my/org-export-pdf-mirror nil t)))

	(with-eval-after-load 'ox-latex
	  (add-to-list 'org-latex-classes
		       '("obsidian"
			 "\\documentclass[11pt]{article}
\\usepackage[a4paper,margin=1in]{geometry}
\\usepackage{sourcesanspro}
\\renewcommand{\\familydefault}{\\sfdefault}
\\usepackage[skip=6pt]{parskip}
\\usepackage{titlesec}
\\titlespacing*{\\section}{0pt}{8pt}{4pt}
\\titlespacing*{\\subsection}{0pt}{6pt}{3pt}
\\usepackage{enumitem}
\\setlist{itemsep=1pt,topsep=2pt}
\\usepackage[colorlinks=true,linkcolor=blue,urlcolor=blue]{hyperref}
\\pagenumbering{gobble}"
			 ("\\section{%s}" . "\\section*{%s}")
			 ("\\subsection{%s}" . "\\subsection*{%s}")
			 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))))))

;; ---------------------------------------------------------------------------
;; Org roam
;; ---------------------------------------------------------------------------
(use-package org-roam
  :custom
  (org-roam-directory "~/org/roam")

  (org-roam-database-connector 'sqlite-builtin)

  (org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))

  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))

  (advice-add 'org-roam-db-query :around
	      (lambda (fn &rest args)
                (condition-case err
                    (apply fn args)
                  (error
                   (message "Database error in org-roam: %S" err)
                   nil))))

  (org-roam-db-autosync-mode +1))

(use-package websocket
  :after org-roam)

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(defun debug-org-roam-db ()
  "Debug function to test org-roam database connection."
  (interactive)
  (message "Testing org-roam database...")
  (message "Directory exists: %s" (file-exists-p org-roam-directory))
  (message "Database path: %s" org-roam-db-location)
  (message "Database connector: %s" org-roam-database-connector)
  (condition-case err
      (progn
        (org-roam-db-sync)
        (message "Database synced successfully!"))
    (error (message "Database sync error: %S" err))))

(global-set-key (kbd "C-c c r f") 'org-roam-node-find)
(global-set-key (kbd "C-c c r i") 'org-roam-node-insert)
(global-set-key (kbd "C-c c r c") 'org-roam-capture)
(global-set-key (kbd "C-c c r l") 'org-roam-buffer-toggle)

;; ---------------------------------------------------------------------------
;; Markdown — evil keybinding
;; ---------------------------------------------------------------------------
(with-eval-after-load 'markdown-mode
  (evil-define-key 'normal markdown-mode-map (kbd "q") nil)
  (define-key markdown-mode-map (kbd "q") 'self-insert-command))

;; ---------------------------------------------------------------------------
;; Performance tweaks
;; ---------------------------------------------------------------------------
(setq-default bidi-display-reordering 'left-to-right
	      bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

(setq read-process-output-max (* 4 1024 1024))

(setq-default cursor-in-non-selected-windows nil)

(setq highlight-nonselected-windows nil)

(setq redisplay-skip-fontification-on-input t)

(add-hook 'after-save-hook
	  #'executable-make-buffer-file-executable-if-script-p)

;; ---------------------------------------------------------------------------
;; Winner mode — undo/redo window configurations
;; ---------------------------------------------------------------------------
(winner-mode +1)

(defun toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
	   (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))

(global-set-key (kbd "C-x 1") #'toggle-delete-other-windows)

(setq gc-cons-threshold 50000000)

;; ============================================================================
;; CUSTOM — auto-generated, do not edit manually
;; ============================================================================


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anki-editor-latex-style 'mathjax)
 '(custom-safe-themes
   '("9b9d7a851a8e26f294e778e02c8df25c8a3b15170e6f9fd6965ac5f2544ef2a9"
     "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8"
     "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098"
     "6963de2ec3f8313bb95505f96bf0cf2025e7b07cefdb93e3d2e348720d401425"
     default))
 '(eshell-toggle-window-side 'below)
 '(flyspell-default-dictionary "francais")
 '(helm-minibuffer-history-key "M-p")
 '(indent-guide-recursive t)
 '(indent-guide-threshold 1)
 '(latex-preview-pane-use-frame nil)
 '(lsp-headerline-breadcrumb-segments '(path-up-to-project file project))
 '(minimap-always-recenter t)
 '(minimap-hide-fringes t)
 '(minimap-window-location 'right)
 '(obsidian-wiki-link-alias-first t)
 '(olivetti-body-width 92)
 '(org-agenda-files '("/home/zach/org/calendar.org" "/home/zach/org/inbox.org"))
 '(org-caldav-files '("~/org/calendar.org"))
 '(org-export-with-toc nil)
 '(org-format-latex-options
   '(:foreground default :background default :scale 1.6 :html-foreground
		 "Black" :html-background "Transparent" :html-scale
		 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-hugo-section "/")
 '(org-modern-block-fringe t)
 '(org-modern-block-name '("‣ " . "‣ "))
 '(org-modern-star 'fold)
 '(org-roam-ui-browser-function 'browse-url)
 '(org-startup-with-latex-preview t)
 '(package-selected-packages
   '(aggressive-indent all-the-icons-dired amx anki anki-editor
		       auctex-latexmk auto-complete backlight
		       basic-c-compile benchmark-init bm
		       browse-kill-ring burly calibredb
		       centered-cursor-mode comment-tags company
		       counsel dap-mode dashboard dashboard-hackernews
		       disable-mouse doom-modeline doom-themes elcord
		       elfeed elpher emojify eshell-toggle
		       evil-collection exwm exwm-modeline
		       fancy-battery flash flex-autopair format-all
		       gcmh general good-scroll google-translate gptel
		       hackernews helm-exwm helm-lsp helpful
		       impatient-mode indent-guide ivy-posframe
		       ivy-rich latex-preview-pane leetcode ligature
		       load-env-vars lsp-ivy lsp-ui magit minimap
		       modusregel mu4e nov obsidian olivetti opencode
		       org-anki org-bullets org-caldav org-fragtog
		       org-modern org-super-agenda org-view-mode
		       ox-hugo page-break-lines perspective playerctl
		       projectile rainbow-mode shrface sleek-modeline
		       smooth-scrolling surround svg-lib svg-tag-mode
		       valign volume vterm vundo wallabag xenops
		       yasnippet-snippets))
 '(package-vc-selected-packages
   '((opencode :url "https://github.com/colobas/opencode.el" :branch
	       "main")
     (reader :url "https://codeberg.org/divyaranjan/emacs-reader"
	     :make "all")))
 '(pdf-latex-command "pdflatex")
 '(scroll-margin 7)
 '(shell-escape-mode "-shell-escape")
 '(smooth-scrolling-mode t))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(lsp-headerline-breadcrumb-path-face ((t (:inherit font-lock-string-face :family "Fira Code"))))
 '(mode-line ((t (:background "#242424"))))
 '(mode-line-inactive ((t (:background "#0B0C0E")))))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
