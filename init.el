;;(org-babel-load-file
;; (expand-file-name
;;  "config.org"
;;  user-emacs-directory))

;; global vars
(defvar emacs-config-dir "/home/lucas/.config/emacs/")
(defvar ctags-dir "/opt/local/bin/ctags")

;; general emacs stuff
(setq make-backup-files nil) ; stop creating ~ files
(setq create-lockfiles nil) ; stop creating ~ files
(setq visible-bell 1) ;; disable dumb beeping
(setq scroll-preserve-screen-position 'always)

;; melpa repo
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-refresh-contents)
(package-initialize)


(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)


;; evil mode
(use-package evil
  :init      ;; tweak evil's configuration before loading it
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (evil-mode))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))
(evil-set-undo-system 'undo-redo)

(use-package general
  :config
  (general-evil-setup t))

;; Using garbage magic hack.
 (use-package gcmh
   :config
   (gcmh-mode 1))
;; Setting garbage collection threshold
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; Silence compiler warnings as they can be pretty disruptive
(if (boundp 'comp-deferred-compilation)
    (setq comp-deferred-compilation nil)
    (setq native-comp-deferred-compilation nil))
;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent the use of stale byte-code. Otherwise, it saves us a little IO time
;; to skip the mtime checks on every *.elc file.
(setq load-prefer-newer noninteractive)

;; icons
(use-package all-the-icons)

;;emojis
(use-package emojify
  :hook (after-init . global-emojify-mode))

;; projectile
(use-package projectile
  :config
  (projectile-global-mode 1))


;; ag search
(use-package ag)

;; dashboard
(use-package dashboard
  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "~/.emacs.d/emacs-dash.png")  ;; use custom image as banner
  (setq dashboard-center-content t) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 10)
                          (agenda . 5 )
                          (bookmarks . 3)
                          (projects . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
			      (bookmarks . "book"))))
;; always open in dashboard
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

;;dired 
(use-package all-the-icons-dired)
(use-package dired-open)
(use-package peep-dired)

;; themes
(use-package doom-themes)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
(load-theme 'doom-one t)

;; which key
(use-package which-key
  :init
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.3
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit t
        which-key-separator " → " ))
(which-key-mode)

;; GUI improvements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; line numbers
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)

;; doom modeline
(use-package doom-modeline)
(doom-modeline-mode 1)
(column-number-mode)
;(add-hook 'doom-modeline-mode-hook #'column-number-mode) ; filesize in modeline
;;(after! doom-modeline
  ;;(remove-hook 'doom-modeline-mode-hook #'size-indication-mode) ; filesize in modeline
  ;;(remove-hook 'doom-modeline-mode-hook #'column-number-mode)   ; cursor column in modeline
  ;;(line-number-mode -1)
  ;;(setq doom-modeline-buffer-encoding nil))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

;; m-x remembers history
(use-package smex)
(smex-initialize)

;; completion mechanism
(use-package counsel
  :after ivy
  :config (counsel-mode))
(use-package ivy
  :defer 0.1
  :diminish
  :bind
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode))
(use-package ivy-rich
  :after ivy
  :custom
  (ivy-virtual-abbreviate 'full
   ivy-rich-switch-buffer-align-virtual-buffer t
   ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer)
  (ivy-rich-mode 1)) ;; this gets us descriptions in M-x.
(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))


;; magit client
(setq bare-work-tree (concat "--work-tree=" (expand-file-name "~")))
;; use maggit on git bare repos like dotfiles repos, don't forget to change `bare-git-dir' and `bare-work-tree' to your needs
(defun me/magit-status-bare ()
  "set --git-dir and --work-tree in `magit-git-global-arguments' to `bare-git-dir' and `bare-work-tree' and calls `magit-status'"
  (interactive)
  (require 'magit-git)
  (add-to-list 'magit-git-global-arguments bare-git-dir)
  (add-to-list 'magit-git-global-arguments bare-work-tree)
  (call-interactively 'magit-status))

;; if you use `me/magit-status-bare' you cant use `magit-status' on other other repos you have to unset `--git-dir' and `--work-tree'
;; use `me/magit-status' insted it unsets those before calling `magit-status'
(defun me/magit-status ()
  "removes --git-dir and --work-tree in `magit-git-global-arguments' and calls `magit-status'"
  (interactive)
  (require 'magit-git)
  (setq magit-git-global-arguments (remove bare-git-dir magit-git-global-arguments))
  (setq magit-git-global-arguments (remove bare-work-tree magit-git-global-arguments))
  (call-interactively 'magit-status))
(use-package magit
  :custom
  ;; show magit diff in current window
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
(use-package diff-hl
  :init
  (global-diff-hl-mode)
  :hook
  (magit-pre-refresh . diff-hl-magit-pre-refresh)
  (magit-post-refresh . diff-hl-magit-post-refresh))

;; neotree
(defcustom neo-window-width 25
  "*Specifies the width of the NeoTree window."
  :type 'integer
  :group 'neotree)

(use-package neotree
  :config
  (setq neo-smart-open t
        neo-window-width 30
        neo-window-fixed-size nil ;; allow me to adjust width
        neo-theme (if (display-graphic-p) 'icons 'arrow)
        ;;neo-window-fixed-size nil
        inhibit-compacting-font-caches t
	;projectile-switch-project-action 'neotree-projectile-action
	)
        ;; truncate long file names in neotree
        (add-hook 'neo-after-create-hook
           #'(lambda (_)
               (with-current-buffer (get-buffer neo-buffer-name)
                 (setq truncate-lines t)
                 (setq word-wrap nil)
                 (make-local-variable 'auto-hscroll-mode)
                 (setq auto-hscroll-mode nil)))))
;; show hidden files
(setq-default neo-show-hidden-files t)

;; vterm
(use-package vterm)
(setq shell-file-name "/bin/zsh"
      vterm-max-scrollback 5000)
;; please don't ask me if I'm sure I want to kill the buffer
(defun set-no-process-query-on-exit ()
    (let ((proc (get-buffer-process (current-buffer))))
    (when (processp proc)
    (set-process-query-on-exit-flag proc nil))))
(add-hook 'term-exec-hook 'set-no-process-query-on-exit)

;; better emacs scrolling 
(setq scroll-conservatively 101) ;; value greater than 100 gets rid of half page jumping
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3))) ;; how many lines at a time
(setq mouse-wheel-progressive-speed t) ;; accelerate scrolling
;; (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; set transparency
(add-to-list 'default-frame-alist '(alpha . 90))

;; custom function
(defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (shell-command
     (format "%s -f TAGS -e -R %s" ctags-dir (directory-file-name dir-name))))

(defun project-search (&optional extra-args)
  "Searches project directory if thee is one, else current directory"
  (interactive
   (list (when current-prefix-arg
           (read-string (concat
                         (car (split-string counsel-rg-base-command))
                         " with arguments: ")))))
  (counsel-rg nil (projectile-project-root) extra-args))

(defun show-and-copy-buffer-path ()
  "Show and copy the full path to the current file in the minibuffer."
  (interactive)
  ;; list-buffers-directory is the variable set in dired buffers
  (let ((file-name (or (buffer-file-name) list-buffers-directory)))
    (if file-name
        (message (kill-new file-name))
      (error "Buffer not visiting a file"))))

(defun show-buffer-path-name ()
  "Show the full path to the current file in the minibuffer."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if file-name
        (progn
          (message file-name)
          (kill-new file-name))
      (error "Buffer not visiting a file"))))

;; key bindings

;; zoom in/out like we do everywhere else.
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;; exit mini buffer with only one escape press
(define-key minibuffer-local-map (kbd "ESC") 'keyboard-escape-quit)
(global-set-key (kbd "ESC") 'keyboard-quit)

;; general keybindings
(nvmap :keymaps 'override :prefix "SPC"
    "SPC"   '(counsel-M-x :which-key "M-x")
    ;;"c c"   '(compile :which-key "Compile")
    ;;"c C"   '(recompile :which-key "Recompile")
    "h r r" '((lambda () (interactive) (load-file (concat emacs-config-dir "init.el"))) :which-key "Reload emacs config")
    "t t"   '(toggle-truncate-lines :which-key "Toggle truncate lines"))

;; neotree
(nvmap :prefix "SPC"
    "t n"   '(neotree-toggle :which-key "Toggle neotree file viewer"))
    ;"o n"   '(neotree-dir :which-key "Open directory in neotree"))

;; buffer keys
(nvmap :prefix "SPC"
    "b i"   '(ibuffer :which-key "Ibuffer")
    "b c"   '(clone-indirect-buffer-other-window :which-key "Clone indirect buffer other window")
    "b k"   '(kill-current-buffer :which-key "Kill current buffer")
    "b n"   '(next-buffer :which-key "Next buffer")
    "b p"   '(previous-buffer :which-key "Previous buffer")
    "b B"   '(ibuffer-list-buffers :which-key "Ibuffer list buffers")
    "b K"   '(kill-buffer :which-key "Kill buffer"))

;; projectile
(nvmap :prefix "SPC"
  "p f"    '(projectile-find-file :which-key "Find project file")
  "p p"    '(projectile-switch-project :which-key "Switch project")
  "p r"    '(project-search :which-key "Search project with regex")
  "p s"    '(projectile-ag :which-key "Search project for string and place in buffer"))

;; dired
(use-package all-the-icons-dired)
(use-package dired-open)
(use-package peep-dired)
(nvmap :states '(normal visual) :keymaps 'override :prefix "SPC"
    "d d" '(dired :which-key "Open dired")
    "d j" '(dired-jump :which-key "Dired jump to current")
    "d p" '(peep-dired :which-key "Peep-dired"))

;; file keys
(nvmap :states '(normal visual) :keymaps 'override :prefix "SPC"
       "f f"   '(find-file :which-key "Find file")
       "f r"   '(counsel-recentf :which-key "Recent files")
       "f s"   '(save-buffer :which-key "Save file")
       "f u"   '(sudo-edit-find-file :which-key "Sudo find file")
       "f y"   '(show-and-copy-buffer-path :which-key "Yank file path")
       "f C"   '(copy-file :which-key "Copy file")
       "f D"   '(delete-file :which-key "Delete file")
       "f R"   '(rename-file :which-key "Rename file")
       "f S"   '(write-file :which-key "Save file as...")
       "f U"   '(sudo-edit :which-key "Sudo edit file"))

;; window keys
(winner-mode 1)
(nvmap :prefix "SPC"
       ;; Window splits
       "w c"   '(evil-window-delete :which-key "Close window")
       "w n"   '(evil-window-new :which-key "New window")
       "w s"   '(evil-window-split :which-key "Horizontal split window")
       "w v"   '(evil-window-vsplit :which-key "Vertical split window")
       ;; Window motions
       "w h"   '(evil-window-left :which-key "Window left")
       "w j"   '(evil-window-down :which-key "Window down")
       "w k"   '(evil-window-up :which-key "Window up")
       "w l"   '(evil-window-right :which-key "Window right")
       "w w"   '(evil-window-next :which-key "Goto next window")
       ;; winner mode
       "w <left>"  '(winner-undo :which-key "Winner undo")
       "w <right>" '(winner-redo :which-key "Winner redo"))

;; magit keys
(nvmap :prefix "SPC"
    ;; Window splits
  "m s"   '(magit-status :which-key "Magit status"))

;; use vim keys in dired
(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
  (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
  (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
  (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file))

(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'feh' and all .mp4 files to open in 'mpv'

(setq dired-open-extensions '(("gif" . "feh")
                              ("jpg" . "feh")
                              ("jpeg" . "feh")
                              ("png" . "feh")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")))

;; jump to definition with 'gd'
(use-package dumb-jump)
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

(use-package flycheck
  :config
  (add-hook 'typescript-mode-hook 'flycheck-mode))
(global-flycheck-mode)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;; language and file specific
(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'top-right-corner))

(use-package markdown-mode)

;; python
(use-package python-mode)
(add-hook 'python-mode-hook #'(lambda ()
				;; Use spaces, not tabs.
				(setq indent-tabs-mode nil)
				'(setq python-indent 4)))

(add-hook 'python-mode-hook 'tree-sitter-hl-mode)
;; pip install 'python-lsp-server[all]'
(add-hook 'python-mode-hook #'lsp-deferred)
;; (use-package elpy)
;; (elpy-enable)

;; ruby/rails
(use-package ruby-mode)
(use-package projectile-rails)
(setq ruby-indent-level 2)
(add-hook 'ruby-mode-hook 'tree-sitter-hl-mode)
;; make sure emacs can find the solargraph executable
(setenv "PATH" (concat (getenv "PATH") ":/home/lucas/.local/share/gem/ruby/3.0.0/bin"))
(add-to-list 'exec-path "/home/lucas/.local/share/gem/ruby/3.0.0/bin")
;; gem install solargraph
(add-hook 'ruby-mode-hook #'lsp-deferred)

;; lisp family
(add-hook 'emacs-lisp-mode-hook
    (lambda ()
    ;; Use spaces, not tabs.
    (setq indent-tabs-mode nil)
    (setq emacs-lisp-indent 2)))
;; use-package lisp-mode)

;; typescript and nestjs
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-block-padding 2
        web-mode-comment-style 2

        web-mode-enable-css-colorization t
        web-mode-enable-auto-pairing t
        web-mode-enable-comment-keywords t
        web-mode-enable-current-element-highlight t
        )
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
		(setup-tide-mode))))
  (flycheck-add-mode 'typescript-tslint 'web-mode))

(use-package typescript-mode
  :config
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode #'subword-mode))

(use-package tide
  :init
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

(provide 'typescript)

;; better syntax highlighting and code folding
(use-package tree-sitter)
(use-package tree-sitter-langs)
(require 'tree-sitter)
(require 'tree-sitter-langs)
(global-tree-sitter-mode)

;; autocompletion via company
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  :config
  (setq company-show-numbers t)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above t))
(add-hook 'after-init-hook 'global-company-mode)

;; make company mode look better
(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package company-quickhelp
  :init
  (company-quickhelp-mode 1)
  (use-package pos-tip
    :ensure t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-quickhelp tide ag flycheck lsp-ui lsp-mode diff-hl elpy vterm which-key use-package tree-sitter-langs smex python-mode projectile-rails peep-dired neotree markdown-mode magit ivy-rich general gcmh evil-collection emojify dumb-jump doom-themes doom-modeline dired-open dashboard counsel company all-the-icons-dired)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
