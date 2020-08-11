(setq vc-follow-symlinks t)
;; (org-babel-load-file "~/.emacs.d/init.org")

(setq-default straight-use-package-by-default t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;

(straight-use-package 'use-package)

(use-package diminish
             :config
             (diminish 'auto-revert-mode))

;;

(when (eq system-type 'darwin)
  (use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize)))

(use-package leuven-theme
             :config
             (load-theme 'leuven t))

(set-face-attribute 'default nil :height 140)
(set-face-attribute 'default nil :font "Iosevka")

(setq inhibit-splash-screen t)
(setq ring-bell-function 'ignore) ; No bell

(tool-bar-mode -1)
(scroll-bar-mode -1)
(if (eq system-type 'darwin)
  (menu-bar-mode 1)
  (menu-bar-mode -1))
(fringe-mode 0) ; No padding around buffers

(setq make-backup-files nil
      auto-save-default nil)

(setq suggest-key-bindings nil)

(setq require-final-newline t)

(setq recentf-max-saved-items 100000)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(set-default 'truncate-lines t)
(set-display-table-slot standard-display-table 0 ?→)

(column-number-mode)

(defun md/kill-region-or-backward-word ()
  (interactive)
  (if (use-region-p)
      (kill-region (point) (mark))
    (backward-kill-word 1)))

(global-set-key (kbd "C-w") 'md/kill-region-or-backward-word)

(global-set-key (kbd "C-c C-a") 'align-regexp)

;;

(use-package undo-tree
             :diminish
             :init
             (setq undo-tree-enable-undo-in-region nil) ; Fixes "unrecognized entry in undo list" (https://www.reddit.com/r/emacs/comments/85t95p/undo_tree_unrecognized_entry_in_undo_list/).
             :config
             (global-undo-tree-mode))

(use-package direnv
             :config
             (setq direnv-show-paths-in-summary nil)
             (setq direnv-always-show-summary nil)
             (direnv-mode))

;; Dired

(setq dired-dwim-target t) ; Copy to other dired buffer if exists
(add-hook 'dired-mode-hook 'dired-omit-mode)
(require 'dired-x)
(setq-default dired-omit-files-p t) ; Buffer-local variable
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
(fset 'yes-or-no-p 'y-or-n-p) ; Ask for y/n instead of yes/no
(global-set-key (kbd "C-x C-j") 'dired-jump)

;; Ivy, counsel, swiper

(use-package ivy
             :diminish
             :config
             (use-package ivy-prescient
                          :config
                          (ivy-prescient-mode)
                          (prescient-persist-mode)
                          (ivy-mode))
             (setq ivy-use-selectable-prompt t)
             (setf (alist-get 'counsel-rg ivy-re-builders-alist) #'ivy--regex-plus))

(use-package counsel
             :bind (("C-c f" . counsel-recentf)
                    ("C-c s" . counsel-rg)
                    ("C-c g" . counsel-git)
                    ("C-c u" . counsel-unicode-char))
             :config
             (setq counsel-rg-base-command
                   "rg -i -M 120 --no-heading --line-number --color never %s ."))

(use-package swiper
             :bind ("C-s" . swiper))

;; Org mode

(setq org-fontify-whole-heading-line nil)

(setq org-ellipsis "⤵")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)

(setq org-src-window-setup 'current-window)

(setq org-directory "~/Dropbox/org")
(defun org-file-path (filename)
  "Return the absolute address of an org file, given its relative name."
  (concat (file-name-as-directory org-directory) filename))
(setq org-index-file (org-file-path "index.org"))
(setq org-archive-location
      (concat (org-file-path "archive.org") "::* From %s"))
(setq org-agenda-files (list org-index-file))
(setq org-todo-keywords
  '((sequence "TODO" "PROG" "WAIT" "APPT" "|" "DONE" "CANC" "DEFR")))

(setq org-refile-targets
      '((org-agenda-files :maxlevel . 9)
        (nil :maxlevel . 9)))
(setq org-refile-use-outline-path file)
(setq org-outline-path-complete-in-steps nil)

(defun md/open-index-file ()
  "Open the master org TODO list."
  (interactive)
  (find-file org-index-file))

(global-set-key (kbd "C-c i") 'md/open-index-file)

(setq org-capture-templates
    '(("r" "Reading"
       checkitem
       (file (org-file-path "to-read.org")))

      ("m" "Meeting Notes"
         entry
         (file+olp org-index-file "Meeting Notes")
         "* %^{Title}\nSCHEDULED: %t\n\n%?\n")

        ("t" "Todo"
         entry
         (file+headline org-index-file "Inbox")
         "* TODO %?\n")

        ;; TODO: Prompt person to discuss with
        ("d" "Discuss"
         item
         (file+olp org-index-file "Inbox")
         "%?\n")))

(setq org-agenda-custom-commands
      '(("w" todo "WAIT")))

(setq org-stuck-projects
      '("+PROJECT/-TODO" ("TODO")))

(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)

;;

(use-package which-key
             :diminish
             :config
             (which-key-mode))

(use-package default-text-scale
             :config
             (default-text-scale-mode))

(use-package restclient
             :mode "\\.http\\'")

(use-package magit
             :bind ("C-x g" . magit-status))

(use-package expand-region
             :bind (("C-=" . er/expand-region)
                    ("C--" . er/contract-region)))

(use-package markdown-mode)

(use-package toml-mode)

(use-package yaml-mode)

(use-package company
             :diminish
             :config
             (global-company-mode))

(use-package company-prescient
             :config
             (company-prescient-mode))

(use-package flycheck
             :diminish
                     ;                   :hook prog-mode
             )

(add-hook 'haskell-mode-hook 'flycheck-mode)


(add-hook 'flycheck-mode-hook
          (lambda ()
            (local-set-key (kbd "M-p") #'flycheck-previous-error)
            (local-set-key (kbd "M-n") #'flycheck-next-error)))

(use-package wgrep)

(use-package yasnippet
             :diminish yas-minor-mode
             :config
             (yas-global-mode))

;; I don't like when the text jumps around because the snippet fields have a border
;; in the leuven theme, therefore disable it (overwriting the [[https://github.com/fniessen/emacs-leuven-theme/blob/24cad6f573833c987f5b4ef48c4230e37023e8e9/leuven-theme.el#L1010][original definition]]).

(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'leuven
   `(yas-field-highlight-face ((,class (:foreground "black" :background "#D4DCD8"))))))

;; LSP

(use-package lsp-mode
  :commands lsp
  :config (require 'lsp-clients))

(use-package lsp-ui)

;; Haskell

(use-package haskell-mode)

(use-package dante)

(add-hook 'haskell-mode-hook 'dante-mode)
(add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)
(add-hook 'haskell-mode-hook
          (lambda ()
            (local-set-key (kbd "M-s") #'haskell-mode-stylish-buffer)))

(put 'dante-target 'safe-local-variable 'stringp)

(setq dante-repl-command-line
      '("cabal"
        "new-repl"
        dante-target
        "--disable-optimization"
        "--builddir=dist-newstyle/dante"))

(add-hook 'dante-mode-hook
   '(lambda () (flycheck-add-next-checker 'haskell-dante
                                          '(info . haskell-hlint))))

;; These functions run the current line through the =ppsh= executable (part of
;; [[https://hackage.haskell.org/package/pretty-show][pretty-show]]) and renders it as a nicely formatted and syntax highlighted haskell
;; snippet. Useful when used in conjunction with =dante-eval-block= (=C-c "=).

(defun md/ppsh ()
  (interactive)
  (if (eq (char-after (line-beginning-position)) ?-)
      (md/ppsh-offset 3)
    (md/ppsh-offset 0)
  ))

(defun md/ppsh-offset (offset)
  (get-buffer-create "!ppsh-output")
  (with-current-buffer "!ppsh-output"
    (delay-mode-hooks
      (haskell-mode)
      (font-lock-mode))
    (font-lock-ensure))
  (shell-command-on-region (+ offset (line-beginning-position))
                           (line-end-position)
                           "ppsh"
                           "!ppsh-output"))

;; Rust

(use-package rust-mode
  :hook (rust-mode . lsp))

(use-package flycheck-rust
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

;; Kotlin

(use-package kotlin-mode)

(setq kotlin-tab-width 4)

;; Nix

(use-package nix-mode)

;; Indentation

(setq tab-width 2)
(setq c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)

;; Target stuff

(setenv "TGT_NIX_ALLOW_UNTAGGED_DEPS" "1")
