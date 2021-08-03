# dbt-mode

An Emacs major mode for editing [DBT](https://www.getdbt.com/) files.

![screenshot](https://user-images.githubusercontent.com/160894/128073665-24f98854-04a8-49ef-91d5-8517d8eddf52.png)

## Installation

```emacs-lisp
(use-package dbt-mode
  :straight (:type git :host github :repo "CyberShadow/dbt-mode")
  ;; Customize `sql-product' to set the flavor of the SQL syntax.
  :custom (sql-product 'mariadb))
```
