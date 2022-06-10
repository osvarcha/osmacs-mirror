;;; init-search.el --- -*- lexical-binding: t -*-

(eval-when-compile
  (require 'init-global-config))

;; Avy
(use-package avy
  :blackout t
  :bind
  (("C-z C-c" . avy-goto-char-timer)
   ("C-z C-l" . avy-goto-line))
  :custom
  (avy-timeout-seconds 0.3)
  (avy-style 'pre)
  :custom-face
  (avy-lead-face ((t (:background "#51afef" :foreground "#870000" :weight bold)))));
;; -Avy

;; CtrlF
(use-package ctrlf
  :init
  (ctrlf-mode +1))
;; CtrlF

;; ColorRG
(use-package color-rg
  :blackout t
  :straight (color-rg :type git
                      :host github
                      :repo "manateelazycat/color-rg")
  :if (executable-find "rg")
  :bind ("C-z C-s" . color-rg-search-input))
;; -ColorRG

(provide 'init-search)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-search.el ends here
