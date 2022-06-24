;; [[file:README.org::*Package Managent][Package Managent:1]]
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
;; Package Managent:1 ends here

;; [[file:README.org::*Use-Package][Use-Package:1]]
(straight-use-package 'use-package)
;; Configure use-package to use straight.el by default
(use-package straight
	     :custom (straight-use-package-by-default t))
(setq use-package-always-defer t)
;; Use-Package:1 ends here

;; [[file:README.org::*Blackout][Blackout:1]]
(use-package blackout
  :demand t)
;; Blackout:1 ends here

;; [[file:README.org::*el-patch][el-patch:1]]
(use-package el-patch)
;; Only needed at compile time, thanks to Jon
;; <https://github.com/radian-software/el-patch/pull/11>.
(eval-when-compile
  (require 'el-patch))
;; el-patch:1 ends here

;; [[file:README.org::*These are some general configurations that I’ve slowly accumulated.][These are some general configurations that I’ve slowly accumulated.:1]]
;; SmallCOnfigs
(setq user-full-name "Jeremy Friesen"
      user-mail-address "jeremy@jeremyfriesen.com")

;; Ask before killing emacs
(setq confirm-kill-emacs 'y-or-n-p)

;; So Long mitigates slowness due to extremely long lines.
;; Currently available in Emacs master branch *only*!
(when (fboundp 'global-so-long-mode)
  (global-so-long-mode))

;; Move the backup fies to user-emacs-directory/.backup
(setq backup-directory-alist `(("." . ,(expand-file-name ".backup" user-emacs-directory))))

;; UTF8Coding
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))
;; -UTF8Coding

;; EditExp
;; Remove useless whitespace before saving a file
(defun delete-trailing-whitespace-except-current-line ()
  "An alternative to `delete-trailing-whitespace'.
    The original function deletes trailing whitespace of the current line."
  (interactive)
  (let ((begin (line-beginning-position))
	(end (line-end-position)))
    (save-excursion
      (when (< (point-min) (1- begin))
	(save-restriction
	  (narrow-to-region (point-min) (1- begin))
	  (delete-trailing-whitespace)
	  (widen)))
      (when (> (point-max) (+ end 2))
	(save-restriction
	  (narrow-to-region (+ end 2) (point-max))
	  (delete-trailing-whitespace)
	  (widen))))))

(defun smart-delete-trailing-whitespace ()
  "Invoke `delete-trailing-whitespace-except-current-line' on selected major modes only."
  (unless (member major-mode '(diff-mode))
    (delete-trailing-whitespace-except-current-line)))

(add-hook 'before-save-hook #'smart-delete-trailing-whitespace)

;; Replace selection on insert
(delete-selection-mode 1)

;; Map Alt key to Meta
(setq x-alt-keysym 'meta)
;; -EditExp

;; History
(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :custom
  (recentf-auto-cleanup "05:00am")
  (recentf-max-saved-items 200)
  (recentf-exclude '((expand-file-name package-user-dir)
		     ".cache"
		     ".cask"
		     ".elfeed"
		     "bookmarks"
		     "cache"
		     "ido.*"
		     "persp-confs"
		     "recentf"
		     "undo-tree-hist"
		     "url"
		     "COMMIT_EDITMSG\\'")))

;; When buffer is closed, saves the cursor location
(save-place-mode 1)

;; Set history-length longer
(setq-default history-length 500)
;; -History

(menu-bar-mode -1)
(unless (and (display-graphic-p) (eq system-type 'darwin))
  (push '(menu-bar-lines . 0) default-frame-alist))
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
;; No toolbar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; No scroll bars
(if (fboundp 'scroll-bar-mode) (set-scroll-bar-mode nil))

;; EnableUTF8
;; Contrary to what many Emacs users have in their configs, you don't need
;; more than this to make UTF-8 the default coding system:
(set-language-environment "UTF-8")
(set-charset-priority 'unicode)
(setq locale-coding-system   'utf-8)   ; pretty
(set-terminal-coding-system  'utf-8-unix)   ; pretty
(set-keyboard-coding-system  'utf-8)   ; pretty
(set-selection-coding-system 'utf-8)   ; please
(prefer-coding-system        'utf-8)   ; with sugar on top
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))
;; -EnableUTF8

(fido-vertical-mode t)
;; These are some general configurations that I’ve slowly accumulated.:1 ends here

;; [[file:README.org::*ShortKeys][ShortKeys:1]]
(global-set-key (kbd "C-z") nil)
;; ShortKeys:1 ends here

;; [[file:README.org::*Avy][Avy:1]]
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
;; Avy:1 ends here

;; [[file:README.org::*CtrlF][CtrlF:1]]
;; CtrlF
(use-package ctrlf
  :init
  (ctrlf-mode +1))
;; CtrlF
;; CtrlF:1 ends here

;; [[file:README.org::*ColorRG][ColorRG:1]]
;; ColorRG
(use-package color-rg
  :blackout t
  :straight (color-rg :type git
                      :host github
                      :repo "manateelazycat/color-rg")
  :if (executable-find "rg")
  :bind ("C-z C-s" . color-rg-search-input))
;; -ColorRG
;; ColorRG:1 ends here

;; [[file:README.org::*Dired][Dired:1]]
;; DiredPackage
(use-package dired
  :ensure nil
  :straight nil
  :bind
  (("C-x C-j" . dired-jump))
  :custom
  ;; Always delete and copy recursively
  (dired-listing-switches "-lah")
  (dired-recursive-deletes 'always)
  (dired-recursive-copies 'always)
  ;; Auto refresh Dired, but be quiet about it
  (global-auto-revert-non-file-buffers t)
  (auto-revert-verbose nil)
  ;; Quickly copy/move file in Dired
  (dired-dwim-target t)
  ;; Move files to trash when deleting
  (delete-by-moving-to-trash t)
  ;; Load the newest version of a file
  (load-prefer-newer t)
  ;; Detect external file changes and auto refresh file
  (auto-revert-use-notify nil)
  (auto-revert-interval 3) ; Auto revert every 3 sec
  :config
  ;; Enable global auto-revert
  (global-auto-revert-mode t)
  ;; Reuse same dired buffer, to prevent numerous buffers while navigating in dired
  (put 'dired-find-alternate-file 'disabled nil)
  :hook
  (dired-mode . (lambda ()
		  (local-set-key (kbd "<mouse-2>") #'dired-find-alternate-file)
		  (local-set-key (kbd "RET") #'dired-find-alternate-file)
		  (local-set-key (kbd "^")
				 (lambda () (interactive) (find-alternate-file "..")))))
  )
;; -DiredPackage
;; Dired:1 ends here

;; [[file:README.org::*Iedit][Iedit:1]]
;; IEditPac
(use-package iedit
  :bind ("C-z ," . iedit-mode)
  :blackout t)
;; -IEditPac
;; Iedit:1 ends here

;; [[file:README.org::*Sudo Edit][Sudo Edit:1]]
;; SudoEditPac
(use-package sudo-edit
  :commands (sudo-edit))
;; -SudoEditPac
;; Sudo Edit:1 ends here

;; [[file:README.org::*Marginalia][Marginalia:1]]
;; Marginalia
;; Enable richer annotations using the Marginalia package
(use-package marginalia
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
	 :map minibuffer-local-map
	 ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets

  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))
;; -Marginalia
;; Marginalia:1 ends here

;; [[file:README.org::*Vundo][Vundo:1]]
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
;; Vundo:1 ends here

;; [[file:README.org::*Theme][Theme:1]]
;; DoomThemes
(use-package doom-themes
  :no-require t
  :functions (true-color-p)
  :demand t
  :custom-face
  (cursor ((t (:background "BlanchedAlmond"))))
  :config
  ;; flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  (load-theme 'doom-acario-dark t)
  (defun switch-theme ()
    "An interactive funtion to switch themes."
    (interactive)
    (disable-theme (intern (car (mapcar #'symbol-name custom-enabled-themes))))
    (call-interactively #'load-theme)))
;; -DoomThemes

;; DoomModeline
(use-package doom-modeline
  :no-require t
  :demand t
  :functions (true-color-p)
  :custom
  ;; Don't compact font caches during GC. Windows Laggy Issue
  (inhibit-compacting-font-caches t)
  (doom-modeline-minor-modes t)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-height 15)
  :config
  (doom-modeline-mode))
  ;; -DoomModeline
;; Theme:1 ends here

;; [[file:README.org::*Vundo][Vundo:1]]
;; YASnippetPac
(use-package yasnippet
  :blackout yas-minor-mode
  :init
  (use-package yasnippet-snippets :after yasnippet)
  :hook ((prog-mode LaTeX-mode org-mode markdown-mode) . yas-minor-mode)
  :bind
  (:map yas-minor-mode-map ("C-c C-n" . yas-expand-from-trigger-key))
  (:map yas-keymap
	(("TAB" . smarter-yas-expand-next-field)
	 ([(tab)] . smarter-yas-expand-next-field)))
  :config
  (yas-reload-all)
  (defun smarter-yas-expand-next-field ()
    "Try to `yas-expand' then `yas-next-field' at current cursor position."
    (interactive)
    (let ((old-point (point))
	  (old-tick (buffer-chars-modified-tick)))
      (yas-expand)
      (when (and (eq old-point (point))
		 (eq old-tick (buffer-chars-modified-tick)))
	(ignore-errors (yas-next-field))))))
;; -YASnippetPac
;; Vundo:1 ends here

;; [[file:README.org::*Emacs Adjustments for Completion][Emacs Adjustments for Completion:1]]
(use-package emacs
  :init

  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  (setq read-extended-command-predicate
	#'command-completion-default-include-p)

  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete)

  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
	'(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))
;; Emacs Adjustments for Completion:1 ends here

;; [[file:README.org::*Consult][Consult:1]]
(use-package consult
   :straight t
   ;; Replace bindings. Lazily loaded due by `use-package'.
   :bind (;; C-c bindings (mode-specific-map)
	  ("C-c h" . consult-history)
	  ;; ("C-c m" . consult-mode-command)
	  ("C-c b" . consult-bookmark)
	  ("C-c k" . consult-kmacro)
	  ;; C-x bindings (ctl-x-map)
	  ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complet-command
	  ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
	  ("s-b" . consult-buffer)                ;; orig. switch-to-buffer
	  ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
	  ("C-s-b" . consult-buffer-other-window)
	  ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
	  ;; Custom M-# bindings for fast register access
	  ("M-#" . consult-register-load)
	  ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
	  ("M-`" . consult-register)
	  ;; Other custom bindings
	  ("M-y" . consult-yank-from-kill-ring)                ;; orig. yank-pop
	  ("<help> a" . consult-apropos)            ;; orig. apropos-command
	  ;; M-g bindings (goto-map)
	  ("M-g e" . consult-compile-error)
	  ("M-g g" . consult-goto-line)             ;; orig. goto-line
	  ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
	  ("s-l" . consult-goto-line)           ;; orig. goto-line
	  ("M-g o" . consult-outline)
	  ("M-g m" . consult-mark)
	  ("M-g k" . consult-global-mark)
	  ("C-x C-SPC" . consult-global-mark)
	  ("M-g i" . consult-imenu)
	  ("s-2" . consult-imenu)
	  ("M-g I" . consult-imenu-multi)
	  ;; M-s bindings (search-map)
	  ("M-s f" . consult-find)
	  ("M-s L" . consult-locate)
	  ("M-s g" . consult-grep)
	  ("M-s G" . consult-git-grep)
	  ("M-s r" . consult-ripgrep)
	  ("C-c f" . consult-ripgrep)
	  ("M-s l" . consult-line)
	  ("M-s m" . consult-multi-occur)
	  ("M-s k" . consult-keep-lines)
	  ("M-s u" . consult-focus-lines)
	  ;; Customizations that map to ivy
	  ("s-r" . consult-recent-file) ;; Deprecate
	  ("C-c r" . consult-recent-file)
	  ;; ("C-c o" . consult-file-externally)
	  ("C-y" . yank)
	  ("C-s" . consult-line) ;; I've long favored Swiper mapped to c-s
	  ;; Isearch integration
	  ("M-s e" . consult-isearch)
	  :map isearch-mode-map
	  ("M-e" . consult-isearch)                 ;; orig. isearch-edit-string
	  ("M-s e" . consult-isearch)               ;; orig. isearch-edit-string
	  ("M-s l" . consult-line))                 ;; required by consult-line to detect isearch

   ;; The :init configuration is always executed (Not lazy)
   :init

   ;; Optionally configure the register formatting.  This improves the register
   ;; preview for `consult-register', `consult-register-load',
   ;; `consult-register-store' and the Emacs built-ins.
   (setq register-preview-delay 0.1
	 register-preview-function #'consult-register-format)

   ;; Use Consult to select xref locations with preview
   (setq xref-show-xrefs-function #'consult-xref
	 xref-show-definitions-function #'consult-xref)

   ;; Updating the default to include "--smart-case"
   ;; Leveraging ripgrep-all https://github.com/phiresky/ripgrep-all
   (setq consult-ripgrep-command "rga --null --line-buffered --color=ansi --max-columns=1000 --smart-case --no-heading --line-number . -e ARG OPTS")
   (setq consult-ripgrep-args "rga --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --line-number .")

   ;; Configure other variables and modes in the :config section,
   ;; after lazily loading the package.
   :config

   (autoload 'projectile-project-root "projectile")
   (setq consult-project-root-function #'projectile-project-root))
;; Consult:1 ends here

;; [[file:README.org::*Ordeless][Ordeless:1]]
(use-package orderless
  :straight t
  :config
  (defvar +orderless-dispatch-alist
    '((?% . char-fold-to-regexp)
      (?! . orderless-without-literal)
      (?`. orderless-initialism)
      (?= . orderless-literal)
      (?~ . orderless-flex)))
  (defun +orderless-dispatch (pattern index _total)
    (cond
     ;; Ensure that $ works with Consult commands, which add disambiguation suffixes
     ((string-suffix-p "$" pattern)
      `(orderless-regexp . ,(concat (substring pattern 0 -1) "[\x100000-\x10FFFD]*$")))
     ;; File extensions
     ((and
       ;; Completing filename or eshell
       (or minibuffer-completing-file-name
	   (derived-mode-p 'eshell-mode))
       ;; File extension
       (string-match-p "\\`\\.." pattern))
      `(orderless-regexp . ,(concat "\\." (substring pattern 1) "[\x100000-\x10FFFD]*$")))
     ;; Ignore single !
     ((string= "!" pattern) `(orderless-literal . ""))
     ;; Prefix and suffix
     ((if-let (x (assq (aref pattern 0) +orderless-dispatch-alist))
	  (cons (cdr x) (substring pattern 1))
	(when-let (x (assq (aref pattern (1- (length pattern))) +orderless-dispatch-alist))
	  (cons (cdr x) (substring pattern 0 -1)))))))

  ;; Define orderless style with initialism by default
  (orderless-define-completion-style +orderless-with-initialism
    (orderless-matching-styles '(orderless-initialism orderless-literal orderless-regexp)))

  ;; Certain dynamic completion tables (completion-table-dynamic)
  ;; do not work properly with orderless. One can add basic as a fallback.
  ;; Basic will only be used when orderless fails, which happens only for
  ;; these special tables.
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	  ;;; Enable partial-completion for files.
	  ;;; Either give orderless precedence or partial-completion.
	  ;;; Note that completion-category-overrides is not really an override,
	  ;;; but rather prepended to the default completion-styles.
	;; completion-category-overrides '((file (styles orderless partial-completion))) ;; orderless is tried first
	completion-category-overrides '((file (styles partial-completion)) ;; partial-completion is tried first
					;; enable initialism by default for symbols
					(command (styles +orderless-with-initialism))
					(variable (styles +orderless-with-initialism))
					(symbol (styles +orderless-with-initialism)))
	orderless-component-separator #'orderless-escapable-split-on-space ;; allow escaping space with backslash!
	orderless-style-dispatchers '(+orderless-dispatch)))
;; Ordeless:1 ends here

;; [[file:README.org::*Corfu][Corfu:1]]
(use-package corfu
  :straight t
  :demand t
  ;; Optionally use TAB for cycling, default is `corfu-complete'.
  :bind (:map corfu-map
	      ("<escape>". corfu-quit)
	      ("<return>" . corfu-insert)
	      ("M-d" . corfu-show-documentation)
	      ("M-l" . 'corfu-show-location)
	      ("TAB" . corfu-next)
	      ([tab] . corfu-next)
	      ("S-TAB" . corfu-previous)
	      ([backtab] . corfu-previous))

  :custom
  ;; Works with `indent-for-tab-command'. Make sure tab doesn't indent when you
  ;; want to perform completion
  (tab-always-indent 'complete)
  (completion-cycle-threshold nil)      ; Always show candidates in menu

  (corfu-auto nil)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.25)

  ;; (corfu-min-width 80)
  ;; (corfu-max-width corfu-min-width)     ; Always have the same width
  (corfu-count 14)
  (corfu-scroll-margin 4)
  (corfu-cycle nil)

  ;; (corfu-echo-documentation nil)        ; Already use corfu-doc
  (corfu-separator ?\s)                 ; Necessary for use with orderless
  (corfu-quit-no-match 'separator)

  (corfu-preview-current 'insert)       ; Preview current candidate?
  (corfu-preselect-first t)             ; Preselect first candidate?

  :init
;; Recommended: Enable Corfu globally.
  ;; This is recommended since dabbrev can be used globally (M-/).
  (global-corfu-mode))
;; Corfu:1 ends here

;; [[file:README.org::*Corfu move to minibuffer][Corfu move to minibuffer:1]]
(defun corfu-move-to-minibuffer ()
  "Move \"popup\" completion candidates to minibuffer.

Useful if you want a more robust view into the recommend candidates."
  (interactive)
  (let (completion-cycle-threshold completion-cycling)
    (apply #'consult-completion-in-region completion-in-region--data)))
(define-key corfu-map "\M-m" #'corfu-move-to-minibuffer)
;; Corfu move to minibuffer:1 ends here

;; [[file:README.org::*Kind Icos][Kind Icos:1]]
(use-package kind-icon
  :straight t
  :after corfu
  :custom
  (kind-icon-use-icons t)
  (kind-icon-default-face 'corfu-default) ; Have background color be the same as `corfu' face background
  (kind-icon-blend-background nil)  ; Use midpoint color between foreground and background colors ("blended")?
  (kind-icon-blend-frac 0.08)

  ;; NOTE 2022-02-05: `kind-icon' depends `svg-lib' which creates a cache
  ;; directory that defaults to the `user-emacs-directory'. Here, I change that
  ;; directory to a location appropriate to `no-littering' conventions, a
  ;; package which moves directories of other packages to sane locations.
  ;; (svg-lib-icons-dir (no-littering-expand-var-file-name "svg-lib/cache/")) ; Change cache dir
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter) ; Enable `kind-icon'

  ;; Add hook to reset cache so the icon colors match my theme
  ;; NOTE 2022-02-05: This is a hook which resets the cache whenever I switch
  ;; the theme using my custom defined command for switching themes. If I don't
  ;; do this, then the backgound color will remain the same, meaning it will not
  ;; match the background color corresponding to the current theme. Important
  ;; since I have a light theme and dark theme I switch between. This has no
  ;; function unless you use something similar
  (add-hook 'kb/themes-hooks #'(lambda () (interactive) (kind-icon-reset-cache))))
;; Kind Icos:1 ends here

;; [[file:README.org::*Corfu Doc][Corfu Doc:1]]
(use-package corfu-doc
  ;; NOTE 2022-02-05: At the time of writing, `corfu-doc' is not yet on melpa
  :straight (corfu-doc :type git :host github :repo "galeo/corfu-doc")
  :bind (:map corfu-map
	      ;; This is a manual toggle for the documentation window.
	      ([remap corfu-show-documentation] . corfu-doc-toggle) ; Remap the default doc command
	      ;; Scroll in the documentation window
	      ("M-n" . corfu-doc-scroll-up)
	      ("M-p" . corfu-doc-scroll-down))
  :hook (corfu-mode . corfu-doc-mode)
  :custom
  (corfu-doc-delay 0.1)
  (corfu-doc-hide-threshold 10)
  (corfu-doc-max-width 60)
  (corfu-doc-max-height 10)

  ;; NOTE 2022-02-05: I've also set this in the `corfu' use-package to be
  ;; extra-safe that this is set when corfu-doc is loaded. I do not want
  ;; documentation shown in both the echo area and in the `corfu-doc' popup.
  ;; (corfu-echo-documentation nil)
  :config
  ;; NOTE 2022-02-05: This is optional. Enabling the mode means that every corfu
  ;; popup will have corfu-doc already enabled. This isn't desirable for me
  ;; since (i) most of the time I do not need to see the documentation and (ii)
  ;; when scrolling through many candidates, corfu-doc makes the corfu popup
  ;; considerably laggy when there are many candidates. Instead, I rely on
  ;; manual toggling via `corfu-doc-toggle'.
  (corfu-doc-mode))
;; Corfu Doc:1 ends here

;; [[file:README.org::*Org Include Auto][Org Include Auto:1]]
;; OrgIncludeAuto
(defun save-and-update-includes ()
  "Update the line numbers of #+INCLUDE:s in current buffer.
Only looks at INCLUDEs that have either :range-begin or :range-end.
This function does nothing if not in `org-mode', so you can safely
add it to `before-save-hook'."
  (interactive)
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (while (search-forward-regexp
	      "^\\s-*#\\+INCLUDE: *\"\\([^\"]+\\)\".*:range-\\(begin\\|end\\)"
	      nil 'noerror)
	(let* ((file (expand-file-name (match-string-no-properties 1)))
	       lines begin end)
	  (forward-line 0)
	  (when (looking-at "^.*:range-begin *\"\\([^\"]+\\)\"")
	    (setq begin (match-string-no-properties 1)))
	  (when (looking-at "^.*:range-end *\"\\([^\"]+\\)\"")
	    (setq end (match-string-no-properties 1)))
	  (setq lines (decide-line-range file begin end))
	  (when lines
	    (if (looking-at ".*:lines *\"\\([-0-9]+\\)\"")
		(replace-match lines :fixedcase :literal nil 1)
	      (goto-char (line-end-position))
	      (insert " :lines \"" lines "\""))))))))

(add-hook 'before-save-hook #'save-and-update-includes)

(defun decide-line-range (file begin end)
  "Visit FILE and decide which lines to include.
BEGIN and END are regexps which define the line range to use."
  (let (l r)
    (save-match-data
      (with-temp-buffer
	(insert-file-contents file)
	(goto-char (point-min))
	(if (null begin)
	    (setq l "")
	  (search-forward-regexp begin)
	  (setq l (line-number-at-pos (match-beginning 0))))
	(if (null end)
	    (setq r "")
	  (search-forward-regexp end)
	  (setq r (1+ (line-number-at-pos (match-end 0)))))
	(format "%s-%s" (+ l 1) (- r 1)))))) ;; Exclude wrapper
;; -OrgIncludeAuto
;; Org Include Auto:1 ends here

;; [[file:README.org::*Editing Config][Editing Config:1]]
;; EditConfig
(defun edit-configs ()
  "Opens the README.org file."
  (interactive)
  (find-file "~/.emacs.d/README.org"))

(global-set-key (kbd "C-z e") #'edit-configs)
;; -EditConfig
;; Editing Config:1 ends here
