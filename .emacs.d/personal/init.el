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
;; (require 'prelude-haskell)
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

;;: Evil customization:

; Remap Vim's C-] to Emacs' jump-to-tag
(defun my-jump-to-tag ()
    (interactive)
    (evil-emacs-state)
    (call-interactively (key-binding (kbd "M-.")))
    (evil-change-to-previous-state (other-buffer))
    (evil-change-to-previous-state (current-buffer)))

(define-key evil-normal-state-map (kbd "C-]") 'my-jump-to-tag)

;; Theme

(load-theme 'monokai)

;; Get package installation ready

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives ; for purescript-mode
             '("emacs-pe" . "https://emacs-pe.github.io/packages/"))
(package-initialize)

; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;; Modes:

;; intero and Haskell-mode
(use-package intero
  :ensure t)
(add-hook 'haskell-mode-hook 'intero-mode)

(require 'haskell-mode)
(define-key haskell-mode-map [f12] 'intero-devel-reload)

;; PureScript
(use-package purescript-mode
  :ensure t
  :pin emacs-pe)

(use-package psc-ide
  :ensure t)

(add-hook 'purescript-mode-hook
          (lambda ()
            (psc-ide-mode)
            (haskell-indentation-mode)
            (company-mode)))

;;; General editor niceties
(global-linum-mode t)
(column-number-mode t)
(setq-default indent-tabs-mode nil)
(setq-default show-trailing-whitespace t)

(provide 'init)
;;; init.el ends here
