(package-initialize)

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

;; Ivy, Counsel, Swiper
(ivy-mode)
(evil-set-initial-state 'ivy-occur-mode 'normal)

;; Trim long lines for performance reasons
(setq counsel-rg-base-command
      "rg -i -M 120 --no-heading --line-number --color never %s .")

;; Keyboard shortcuts
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c f") 'counsel-recentf)
(global-set-key (kbd "C-c a") 'align-regexp)
(global-set-key (kbd "C-x C-j") 'dired-jump)
(global-set-key (kbd "C-c s") 'counsel-rg)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c C-/") 'evil-avy-goto-char-timer)
(global-set-key (kbd "C-c u") 'counsel-unicode-char)
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "/") 'swiper))

;; Hydras
(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

;; No evil indent on open line since it interferes with haskell-mode
(add-hook 'haskell-mode-hook
  (lambda ()
    (setq-local evil-auto-indent nil)))

(add-hook 'haskell-mode-hook 'dante-mode)

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

;; Mac Hacks (from Tikhon Jelvis)
(when (eq system-type 'darwin)
  ;(setq mac-command-modifier 'meta)
  ;(setq mac-option-modifier nil)
  (let ((nix-vars '("NIX_LINK"
                    "NIX_PATH"
                    "SSL_CERT_FILE")))
    (when (memq window-system '(mac ns))
      (exec-path-from-shell-initialize) ; $PATH, $MANPATH and set exec-path
      (mapcar 'exec-path-from-shell-copy-env nix-vars))))

;; Custom-set stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-stylish-on-save t))

;; Choose a recent file on startup
(counsel-recentf)
