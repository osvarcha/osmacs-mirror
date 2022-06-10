;;; init-package.el --- -*- lexical-binding: t -*-

;; BootstrapStraight
(setq straight-check-for-modifications nil)
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

;; Load the helper package for commands like `straight-x-clean-unused-repos'
(require 'straight-x)
;; -BootstrapStraight

;; ConfigureUsePackage
;; Use straight.el for use-package expressions
(straight-use-package 'use-package)
;; Install use-package if not installed

;; Configure use-package to use straight.el by default
(use-package straight
             :custom (straight-use-package-by-default t))

;; (eval-and-compile
;;   (setq use-package-always-ensure t)
;;   (setq use-package-expand-minimally t)
;;   (setq use-package-compute-statistics t)
;;   (setq use-package-enable-imenu-support t))

;; (eval-when-compile
;;   (require 'use-package)
;;   (require 'bind-key))
(setq use-package-always-defer t)
;; -ConfigureUsePackage

;; Blackout
(use-package blackout
  :demand t)
;; -Blackout

(provide 'init-package)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-package.el ends here
