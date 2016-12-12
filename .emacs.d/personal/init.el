;;; package -- Summary
;;;
;;; Commentary:
;;;
;;; Personal Emacs customization.  Used with Emacs prelude
;;; Put in your ~/.emacs.d/personal folder

;;; Code:

;;; Prelude packages
(require 'prelude-helm) ;; Interface for narrowing and search
(require 'prelude-helm-everywhere) ;; Enable Helm everywhere
(require 'prelude-company)
(setq evil-want-C-u-scroll t)
(require 'prelude-evil)

;;; Programming languages support
;; (require 'prelude-c)
;; (require 'prelude-clojure)
;; (require 'prelude-coffee)
;; (require 'prelude-common-lisp)
;; (require 'prelude-css)
(require 'prelude-emacs-lisp)
;; (require 'prelude-erlang)
;; (require 'prelude-elixir)
;; (require 'prelude-go)
(require 'prelude-haskell)
(require 'prelude-js)
(require 'prelude-latex)
;; (require 'prelude-lisp)
;; (require 'prelude-ocaml)
;; (require 'prelude-org) ;; Org-mode helps you keep to do lists, notes and more
;; (require 'prelude-perl)
;; (require 'prelude-python)
;; (require 'prelude-ruby)
;; (require 'prelude-scala)
;; (require 'prelude-scheme)
(require 'prelude-shell)
;; (require 'prelude-scss)
;; (require 'prelude-web) ;; Emacs mode for web templates
;; (require 'prelude-xml)
;; (require 'prelude-yaml)

; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;: Evil customization:

; Remap Vim's C-] to Emacs' jump-to-tag
(defun my-jump-to-tag ()
    (interactive)
    (evil-emacs-state)
    (call-interactively (key-binding (kbd "M-.")))
    (evil-change-to-previous-state (other-buffer))
    (evil-change-to-previous-state (current-buffer)))

(define-key evil-normal-state-map (kbd "C-]") 'my-jump-to-tag)

(use-package evil-magit
  :ensure t)

;; Theme

(use-package monokai-theme
  :ensure t)
(load-theme 'monokai)

;; Get package installation ready

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives ; for purescript-mode
             '("emacs-pe" . "https://emacs-pe.github.io/packages/"))
(package-initialize)

;;; Modes:

;; Haskell
(custom-set-variables
 '(haskell-stylish-on-save t))

(add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)

;; intero and Haskell-mode
; (use-package intero
;   :ensure t)
; (add-hook 'haskell-mode-hook 'intero-mode)

; (require 'haskell-mode)
; (define-key haskell-mode-map [f12] 'intero-devel-reload)

;; PureScript
; (use-package purescript-mode
;   :ensure t
;   :pin emacs-pe)
;
; (use-package psc-ide
;   :ensure t)

; (add-hook 'purescript-mode-hook
;           (lambda ()
;             (psc-ide-mode)
;             (haskell-indentation-mode)
;             (company-mode)))

; (use-package flycheck-purescript
;   :ensure t)
; (eval-after-load 'flycheck
;   '(flycheck-purescript-setup))

;; Elm

(use-package elm-mode
  :ensure t)

;; JavaScript
(setq-default js2-basic-offset 2)
(setq js2-strict-missing-semi-warning nil)

;; CSS/SCSS
(setq-default css-indent-offset 2)

;;; General editor niceties
(global-linum-mode t)
(column-number-mode t)
(setq-default indent-tabs-mode nil)
(setq-default show-trailing-whitespace t)
(global-auto-revert-mode t)
(scroll-bar-mode -1)
(diff-hl-mode -1)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome-stable")

(advice-add 'company-call-frontends :before #'on-off-fci-before-company)

;; Column limit
(use-package fill-column-indicator
  :ensure t)
(setq-default whitespace-line-column -1)
(setq-default fill-column 80)
(setq-default fci-rule-width 2)
(add-hook 'prog-mode-hook 'turn-on-fci-mode)

(defun on-off-fci-before-company(command)
  (when (string= "show" command)
    (turn-off-fci-mode))
  (when (string= "hide" command)
    (turn-on-fci-mode)))

;; No evil indent on open line since it interferes with haskell-mode
(setq-default evil-auto-indent nil)

(provide 'init)
;;; init.el ends here
