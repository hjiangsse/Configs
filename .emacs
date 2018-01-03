(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

(package-initialize)
(setq package-enable-at-startup nil)

(ac-config-default)

;;set tab-width begin
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-tabs-mode nil)

(setq tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
;;set tab-width end

;;Set my lisp system and, optionlly, some contribs
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contrib '(slime-fancy))
