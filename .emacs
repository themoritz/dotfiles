(package-initialize)

;; Get rid of the annoying splash screen:
(setq inhibit-splash-screen t)

(load-theme 'monokai t)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(if (eq system-type 'darwin)
  (menu-bar-mode 1)
  (menu-bar-mode -1))
(fringe-mode 0)

(setq evil-want-C-u-scroll t)
(evil-mode)
(evil-magit-init)

(global-set-key (kbd "C-x g") 'magit-status)

(ivy-mode)
(counsel-projectile-mode)

(powerline-default-theme)

;; Have a list of recent files:
(global-set-key (kbd "C-c f") 'counsel-recentf)
(global-set-key (kbd "C-x a") 'align-regexp)

;; Haskell
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-stylish-on-save t)
 '(safe-local-variable-values (quote ((dante-target . "herculus-lib")))))

(add-hook 'haskell-mode-hook 'dante-mode)


;; General niceties
(setq tab-width 2)
(setq c-basic-offset 2)
(setq dired-dwim-target t)
(setq-default fill-column 80)

;; Underline matching braces
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(sp-show-pair-match-face ((t (:background nil :foreground nil :inverse-video nil :underline "#F92672" :weight normal)))))

;; Choose a recent file on startup
(counsel-recentf)
