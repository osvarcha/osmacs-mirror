- [Osmacs](#org1a8e6e8)
- [Sobre este repositorio](#org92a67e2)
- [StartUp](#org5d9b73c)
  - [Lexical Binding](#orga7e2fa6)
- [Package Manager](#orgbcb87dc)
  - [Use-package](#orgc5b86a5)
    - [Diminish](#orgbf7a130)
- [Global Functionalities](#org666ce23)
  - [USer Information](#orgc434bd5)
  - [UTF8 for windows](#org9f18735)
  - [Bindings](#org4e1c1f4)
- [Package Basics](#org1daabbd)
  - [Search](#org7d4c171)
    - [Avy](#org3a50bba)
    - [CtrlF](#org7d003b8)



<a id="org1a8e6e8"></a>

# Osmacs


<a id="org92a67e2"></a>

# Sobre este repositorio

Emacs es mi editor de texto preferido y este repositorio esta toda su configuracion. Cabe resaltar que este repositorio coge muchas lineas de codigo de muchas configuraciones externas que acomode a mi manejo lo cual agradezco a todas esas personas que hacen esto posible a los Hacker de emacs.


<a id="org5d9b73c"></a>

# StartUp


<a id="orga7e2fa6"></a>

## Lexical Binding

Uso lexical-binding. [Why?](https://nullprogram.com/blog/2016/12/22/)

> Until Emacs 24.1 (June 2012), Elisp only had dynamically scoped variables, a feature, mostly by accident, common to old lisp dialects. While dynamic scope has some selective uses, it’s widely regarded as a mistake for local variables, and virtually no other languages have adopted it.

```emacs-lisp
;;; init.el --- -*- lexical-binding: t -*-
```


<a id="orgbcb87dc"></a>

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


<a id="orgc5b86a5"></a>

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


<a id="orgbf7a130"></a>

### Diminish

[Diminish](https://github.com/emacsmirror/diminish), una característica que elimina ciertos modos menores de la línea de modo.

```emacs-lisp
(use-package diminish)
```


<a id="org666ce23"></a>

# Global Functionalities


<a id="orgc434bd5"></a>

## USer Information

**Prerequisite**:Informacion basica del usuario

```emacs-lisp
(setq
 user-full-name "Oscar (Osvarcha) Vargas"
 user-mail-address "osvarcha@hotmail.com")
```


<a id="org9f18735"></a>

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


<a id="org4e1c1f4"></a>

## Bindings

```emacs-lisp
(global-set-key (kbd "C-z") nil) ; Suspend-frame
```


<a id="org1daabbd"></a>

# Package Basics


<a id="org7d4c171"></a>

## Search


<a id="org3a50bba"></a>

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


<a id="org7d003b8"></a>

### CtrlF

El paquete ****[ctrlf](https://github.com/radian-software/ctrlf)**** proporciona un reemplazo para 'buscar' que es más similar a las interfaces de búsqueda de texto probadas y verdaderas en la web navegadores y otros programas (piense en lo que sucede cuando escribe ctrl + F).

```emacs-lisp
(use-package avy
  :defer t
  :bind
```
