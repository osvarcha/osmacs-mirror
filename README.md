- [Osmacs](#orgfcd78d2)
- [Sobre este repositorio](#org5bed147)
- [StartUp](#org204770d)
  - [Lexical Binding](#org13f4c64)
- [Package Manager](#orgd9b053c)
  - [Use-package](#orgb9a59c4)
    - [Diminish](#org09daa93)
- [Global Functionalities](#org3866bfa)
  - [USer Information](#org825ad8c)
  - [UTF8 for windows](#org21aeb98)
  - [Bindings](#orgabc5b47)
- [Package Basics](#orga2b7814)



<a id="orgfcd78d2"></a>

# Osmacs


<a id="org5bed147"></a>

# Sobre este repositorio

Emacs es mi editor de texto preferido y este repositorio esta toda su configuracion. Cabe resaltar que este repositorio coge muchas lineas de codigo de muchas configuraciones externas que acomode a mi manejo lo cual agradezco a todas esas personas que hacen esto posible a los Hacker de emacs.


<a id="org204770d"></a>

# StartUp


<a id="org13f4c64"></a>

## Lexical Binding

Uso lexical-binding. [Why?](https://nullprogram.com/blog/2016/12/22/)

> Until Emacs 24.1 (June 2012), Elisp only had dynamically scoped variables, a feature, mostly by accident, common to old lisp dialects. While dynamic scope has some selective uses, it’s widely regarded as a mistake for local variables, and virtually no other languages have adopted it.

```emacs-lisp
;;; init.el --- -*- lexical-binding: t -*-
```


<a id="orgd9b053c"></a>

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


<a id="orgb9a59c4"></a>

## Use-package

Instalar y configurar use-package

```emacs-lisp
;; Use straight.el for use-package expressions
(straight-use-package 'use-package)
;; Install use-package if not installed

;; Configure use-package to use straight.el by default
;; (use-package straight
;;              :custom (straight-use-package-by-default t))

;; (eval-and-compile
;;   (setq use-package-always-ensure t)
;;   (setq use-package-expand-minimally t)
;;   (setq use-package-compute-statistics t)
;;   (setq use-package-enable-imenu-support t))

;; (eval-when-compile
;;   (require 'use-package)
;;   (require 'bind-key))
(setq straight-use-package-by-default t)
(setq use-package-always-defer t)
```


<a id="org09daa93"></a>

### Diminish

[Diminish](https://github.com/emacsmirror/diminish), una característica que elimina ciertos modos menores de la línea de modo.

```emacs-lisp
(use-package diminish)
```


<a id="org3866bfa"></a>

# Global Functionalities


<a id="org825ad8c"></a>

## USer Information

**Prerequisite**:Informacion basica del usuario

```emacs-lisp
(setq
 user-full-name "Oscar (Osvarcha) Vargas"
 user-mail-address "osvarcha@hotmail.com")
```


<a id="org21aeb98"></a>

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


<a id="orgabc5b47"></a>

## Bindings

```emacs-lisp
(global-set-key (kbd "C-z") nil)
```


<a id="orga2b7814"></a>

# Package Basics
