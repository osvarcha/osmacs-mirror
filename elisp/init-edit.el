;;; init-edit.el --- -*- lexical-binding: t -*-

(eval-when-compile
  (require 'init-global-config))

;; IEditPac
(use-package iedit
  :bind ("C-z ," . iedit-mode)
  :blackout t)
;; -IEditPac

(provide 'init-edit)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-edit.el ends here
