

# Osmacs


# Table of Contens


# Sobre este repositorio

Emacs es mi editor de texto preferido y este repositorio esta toda su configuracion. Cabe resaltar que este repositorio coge muchas lineas de codigo de muchas configuraciones externas que acomode a mi manejo lo cual agradezco a todas esas personas que hacen esto posible a los Hacker de emacs.


# StartUp


## Lexical Binding

Uso lexical-binding. [Why?](https://nullprogram.com/blog/2016/12/22/)

> Until Emacs 24.1 (June 2012), Elisp only had dynamically scoped variables, a feature, mostly by accident, common to old lisp dialects. While dynamic scope has some selective uses, it’s widely regarded as a mistake for local variables, and virtually no other languages have adopted it.

    ;;; init.el --- -*- lexical-binding: t -*-


# Package Manager

Cuando comence a usar emacs quise extender las funcionalidades para ello utilice los repositorios de [MELPA](https://melpa.org/) con ayuda del paquete [use-package](https://github.com/jwiegley/use-package) pero luego descubri [straight.el](https://github.com/radian-software/straight.el), un gestor de paquetes puramente funcional para la nueva generacion de hackers de emacs, me gusto mas porque no descargaba el paquete en si sino clonaba el repositorio y me permitia hacer modificaciones directas al repositorio descargado.

Para añadirlo Straight.el

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


## Use-package

Instalar y configurar use-package

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


### Blackout

[Blackout](https://github.com/radian-software/blackout), una característica que elimina ciertos modos menores de la línea de modo.

    (use-package blackout
      :demand t)


### el-patch

El paquete 'el-patch' proporciona una forma de anular la definición de an función interna de otro paquete al proporcionar una expresión s diferencial basado que luego puede validarse para garantizar que el flujo ascendente La definición no ha cambiado.

    (use-package el-patch)

    ;; Only needed at compile time, thanks to Jon
    ;; <https://github.com/radian-software/el-patch/pull/11>.
    (eval-when-compile
      (require 'el-patch))


# Global Functionalities


## USer Information

**Prerequisite**:Informacion basica del usuario

    (setq
     user-full-name "Oscar (Osvarcha) Vargas"
     user-mail-address "osvarcha@hotmail.com")


## UTF8 for windows

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


## Bindings

    (global-set-key (kbd "C-z") nil) ; Suspend-frame


## Selectrum

Selectrum is good

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


# Package Basics


## Search


### Avy

[Avy](https://github.com/abo-abo/avy), una de las mejores herramientas para moverte en el texto.

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


### CtrlF

El paquete ****[ctrlf](https://github.com/radian-software/ctrlf)****  proporciona un reemplazo para 'buscar' que es más similar a las interfaces de búsqueda de texto probadas y verdaderas en la web navegadores y otros programas (piense en lo que sucede cuando escribe ctrl + F).

    (use-package avy
      :blackout t
      :bind


### ColorRG

[Color rg](https://github.com/manateelazycat/color-rg), una herramienta de búsqueda y refactorización basada en ripgrep que se utiliza para buscar texto.

**Prerequisite**: [ripgrep](https://github.com/BurntSushi/ripgrep#installation)

    (use-package color-rg
      :blackout t
      :straight (color-rg :type git
    		      :host github
    		      :repo "manateelazycat/color-rg")
      :if (executable-find "rg")


## Dired

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


# General Programming


## Editing


### Iedit

[Iedit](https://github.com/victorhge/iedit),un modo menor que permite editar múltiples regiones simultáneamente en un búfer o una región.

    (use-package iedit
      :bind ("C-z ," . iedit-mode)
      :blackout t)

