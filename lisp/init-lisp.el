;;; init-lisp.el --- setttings for lisp
;;; -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; -----------------------------------------------
;; Common Lisp
;; -----------------------------------------------
(use-package sly
  :ensure t
  :init
  ;; 指定你的 Common Lisp 实现，例如使用 SBCL
  (setq inferior-lisp-program "sbcl")
  :config
  ;; 启用 sly-fancy 增强功能
  (sly-setup '(sly-fancy)))

(use-package sly-asdf :after sly)
(use-package sly-quicklisp :after sly)
(use-package sly-macrostep :after sly)

(defun my/common-lisp-pair-behavior ()
  "在 SLY / Common Lisp 下也让光标留在括号内。"
  (setq-local electric-pair-inhibit-predicate
              (lambda (char)
                ;; 保留默认判断，但不要因为是 Lisp 就放到括号外
                (electric-pair-default-inhibit char))))

(add-hook 'sly-mode-hook #'my/common-lisp-pair-behavior)
(add-hook 'lisp-mode-hook #'my/common-lisp-pair-behavior)

;; -----------------------------------------------
;; Clojure Lisp
;; -----------------------------------------------
(use-package clojure-mode
  :straight t)

(use-package cider
  :straight t
  :hook (clojure-mode . cider-mode)
  :config
  (setq cider-repl-display-help-banner nil
        cider-allow-jack-in-without-project t
        cider-repl-pop-to-buffer-on-connect t))

(use-package flycheck-clj-kondo
  :straight t
  :after (flycheck clojure-mode))
  
;; ---------------------------------------------
;; 🔒 防止 clojure-mode 触发任何 lsp/eglot
;; ---------------------------------------------
(with-eval-after-load 'clojure-mode
  (setq-local lsp-enabled-clients nil)
  (remove-hook 'clojure-mode-hook #'lsp)
  (remove-hook 'clojure-mode-hook #'lsp-deferred)
  (remove-hook 'clojure-mode-hook #'eglot-ensure))

(use-package paredit
  :ensure t
  :hook ((lisp-mode
          emacs-lisp-mode
          clojure-mode
          clojurescript-mode
          slime-repl-mode
          sly-mrepl-mode
          cider-repl-mode) . enable-paredit-mode))

(provide 'init-lisp)
