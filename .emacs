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

;; Evil mode
(setq evil-want-C-u-scroll t)
(evil-mode)
(evil-magit-init)

;; Dired
(setq dired-dwim-target t) ; Copy to other dired buffer if exists
(add-hook 'dired-mode-hook 'dired-omit-mode)
(fset 'yes-or-no-p 'y-or-n-p) ; Ask for y/n instead of yes/no

;; Ivy, Counsel, Swiper
(ivy-mode)
(evil-set-initial-state 'ivy-occur-mode 'normal)

;; Trim long lines for performance reasons
(setq counsel-rg-base-command
      "rg -i -M 120 --no-heading --line-number --color never %s .")

;; Keyboard shortcuts
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c f") 'counsel-recentf)
(global-set-key (kbd "C-c b") 'switch-to-buffer)
(global-set-key (kbd "C-c a") 'align-regexp)
(global-set-key (kbd "C-x C-j") 'dired-jump)
(global-set-key (kbd "C-c s") 'counsel-rg)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c C-/") 'evil-avy-goto-char-timer)
(global-set-key (kbd "C-c u") 'counsel-unicode-char)
(with-eval-after-load 'evil-maps
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
   ("d" ace-delete-window "del" :color red)
   ("i" ace-maximize-window "ace-one")
   ("b" ivy-switch-buffer "buf")
   ("q" nil "quit")))

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

(setq dante-repl-command-line-methods-alist
      `((nix . ,(lambda (root)
                  (let ((shell-file (locate-dominating-file root "shell.nix")))
                        (when shell-file `("nix-shell"
                                           ,(concat (expand-file-name shell-file) "shell.nix")
                                           "--run"
                                           (concat "cabal new-repl "
                                                   (or dante-target "")
                                                   (if dante-disable-backpack " -f -elab-base-use-backpack" "")
                                                   " --builddir=dist-newstyle/dante"
                                                   (if dante-disable-backpack "-no-backpack" "")))))))))

;; Column limit
(setq-default fill-column 80)
(setq-default fci-rule-width 1)
(add-hook 'prog-mode-hook 'turn-on-fci-mode)

(defun on-off-fci-before-company(command)
  (when (string= "show" command)
    (turn-off-fci-mode))
  (when (string= "hide" command)
    (turn-on-fci-mode)))
(advice-add 'company-call-frontends :before #'on-off-fci-before-company)

;; Indentation
(setq tab-width 2)
(setq c-basic-offset 2)
(setq-default indent-tabs-mode nil)

(show-paren-mode t)

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

(setenv "TGT_NIX_ALLOW_UNTAGGED_DEPS" "1")

;;; End Target specific

;; Custom-set stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-stylish-on-save t))

;; Choose a recent file on startup
(setq recentf-max-saved-items 100000)
(counsel-recentf)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )