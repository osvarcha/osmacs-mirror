;;; init-vundo.el --- -*- lexical-binding: t -*-

;; Vundo
(use-package vundo
  :commands (vundo)

  :straight (vundo :type git :host github :repo "casouri/vundo")

  :config
  ;; Take less on-screen space.
  (setq vundo-compact-display t)

  ;; Better contrasting highlight.
  (custom-set-faces
    '(vundo-node ((t (:foreground "#808080"))))
    '(vundo-stem ((t (:foreground "#808080"))))
    '(vundo-highlight ((t (:foreground "#FFFF00")))))
  :blackout t)
;; -Vundo

(provide 'init-vundo)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-vundo.el ends here
