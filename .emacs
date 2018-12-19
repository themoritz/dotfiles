(package-initialize)

;; Mac Hacks (from Tikhon Jelvis)
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil)
  (let ((nix-vars '("NIX_LINK"
                    "NIX_PATH"
                    "SSL_CERT_FILE")))
    (when (memq window-system '(mac ns))
      (exec-path-from-shell-initialize) ; $PATH, $MANPATH and set exec-path
      (mapcar 'exec-path-from-shell-copy-env nix-vars))))

(setq direnv-show-paths-in-summary nil)
(setq direnv-always-show-summary nil)
(direnv-mode)

;; Get rid of the annoying splash screen
(setq inhibit-splash-screen t)

;; Theme
(load-theme 'monokai t)

;; Powerline
(powerline-default-theme)

;; Remove GUI elements
(tool-bar-mode -1)
(scroll-bar-mode -1)
(if (eq system-type 'darwin)
  (menu-bar-mode 1)
  (menu-bar-mode -1))
(fringe-mode 0) ; No padding around buffers
(setq ring-bell-function 'ignore) ; No bell

;; Evil mode
(setq evil-want-C-u-scroll t)
(evil-mode)
(evil-magit-init)
(global-evil-surround-mode 1)

;; Magit
(add-hook 'with-editor-mode-hook 'evil-insert-state)

;; Dired
(setq dired-dwim-target t) ; Copy to other dired buffer if exists
(add-hook 'dired-mode-hook 'dired-omit-mode)
(require 'dired-x)
(setq-default dired-omit-files-p t) ; Buffer-local variable
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
(fset 'yes-or-no-p 'y-or-n-p) ; Ask for y/n instead of yes/no

;; Ivy, Counsel, Swiper
(ivy-mode)
(evil-set-initial-state 'ivy-occur-mode 'normal)

;; Trim long lines for performance reasons
(setq counsel-rg-base-command
      "rg -i -M 120 --no-heading --line-number --color never %s .")

;; Keyboard shortcuts
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c f") 'counsel-recentf)
(global-set-key (kbd "C-c b") 'switch-to-buffer)
(global-set-key (kbd "C-c a") 'align-regexp)
(global-set-key (kbd "C-x C-j") 'dired-jump)
(global-set-key (kbd "C-c s") 'counsel-rg)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c C-/") 'evil-avy-goto-char-timer)
(global-set-key (kbd "C-c u") 'counsel-unicode-char)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C--") 'er/contract-region)
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "C-]") 'xref-find-definitions)
  (define-key evil-motion-state-map (kbd "/") 'swiper))

;; Ace-window
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

;; Hydras
(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

(global-set-key
 (kbd "C-w")
 (defhydra hydra-window (:color blue)
   "window"
   ("h" windmove-left)
   ("l" windmove-right)
   ("j" windmove-down)
   ("k" windmove-up)
   ("v" (lambda ()
          (interactive)
          (split-window-right)
          (windmove-right))
    "vert")
   ("x" (lambda ()
          (interactive)
          (split-window-below)
          (windmove-down))
    "horiz")
   ("o" delete-other-windows "one")
   ("C-w" ace-window "ace")
   ("s" ace-swap-window "swap")
   ("d" ace-delete-window "del")
   ("i" ace-maximize-window "ace-one")
   ("b" ivy-switch-buffer "buf")
   ("q" nil "quit")))

;; Engine mode ('C-x /')
(engine-mode t)
(defengine duckduckgo
  "https://duckduckgo.com/?q=%s"
  :keybinding "d")
(defengine hayoo
  "https://hayoo.fh-wedel.de/?query=%s"
  :keybinding "h")

;; Unset evil's window manipulation bindings for our window hydra to work.
(with-eval-after-load 'evil-maps
  (dolist (map '(evil-motion-state-map
                 evil-insert-state-map
                 evil-emacs-state-map))
    (define-key (eval map) "\C-w" nil)))

;; No evil indent on open line since it interferes with haskell-mode
(add-hook 'haskell-mode-hook
  (lambda ()
    (setq-local evil-auto-indent nil)))

;; Flycheck mode must come before the dante-mode hook
;; (https://github.com/jyp/dante/issues/58)
(add-hook 'haskell-mode-hook 'flycheck-mode)
(add-hook 'haskell-mode-hook 'dante-mode)
(put 'dante-target 'safe-local-variable 'stringp)

(defcustom dante-disable-backpack nil
  "Whether backpack needs to be disabled."
  :group 'dante
  :type '(choice (const nil) (const t)))
(put 'dante-disable-backpack 'safe-local-variable 'booleanp)

(setq dante-repl-command-line
      '("cabal" "new-repl" dante-target "--disable-optimization" "--builddir=dist-newstyle/dante"))
;(setq dante-repl-command-line-methods-alist
   ;   `((dir . ,(lambda (root)
   ;               (let ((envrc-file (locate-dominating-file root "shell.nix")))
   ;                     (when shell-file `("nix-shell"
   ;                                        ,(concat (expand-file-name shell-file) "shell.nix")
   ;                                        "--run"
   ;                                        (concat "cabal new-repl "
   ;                                                (or dante-target "")
   ;                                                (if dante-disable-backpack " -f -elab-base-use-backpack" "")
   ;                                                " --builddir=dist-newstyle/dante"
   ;                                                (if dante-disable-backpack "-no-backpack" "")))))))))

(add-hook 'dante-mode-hook
   '(lambda () (flycheck-add-next-checker 'haskell-dante
                '(info . haskell-hlint))))

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
  (shell-command-on-region (+ offset (line-beginning-position)) (line-end-position) "ppsh" "!ppsh-output"))

;; Rust
(setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "~/code/rust/src") ;; Rust source code PATH

(add-hook 'rust-mode-hook 'flycheck-mode)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;; Org
(add-hook 'org-mode-hook #'org-bullets-mode)
(setq org-ellipsis "⤵")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
; (add-hook 'org-mode-hook 'flyspell-mode)
(setq org-directory "~/org")
(defun org-file-path (filename)
  "Return the absolute address of an org file, given its relative name."
  (concat (file-name-as-directory org-directory) filename))
(setq org-inbox-file (org-file-path "inbox.org"))
(setq org-index-file (org-file-path "index.org"))
(setq org-archive-location
      (concat (org-file-path "archive.org") "::* From %s"))
(setq org-agenda-files (list org-index-file))
(setq org-todo-keywords
  '((sequence "TODO" "WAITING" "|" "DONE")))

;; org-capture
(setq org-capture-templates
      '(("e" "Email" entry
         (file+headline org-index-file "Inbox")
         "* TODO %?\n\n%a\n\n")

        ("r" "Reading"
         checkitem
         (file (org-file-path "to-read.org")))

        ("t" "Todo"
         entry
         (file+headline org-index-file "Inbox")
         "* TODO %?\n")))
(add-hook 'org-capture-mode-hook 'evil-insert-state)

(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)

;; Column limit
(setq-default fill-column 80)
(setq-default fci-rule-width 1)
(add-hook 'prog-mode-hook 'turn-on-fci-mode)

;; Company
(add-hook 'after-init-hook 'global-company-mode)
(defun on-off-fci-before-company(command)
  (when (string= "show" command)
    (turn-off-fci-mode))
  (when (string= "hide" command)
    (turn-on-fci-mode)))
(advice-add 'company-call-frontends :before #'on-off-fci-before-company)

;; Diminish
(diminish 'ivy-mode)
(diminish 'undo-tree-mode)
(diminish 'company-mode)
(diminish 'flycheck-mode)
(diminish 'eldoc-mode)
(diminish 'auto-revert-mode)

;; Indentation
(setq tab-width 2)
(setq c-basic-offset 2)
(setq-default indent-tabs-mode nil)

(show-paren-mode t)

;; Disable backups and autosaving
(setq make-backup-files nil
      auto-save-default nil)

;; Disable annying help message
(setq suggest-key-bindings nil)

(setq gc-cons-threshold 20000000)

(setq require-final-newline t)

;;; Target specific

(defun get-last-rev (repo ref)
  (interactive (list (read-string "Repo: ")
                     (read-string "Branch: ")))
  (insert (string-trim-right
           (shell-command-to-string (format "github-query last-rev RedOptHaskell %s %s" repo ref)))))

(global-set-key (kbd "C-c C-l r") 'get-last-rev)

(defun get-last-release-tag (repo)
  (interactive (list (read-string "Repo: ")))
  (insert (string-trim-right
           (shell-command-to-string (format "github-query last-release-tag RedOptHaskell %s" repo)))))

(global-set-key (kbd "C-c C-l t") 'get-last-release-tag)

(defun org-jira (ticket)
  (interactive (list (read-string "Ticket: ")))
  (insert (concat "[[https://jira.target.com/browse/" ticket "][" ticket "]]")))

(defun org-github-pr (repo pr)
  (interactive (list (read-string "Repo: ")
                     (read-string "PR: ")))
  (insert (concat "[[https://git.target.com/RedOptHaskell/" repo "/pull/" pr "][" repo "#" pr "]]")))

(setenv "TGT_NIX_ALLOW_UNTAGGED_DEPS" "1")

;;; End Target specific

;; Custom-set stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-stylish-on-save t)
 '(safe-local-variable-values (quote ((haskell-process-type . cabal-new-repl)))))

;; Choose a recent file on startup
(setq recentf-max-saved-items 100000)
(counsel-recentf)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
