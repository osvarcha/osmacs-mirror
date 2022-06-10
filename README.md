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


# General Programming


## Editing


### Iedit

[Iedit](https://github.com/victorhge/iedit),un modo menor que permite editar múltiples regiones simultáneamente en un búfer o una región.

```emacs-lisp
(use-package iedit
  :bind ("C-z ," . iedit-mode)
  :blackout t)
```
