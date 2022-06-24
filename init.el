;;; init.el --- Summary:
;;; -*- lexical-binding: t; -*-
;;
;;  Emacs configuration for Jeremy Friesen
;;
;;; Commentary:
;;
;;  This is my journey into Emacs.  Let's see where we go!
;;
;;; CODE:
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file :noerror)
;; During loading of init file, disable checking filenames against the list of
;; filetype handlers. This speeds up startup, as otherwise this list would be
;; checked for every loaded .el and .elc file.
(let ((file-name-handler-alist nil))
  ;; Load the remainder of the configuration from the Org configuration file.
  (org-babel-load-file (concat user-emacs-directory "README.org")))
;; (load (concat user-emacs-directory "hide-comnt.el") :noerror)
(provide 'init)
;;; init.el ends here
(put 'narrow-to-region 'disabled nil)
