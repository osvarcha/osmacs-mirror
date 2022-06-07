;;; init.el --- -*- lexical-binding: t -*-

;; BetterGC
(defvar better-gc-cons-threshold 134217728 ; 128mb
  "The default value to use for `gc-cons-threshold'.
If you experience freezing, decrease this.  If you experience stuttering, increase this.")

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold better-gc-cons-threshold)
            (setq file-name-handler-alist file-name-handler-alist-original)
            (makunbound 'file-name-handler-alist-original)))
;; -BetterGC

;; AutoGC
(add-hook 'emacs-startup-hook
          (lambda ()
            (if (boundp 'after-focus-change-function)
                (add-function :after after-focus-change-function
                              (lambda ()
                                (unless (frame-focus-state)
                                  (garbage-collect))))
              (add-hook 'after-focus-change-function 'garbage-collect))
            (defun gc-minibuffer-setup-hook ()
              (setq gc-cons-threshold (* better-gc-cons-threshold 2)))

            (defun gc-minibuffer-exit-hook ()
              (garbage-collect)
              (setq gc-cons-threshold better-gc-cons-threshold))

            (add-hook 'minibuffer-setup-hook #'gc-minibuffer-setup-hook)
            (add-hook 'minibuffer-exit-hook #'gc-minibuffer-exit-hook)))
;; -AutoGC

;; LoadPath
(defun update-to-load-path (folder)
  "Update FOLDER and its subdirectories to `load-path'."
  (let ((base folder))
    (unless (member base load-path)
      (add-to-list 'load-path base))
    (dolist (f (directory-files base))
      (let ((name (concat base "/" f)))
        (when (and (file-directory-p name)
                   (not (equal f ".."))
                   (not (equal f ".")))
          (unless (member base load-path)
            (add-to-list 'load-path name)))))))

(update-to-load-path (expand-file-name "elisp" user-emacs-directory))
;; -LoadPath

;; Constants
(require 'init-const)

;; Packages

;; Package Management
(require 'init-package)

;; Global Functionalities
(require 'init-global-config)

(require 'init-func)

;; (require 'init-search)

;; (require 'init-crux)

;; (require 'init-avy)

;; (require 'init-winner)

;; (require 'init-which-key)

;; (require 'init-popup-kill-ring)

;; (require 'init-undo-tree)

;; (require 'init-discover-my-major)

;; (require 'init-ace-window)

;; (require 'init-shell)

;; (require 'init-dired)

;; (require 'init-buffer)

;; UI Enhancements
;; (require 'init-ui-config)

;; (require 'init-theme)

;; (require 'init-dashboard)

;; (require 'init-fonts)

;; (require 'init-scroll)

;; General Programming
;; (require 'init-magit)

;; (require 'init-projectile)

;; (require 'init-yasnippet)

;; (require 'init-syntax)

;; (require 'init-dumb-jump)

;; (require 'init-parens)

;; (require 'init-indent)

;; (require 'init-quickrun)

;; (require 'init-format)

;; (require 'init-comment)

;; (require 'init-edit)

;; (require 'init-header)

;; (require 'init-ein)

;; (require 'init-lsp)

;; (require 'init-company)

;; Programming
;; (require 'init-java)

;; (require 'init-cc)

;; (require 'init-python)

;; (require 'init-haskell)

;; (require 'init-ess)

;; (require 'init-latex)

;; (require 'init-buildsystem)

;; Web Development
;; (require 'init-webdev)

;; Office
(require 'init-org)

;; (require 'init-pdf)

;; Internet
;; (require 'init-eaf)

;; (require 'init-erc)

;; (require 'init-mu4e)

;; (require 'init-tramp)

;; (require 'init-leetcode)

;; (require 'init-debbugs)

;; (require 'init-hackernews)

;; (require 'init-eww)

;; Miscellaneous
;; (require 'init-chinese)

;; (require 'init-games)

;; (require 'init-epaint)

;; (require 'init-zone)

;; InitPrivate
;; Load init-private.el if it exists
(when (file-exists-p (expand-file-name "init-private.el" user-emacs-directory))
  (load-file (expand-file-name "init-private.el" user-emacs-directory)))
;; -InitPrivate

(provide 'init)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el ends here
