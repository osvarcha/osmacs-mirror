
# Table of Contents

1.  [Osmacs](#orgf322873)
2.  [Sobre este repositorio](#org350feee)
3.  [StartUp](#org2d60e90)
    1.  [Lexical Binding](#org991b7c7)



<a id="orgf322873"></a>

# Osmacs


<a id="org350feee"></a>

# Sobre este repositorio

Emacs es mi editor de texto preferido y este repositorio esta toda su configuracion. Cabe resaltar que este repositorio coge muchas lineas de codigo de muchas configuraciones externas que acomode a mi manejo lo cual agradezco a todas esas personas que hacen esto posible a los Hacker de emacs.


<a id="org2d60e90"></a>

# StartUp


<a id="org991b7c7"></a>

## Lexical Binding

Uso lexical-binding. [Why?](https://nullprogram.com/blog/2016/12/22/)

> Until Emacs 24.1 (June 2012), Elisp only had dynamically scoped variables, a feature, mostly by accident, common to old lisp dialects. While dynamic scope has some selective uses, it’s widely regarded as a mistake for local variables, and virtually no other languages have adopted it.

    ;;; init.el --- -*- lexical-binding: t -*-

