;;;-----------------------Do Some Config For Packages Begin--------------------------
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'setup-general)
(if (version< emacs-version "24.4")
    (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags))
;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

;;config for slime
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contrib '(slime-fancy))

;;add mu4e to load path
;;(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")

;;settings for gnu global
(setq load-path (cons "/usr/share/emacs/site-lisp/global" load-path))
(autoload 'gtags-mode "gtags" "" t)
(setq c-mode-hook '(lambda ()
                     (gtags-mode 1)))
(setq gtags-mode-hook
      '(lambda ()
         (setq gtags-path-style 'absolute)))

;;config speed bar
(setq speedbar-show-unknown-files t)

;;set default ansi-term binary file
(setq explicit-shell-file-name "d:\\cmder\\vendor\\git-for-windows\\bin\\bash.exe")

;;Do not make backup files
(setq make-backup-files nil)
(put 'downcase-region 'disabled nil)
;;;-----------------------Do Some Config For Packages END--------------------------


;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes (quote (light-blue)))
 '(package-selected-packages
   (quote
    (sr-speedbar magit expand-region evil neotree auto-complete-c-headers auto-complete yasnippet-snippets ggtags zygospore helm-gtags helm yasnippet ws-butler volatile-highlights use-package undo-tree iedit dtrt-indent counsel-projectile company clean-aindent-mode anzu))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;config for ggtags
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))
(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

;;config for helm, to use helm-gtags
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t)

(require 'helm-gtags)
;;enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwin)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;;auto complete setting
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;yasnippet setting
(require 'yasnippet)
(yas-global-mode 1)

;;c/c++ head files auto-complete
(defun my:ac-c-header-init()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-source 'ac-source-c-headers))

(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;;disable emacs toolbar, menubar, scrollbar
(tool-bar-mode -1)

;;set auto-complete-mode one
(auto-complete-mode 1)

;;insert shell header
(defun shell-header ()
  "Insert header in shell script file."
  (interactive)
  (insert "#!/bin/bash"))

;;;------------------------Add Header BEGIN--------------------------------------
(defun add-header ()
  "Adder a hear by the buffer-name-extension."
  (interactive)
  (let ((ext (file-name-extension buffer-file-name)))
    (cond ((equal ext "c")
           (add-c-header))
          ((equal ext "java")
           (add-java-head))
          ((equal ext "pl")
           (add-perl-head))
          ((equal ext "py")
           (add-python3-head))
          ((equal ext "el")
           (message "Add emacs lisp file Header"))
          (t (message "Unknown file extension")))))

(defun add-c-header ()
  "add header in a c file."
  (goto-char (point-min))
  (insert-file-contents "~/.emacs.d/templates/c_file_head.txt"))

(defun add-java-head ()
  "add header in a java file."
  (goto-char (point-min))
  (insert-file-contents "~/.emacs.d/templates/java_file_head.txt"))

(defun add-perl-head ()
  "add header in a perl file."
  (goto-char (point-min))
  (insert-file-contents "~/.emacs.d/templates/perl_file_head.txt"))

(defun add-python3-head ()
  "add header in a python3 file."
  (goto-char (point-min))
  (insert-file-contents "~/.emacs.d/templates/python_file_head.txt"))

(defun wrap-markup-region (start end)
  "Insert a markup <b></b> around a region"
  (interactive "r")
  (save-excursion
    (goto-char end) (insert "</b>")
    (goto-char start) (insert "<b>")))

(defun comment-c-region (start end)
  "Comment a c region using /* */"
  (interactive "r")
  (goto-char end)
  (next-line)
  (insert "*/")
  (goto-char start)
  (previous-line)
  (insert "/*"))
;;;------------------------Add Header END--------------------------------------



;;------------------------Rename file and buffer Begin---------------------
;;Rename file and buffer
(defun rename-file-and-buffer (new-name)
  "Rename both current buffer and file it's visting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((bufname (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" bufname)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(global-set-key (kbd "M-s r") 'rename-file-and-buffer)
;;------------------------Rename file and buffer End---------------------


;;;------------------Remap Some Command Begin-------------------
;;Remap set-mark-command, set to M-s s
(global-set-key (kbd "M-s s") 'set-mark-command)
(global-set-key (kbd "M-s n") 'neotree-toggle)

;;remap some key stroke for source code navigate
(global-set-key (kbd "M-s f") 'forward-sexp)
(global-set-key (kbd "M-s b") 'backward-sexp)
(global-set-key (kbd "M-s k") 'kill-sexp)
(global-set-key (kbd "M-s m") 'mark-sexp)
(global-set-key (kbd "M-s a") 'beginning-of-defun)
(global-set-key (kbd "M-s e") 'end-of-defun)

;;setting emacs-evil mode
(add-to-list 'load-path "~/.emacs.d/elpa/evil")
(require 'evil)
(global-set-key (kbd "C-x t") 'turn-on-evil-mode)
(global-set-key (kbd "C-x y") 'turn-off-evil-mode)

;;set emacs expand-region
(require 'expand-region)
(global-set-key (kbd "C-x =") 'er/expand-region)

;;set magit
(global-set-key (kbd "C-x g") 'magit-status)
;;;------------------Remap Some Command End-------------------

;;;----------Writing Emacs Extensions Begin ------------------
;;(defun other-window-backward (n)
;;  "Select nth previous window."
;;  (interactive "p")
;;  (other-window (- n)))

;;make argument optional
(defun other-window-backward (&optional n)
  "Select Nth previous window."
  (interactive "p")
  (other-window (if n (- n) -1)))

;;scroll text up and down one line at a time
(defalias 'scroll-ahead 'scroll-up)
(defalias 'scroll-behind 'scroll-down)

(defun scroll-one-line-ahead ()
  "Scroll ahead one line."
  (interactive)
  (scroll-ahead 1))

(defun scroll-one-line-behind ()
  "Scroll behind one line."
  (interactive)
  (scroll-behind 1))

(defun scroll-n-lines-ahead (&optional n)
  "Scroll ahead N lines (1 by default)"
  (interactive "P")
  (scroll-ahead (prefix-numeric-value n)))

(defun scroll-n-lines-behind (&optional n)
  "Scroll behind N lines (1 by default)"
  (interactive "P")
  (scroll-behind (prefix-numeric-value n)))

(defun line-to-top ()
  "Move current line to top of window."
  (interactive)
  (recenter 0))

(global-set-key (kbd "C-x C-n") 'other-window)
(global-set-key (kbd "C-x C-p") 'other-window-backward)
(global-set-key (kbd "C-x C-q") 'quoted-insert)
(global-set-key (kbd "C-q") 'scroll-n-lines-behind)
(global-set-key (kbd "C-z") 'scroll-n-lines-ahead)
(global-set-key (kbd "M-s c") 'line-to-top)

;;------------Hook Begin--------------------------------------
(defun read-only-if-symlink ()
  (if (file-symlink-p buffer-file-name)
      (progn
        (setq buffer-read-only t)
        (message "File is a symlink"))))

(add-hook 'find-file-hooks 'read-only-if-symlink)
;;------------Hook End----------------------------------------
;;;----------Writing Emacs Extensions End --------------------
