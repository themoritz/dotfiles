;;; package -- Summary
;;;
;;; Commentary:
;;;
;;; Personal Emacs customization.  Used with Emacs prelude
;;; Put in your ~/.emacs.d/personal folder

;;; Code:

;;; Prelude packages -----------------------------------------------------------
 
(require 'prelude-helm) ;; Interface for narrowing and search
(require 'prelude-helm-everywhere) ;; Enable Helm everywhere
(require 'prelude-company)
(require 'prelude-evil)

;; Programming languages support
;; (require 'prelude-c)
;; (require 'prelude-clojure)
;; (require 'prelude-coffee)
;; (require 'prelude-common-lisp)
;; (require 'prelude-css)
;; (require 'prelude-emacs-lisp) ;; breaks intero-blacklist
;; (require 'prelude-erlang)
;; (require 'prelude-elixir)
;; (require 'prelude-go)
;; (require 'prelude-haskell)    ;; breaks intero-blacklist
;; (require 'prelude-js)         ;; breaks intero-blacklist
(require 'prelude-latex)
;; (require 'prelude-lisp)
;; (require 'prelude-ocaml)
;; (require 'prelude-org)
;; (require 'prelude-perl)
;; (require 'prelude-python)
;; (require 'prelude-ruby)
;; (require 'prelude-scala)
;; (require 'prelude-scheme)
(require 'prelude-shell)
(require 'prelude-scss)
;; (require 'prelude-web) ;; Emacs mode for web templates
;; (require 'prelude-xml)
(require 'prelude-yaml)

;;; Packages -------------------------------------------------------------------

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives ; for purescript-mode
             '("emacs-pe" . "https://emacs-pe.github.io/packages/"))
(package-initialize)

;;; Evil customization ---------------------------------------------------------

;; New binding for `eval-expression'
(define-key evil-normal-state-map (kbd "M-;") 'eval-expression)

(setq evil-want-C-u-scroll t)

;; Remap Vim's C-] to Emacs' jump-to-tag
(defun my-jump-to-tag ()
    (interactive)
    (evil-emacs-state)
    (call-interactively (key-binding (kbd "M-.")))
    (evil-change-to-previous-state (other-buffer))
    (evil-change-to-previous-state (current-buffer)))
(define-key evil-normal-state-map (kbd "C-]") 'my-jump-to-tag)

;; Smart parens
(use-package evil-smartparens
  :ensure t)
(add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)

;; No evil indent on open line since it interferes with haskell-mode
(setq-default evil-auto-indent nil)

;;; Misc -----------------------------------------------------------------------

(use-package evil-magit
  :ensure t)

;; Fix $PATH
(use-package exec-path-from-shell
  :ensure t)
(exec-path-from-shell-initialize)

;; Theme
(use-package monokai-theme
  :ensure t)
(load-theme 'monokai)

;;; Modes ----------------------------------------------------------------------

;; Nix
(require 'nix-mode)

;; Haskell
(custom-set-variables
  '(haskell-stylish-on-save t))

(add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)

(add-to-list 'grep-find-ignored-files "*.js_hi")
(add-to-list 'grep-find-ignored-files "*.js_o")
(add-to-list 'grep-find-ignored-files "*.js_dyn_hi")
(add-to-list 'grep-find-ignored-files "*.js_dyn_o")
(add-to-list 'grep-find-ignored-directories "*.jsexe")

;; Intero
(use-package intero
  :ensure t)
(setq intero-blacklist '("~/code/herculus/hexl/client"))
(add-hook 'haskell-mode-hook 'intero-mode-blacklist)

;; PureScript
(use-package purescript-mode
  :ensure t
  :pin emacs-pe)

(use-package psc-ide
  :ensure t
  :load-path "~/code/psc-ide-emacs")
(setq psc-ide-use-npm-bin t)

(add-hook 'purescript-mode-hook
          (lambda ()
            (psc-ide-mode)
            (turn-on-purescript-indentation)
            (flycheck-mode)
            (company-mode)))

;; Idris
(use-package idris-mode :ensure t)

;; Elm
(use-package elm-mode
  :ensure t)

;; JavaScript
(setq-default js2-basic-offset 2)
(setq js2-strict-missing-semi-warning nil)

;; CSS/SCSS
(setq-default css-indent-offset 2)

;;; General editor niceties ----------------------------------------------------
 
(setq tab-width 2)
(setq c-basic-offset 2)

;; Disable whitespace mode
(setq prelude-whitespace nil)

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
(setq-default fill-column 80)
(setq-default fci-rule-width 2)
(add-hook 'prog-mode-hook 'turn-on-fci-mode)

(defun on-off-fci-before-company(command)
  (when (string= "show" command)
    (turn-off-fci-mode))
  (when (string= "hide" command)
    (turn-on-fci-mode)))

;;; Font -----------------------------------------------------------------------

(when (window-system)
  (set-default-font "Fira Code"))

;; To prevent bug where bold face is narrower than regular
(set-face-attribute 'default nil :family "Fira Code")
(set-face-attribute 'default nil :height 115)
(set-face-attribute 'default nil :weight 'regular)
(set-face-attribute 'bold nil :family "Fira Code")
(set-face-attribute 'bold nil :height 117)
(set-face-attribute 'bold nil :weight 'bold)

;; -----------------------------------------------------------------------------

(provide 'init)
;;; init.el ends here
