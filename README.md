# Osmacs


# Table of Contens


# Sobre este repositorio

Emacs es mi editor de texto preferido y este repositorio esta toda su configuracion. Cabe resaltar que este repositorio coge muchas lineas de codigo de muchas configuraciones externas que acomode a mi manejo lo cual agradezco a todas esas personas que hacen esto posible a los Hacker de emacs.


# StartUp


## Lexical Binding

Uso lexical-binding. [Why?](https://nullprogram.com/blog/2016/12/22/)

> Until Emacs 24.1 (June 2012), Elisp only had dynamically scoped variables, a feature, mostly by accident, common to old lisp dialects. While dynamic scope has some selective uses, it’s widely regarded as a mistake for local variables, and virtually no other languages have adopted it.

```emacs-lisp
;;; init.el --- -*- lexical-binding: t -*-
```


# Package Manager

Cuando comence a usar emacs quise extender las funcionalidades para ello utilice los repositorios de [MELPA](https://melpa.org/) con ayuda del paquete [use-package](https://github.com/jwiegley/use-package) pero luego descubri [straight.el](https://github.com/radian-software/straight.el), un gestor de paquetes puramente funcional para la nueva generacion de hackers de emacs, me gusto mas porque no descargaba el paquete en si sino clonaba el repositorio y me permitia hacer modificaciones directas al repositorio descargado.

Para añadirlo Straight.el

```emacs-lisp
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
```


## Use-package

Instalar y configurar use-package

```emacs-lisp
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
```


### Blackout

[Blackout](https://github.com/radian-software/blackout), una característica que elimina ciertos modos menores de la línea de modo.

```emacs-lisp
(use-package blackout
  :demand t)
```


### el-patch

El paquete 'el-patch' proporciona una forma de anular la definición de an función interna de otro paquete al proporcionar una expresión s diferencial basado que luego puede validarse para garantizar que el flujo ascendente La definición no ha cambiado.

```emacs-lisp
(use-package el-patch)

;; Only needed at compile time, thanks to Jon
;; <https://github.com/radian-software/el-patch/pull/11>.
(eval-when-compile
  (require 'el-patch))
```


# Global Functionalities


## USer Information

**Prerequisite**:Informacion basica del usuario

```emacs-lisp
(setq
 user-full-name "Oscar (Osvarcha) Vargas"
 user-mail-address "osvarcha@hotmail.com")
```


## UTF8 for windows

```emacs-lisp
(unless *sys/win32*
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8))
;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))
```


## Bindings

```emacs-lisp
(global-set-key (kbd "C-z") nil) ; Suspend-frame
```


## Functions


### EditConfig

\##+INCLUDE: "elisp/init-func.el" src emacs-lisp :range-begin "EditConfig" :range-end "-Editconfig" :lines "55-61"


### Org include automatic

```emacs-lisp
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
```


## Vundo

```emacs-lisp
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
```


## Selectrumx

Selectrum is good, pero lo omiti por el momento

```emacs-lisp
;; Package `selectrum' is an incremental completion and narrowing
;; framework. Like Ivy and Helm, which it improves on, Selectrum
;; provides a user interface for choosing from a list of options by
;; typing a query to narrow the list, and then selecting one of the
;; remaining candidates. This offers a significant improvement over
;; the default Emacs interface for candidate selection.
(use-package selectrum
  :straight (:host github :repo "raxod502/selectrum")
  :defer t
  :init
  ;; This doesn't actually load Selectrum.
  (selectrum-mode +1)
  :bind (("C-M-r" . selectrum-repeat)
	 :map selectrum-minibuffer-map
	 ("C-r" . selectrum-select-from-history)
	 ("C-j" . selectrum-next-candidate)
	 ("C-k" . selectrum-previous-candidate)
	 :map minibuffer-local-map
	 ("M-h" . backward-kill-word))
  :custom
  (selectrum-fix-minibuffer-height t)
  (selectrum-num-candidates-displayed 7)
  (selectrum-refine-candidates-function #'orderless-filter)
  (selectrum-highlight-candidates-function #'orderless-highlight-matches)
  :custom-face
  (selectrum-current-candidate ((t (:background "#3a3f5a")))))

;; Package `prescient' is a library for intelligent sorting and
;; filtering in various contexts.
(use-package prescient
  :config
  ;; Remember usage statistics across Emacs sessions.
  (prescient-persist-mode +1)
  ;; The default settings seem a little forgetful to me. Let's try
  ;; this out.
  (setq prescient-history-length 1000))

;; Package `selectrum-prescient' provides intelligent sorting and
;; filtering for candidates in Selectrum menus.
(use-package selectrum-prescient
  :demand t
  :after selectrum
  :config

  (selectrum-prescient-mode +1))
```


## Icomplete

Fido me gusta mas y mantengo lo minimalista

```emacs-lisp
(fido-vertical-mode t)
```


## Marginalia

```emacs-lisp
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
```


# Package Basics


## Search


### Avy

[Avy](https://github.com/abo-abo/avy), una de las mejores herramientas para moverte en el texto.

```emacs-lisp
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
```


### CtrlF

El paquete ****[ctrlf](https://github.com/radian-software/ctrlf)**** proporciona un reemplazo para 'buscar' que es más similar a las interfaces de búsqueda de texto probadas y verdaderas en la web navegadores y otros programas (piense en lo que sucede cuando escribe ctrl + F).

```emacs-lisp
(use-package avy
  :blackout t
  :bind
```


### ColorRG

[Color rg](https://github.com/manateelazycat/color-rg), una herramienta de búsqueda y refactorización basada en ripgrep que se utiliza para buscar texto.

**Prerequisite**: [ripgrep](https://github.com/BurntSushi/ripgrep#installation)

```emacs-lisp
(use-package color-rg
  :blackout t
  :straight (color-rg :type git
		      :host github
		      :repo "manateelazycat/color-rg")
  :if (executable-find "rg")
```


## Dired

```emacs-lisp
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
```


## Snippest

```emacs-lisp
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
```


## Theme


### Doom theme

```emacs-lisp
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
```


### Doom Modeline

```emacs-lisp
;; ;; -DoomThemes

;; DoomModeline
(use-package doom-modeline
  :no-require t
  :demand t
  :functions (true-color-p)
  :custom
  ;; Don't compact font caches during GC. Windows Laggy Issue
  (inhibit-compacting-font-caches t)
```


# UX


## Theme


### DoomTheme


### DoomModeline


# General Programming


## Parenthesis


### Smartparens

```emacs-lisp
(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :blackout smartparens-mode
  :bind
  (:map smartparens-mode-map
	("C-M-f" . sp-forward-sexp)
	("C-M-b" . sp-backward-sexp)
	("C-M-a" . sp-backward-down-sexp)
	("C-M-e" . sp-up-sexp)
	("C-M-w" . sp-copy-sexp)
	("C-M-k" . sp-change-enclosing)
	("M-k" . sp-kill-sexp)
	("C-M-<backspace>" . sp-splice-sexp-killing-backward)
	("C-S-<backspace>" . sp-splice-sexp-killing-around)
	("C-]" . sp-select-next-thing-exchange))
  :custom
  (sp-escape-quotes-after-insert nil)
  :config
  ;; Stop pairing single quotes in elisp
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
```


### Math Parenthesis

```emacs-lisp
;; Show matching parenthesis
(show-paren-mode 1)
;; we will call `blink-matching-open` ourselves...
(remove-hook 'post-self-insert-hook
	     #'blink-paren-post-self-insert-function)

;; this still needs to be set for `blink-matching-open` to work
(setq blink-matching-paren 'show)
(let ((ov nil)) ; keep track of the overlay
  (advice-add
   #'show-paren-function
   :after
    (defun show-paren--off-screen+ (&rest _args)
      "Display matching line for off-screen paren."
      (when (overlayp ov)
	(delete-overlay ov))
      ;; check if it's appropriate to show match info,
      ;; see `blink-paren-post-self-insert-function'
      (when (and (overlay-buffer show-paren--overlay)
		 (not (or cursor-in-echo-area
			  executing-kbd-macro
			  noninteractive
			  (minibufferp)
			  this-command))
		 (and (not (bobp))
		      (memq (char-syntax (char-before)) '(?\) ?\$)))
		 (= 1 (logand 1 (- (point)
				   (save-excursion
				     (forward-char -1)
				     (skip-syntax-backward "/\\")
				     (point))))))
	;; rebind `minibuffer-message' called by
	;; `blink-matching-open' to handle the overlay display
	(cl-letf (((symbol-function #'minibuffer-message)
		   (lambda (msg &rest args)
		     (let ((msg (apply #'format-message msg args)))
		       (setq ov (display-line-overlay+
				 (window-start) msg))))))
	  (blink-matching-open))))))
```


## Editing


### Iedit

[Iedit](https://github.com/victorhge/iedit),un modo menor que permite editar múltiples regiones simultáneamente en un búfer o una región.

```emacs-lisp
(use-package iedit
  :bind ("C-z ," . iedit-mode)
  :blackout t)
```
