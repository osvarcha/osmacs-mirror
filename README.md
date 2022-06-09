- [Osmacs](#org99c75a1)
- [Sobre este repositorio](#org3a9d42d)
- [StartUp](#orgabda902)
  - [Lexical Binding](#org7132da6)
- [Package Manager](#org47b717a)
  - [Use-package](#orgf78a6d4)
    - [Diminish](#orgb655d0b)
- [Global Functionalities](#orgf2f5c12)
  - [USer Information](#org1002eab)
  - [UTF8 for windows](#org4b1544d)
  - [Bindings](#org8bf8e91)
- [Package Basics](#orgd92aabf)
  - [Search](#org567c5e6)
    - [Avy](#org61394d4)
    - [CtrlF](#org4252a16)
    - [ColorRG](#orgb5a3a6a)



<a id="org99c75a1"></a>

# Osmacs


<a id="org3a9d42d"></a>

# Sobre este repositorio

Emacs es mi editor de texto preferido y este repositorio esta toda su configuracion. Cabe resaltar que este repositorio coge muchas lineas de codigo de muchas configuraciones externas que acomode a mi manejo lo cual agradezco a todas esas personas que hacen esto posible a los Hacker de emacs.


<a id="orgabda902"></a>

# StartUp


<a id="org7132da6"></a>

## Lexical Binding

Uso lexical-binding. [Why?](https://nullprogram.com/blog/2016/12/22/)

> Until Emacs 24.1 (June 2012), Elisp only had dynamically scoped variables, a feature, mostly by accident, common to old lisp dialects. While dynamic scope has some selective uses, it’s widely regarded as a mistake for local variables, and virtually no other languages have adopted it.

```emacs-lisp
;;; init.el --- -*- lexical-binding: t -*-
```


<a id="org47b717a"></a>

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


<a id="orgf78a6d4"></a>

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


<a id="orgb655d0b"></a>

### Diminish

[Diminish](https://github.com/emacsmirror/diminish), una característica que elimina ciertos modos menores de la línea de modo.

```emacs-lisp
(use-package diminish)
```


<a id="orgf2f5c12"></a>

# Global Functionalities


<a id="org1002eab"></a>

## USer Information

**Prerequisite**:Informacion basica del usuario

```emacs-lisp
(setq
 user-full-name "Oscar (Osvarcha) Vargas"
 user-mail-address "osvarcha@hotmail.com")
```


<a id="org4b1544d"></a>

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


<a id="org8bf8e91"></a>

## Bindings

```emacs-lisp
(global-set-key (kbd "C-z") nil) ; Suspend-frame
```


<a id="orgd92aabf"></a>

# Package Basics


<a id="org567c5e6"></a>

## Search


<a id="org61394d4"></a>

### Avy

[Avy](https://github.com/abo-abo/avy), una de las mejores herramientas para moverte en el texto.

```emacs-lisp
(use-package avy
  :defer t
  :bind
  (("C-z C-c" . avy-goto-char-timer)
   ("C-z C-l" . avy-goto-line))
  :custom
  (avy-timeout-seconds 0.3)
  (avy-style 'pre)
  :custom-face
  (avy-lead-face ((t (:background "#51afef" :foreground "#870000" :weight bold)))));
```


<a id="org4252a16"></a>

### CtrlF

El paquete ****[ctrlf](https://github.com/radian-software/ctrlf)**** proporciona un reemplazo para 'buscar' que es más similar a las interfaces de búsqueda de texto probadas y verdaderas en la web navegadores y otros programas (piense en lo que sucede cuando escribe ctrl + F).

```emacs-lisp
(use-package avy
  :defer t
  :bind
```


<a id="orgb5a3a6a"></a>

### ColorRG

[Color rg](https://github.com/manateelazycat/color-rg), una herramienta de búsqueda y refactorización basada en ripgrep que se utiliza para buscar texto.

**Prerequisite**: [ripgrep](https://github.com/BurntSushi/ripgrep#installation)

```emacs-lisp
(use-package color-rg
  :straight (color-rg :type git
		      :host github
		      :repo "manateelazycat/color-rg")
  :if (executable-find "rg")
  :bind ("C-z C-s" . color-rg-search-input))
```
