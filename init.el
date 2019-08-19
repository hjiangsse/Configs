;;;start
;; emacs start
(package-initialize)
(setq use-package-always-ensure t)
(setq custom-file "~/.emacs.d/custom-settings.el")
(load custom-file t)

;; set system information
(defun my/laptop-p ()
  (equal (system-name) "hjiang-windows"))
(global-auto-revert-mode)

;; set personal information
(setq user-full-name "hjiang"
      user-mail-address "hjiang@sse.com.cn")

;;; Emacs initialization
;; add package sources
(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))
(unless (assoc-default "org" package-archives)
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t))

;; add my own elisp directory and other files
(add-to-list 'load-path "~/elisp")
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)
(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

;;;General configuration
;;reload
(defun my/reload-emacs-configuration ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))

;;librarias
(use-package dash :ensure t)
(use-package diminish :ensure t)

;;handle emacs backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control -1)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;;handle emacs history
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
	search-ring
	regexp-search-ring))

;;;Windows configuration
(tool-bar-mode -1)
(display-time-mode 1)
;;winner mode
(use-package winner
  :defer t)
(setq sentence-end-double-space nil)

;;;Helm -interactive completion
(use-package helm
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100)
    ;; From https://gist.github.com/antifuchs/9238468
    (setq helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
	  helm-input-idle-delay 0.01  ; this actually updates things
					; reeeelatively quickly.
	  helm-yas-display-key-on-candidate t
	  helm-quick-update t
	  helm-M-x-requires-pattern nil
	  helm-ff-skip-boring-files t)
    (helm-mode))
  :bind (("C-c h" . helm-mini)
	 ("C-h a" . helm-apropos)
	 ("C-x C-b" . helm-buffers-list)
	 ("C-x b" . helm-buffers-list)
	 ("M-y" . helm-show-kill-ring)
	 ("M-x" . helm-M-x)
	 ("C-x c o" . helm-occur)
	 ("C-x c s" . helm-swoop)
	 ("C-x c y" . helm-yas-complete)
	 ("C-x c Y" . helm-yas-create-snippet-on-region)
	 ("C-x c b" . my/helm-do-grep-book-notes)
	 ("C-x c SPC" . helm-all-mark-rings)))
(ido-mode -1) ;; Turn off ido mode in case I enabled it accidentally

(use-package helm-descbinds
  :defer t
  :bind (("C-h b" . helm-descbinds)
	 ("C-h w" . helm-descbinds)))

;;; Other configs
(use-package smart-mode-line)
(fset 'yes-or-no-p 'y-or-n-p)
;;you can edit the minibuffer now
(use-package miniedit
  :commands minibuffer-edit
  :init (miniedit-install))

;;set color system
(defun my/setup-color-theme ()
  (interactive)
  (when (display-graphic-p)
    (color-theme-solarized))
  (set-background-color "black")
  (set-face-foreground 'secondary-selection "darkblue")
  (set-face-background 'secondary-selection "lightblue")
  (set-face-background 'font-lock-doc-face "black")
  (set-face-foreground 'font-lock-doc-face "wheat")
  (set-face-background 'font-lock-string-face "black"))
(use-package color-theme-solarized :config (my/setup-color-theme))

;;undo tree mode, now you can visually walk though the changes you have made
(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

;;helper--guide-key, some rescure when you can not remember some keyboard shortcuts
(use-package guide-key
  :defer t
  :diminish guide-key-mode
  :config
  (progn
    (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-c"))
    (guide-key-mode 1)))

;;utf-8 setting
(prefer-coding-system 'utf-8)
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

;;killing text
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
	           (line-beginning-position 2)))))

;;;Navigation in a buffer
;;Pop to mark, a handy way of getting back to previous places
(cond
 ((string-equal system-type "windows-nt")
  (progn
    (bind-key "M-s s" 'set-mark-command))))
(bind-key "C-x p" 'pop-to-mark-command)
(setq set-mark-command-repeat-pop t)

;;Helm swoop -quickly finding lines
(use-package helm-swoop
  :bind
  (("C-S-s" . helm-swoop)
   ("M-i" . helm-swoop)
   ("M-s M-s" . helm-swoop)
   ("M-I" . helm-swoop-back-to-last-point)
   ("C-c M-i" . helm-multi-swoop)
   ("C-x M-i" . helm-multi-swoop-all)
   )
  :config
  (progn
    (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
    (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop))
  )

;;windowmove - switching between windows
;;if you boring the "C-x o", use this now"
(use-package windmove
  :bind
  ("M-<right>" . windmove-right)
  ("M-<left>" . windmove-left)
  ("M-<up>" . windmove-up)
  ("M-<down>" . windmove-down))

;;frequently-accessed files

;; smartscan
(use-package smartscan
  :defer t
  :config (global-smartscan-mode t))

;;;Coding...
;;tab width of 4
(setq-default tab-width 4)

;;new lines are always indented
(global-set-key (kbd "RET") 'newline-and-indent)
(defun sanityinc/kill-back-to-indentation ()
  "kill from point back to the first non-whitespace character on the line."
  (interactive)
  (let ((prev-pos (point)))
	(back-to-indentation)
	(kill-region (point) prev-pos)))
(bind-key "C-M-<backspace>" 'sanityinc/kill-back-to-indentation)

;;show column number
(column-number-mode 1)

;;expand region
(use-package expand-region
  :defer t
  :bind ("C-=". er/expand-region)
  ("C-<prior>" . er/expand-region)
  ("C--" . er/contract-region))

;;smarter move to the begining of the line
(defun my/smarter-move-beginning-of-line (arg)
    "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
	(interactive "^p")
	(setq arg (or arg 1))

	;; Move lines first
	(when (/= arg 1)
	  (let ((line-move-visual nil))
		(forward-line (1- arg))))

	(let ((orig-point (point)))
	  (back-to-indentation)
	  (when (= orig-point (point))
		(move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
				                'my/smarter-move-beginning-of-line)


;;;Config for gofers
(use-package go-mode)
(use-package exec-path-from-shell)

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
						  "[ \t\n]*$"
						  ""
						  (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
	(setenv "PATH" path-from-shell)
	(setq eshell-path-env path-from-shell) ; for eshell users
	(setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

(setenv "GOPATH" "C:\\Users\\hjiang\\go")

;;automatically call gofmt on save
(add-to-list 'exec-path "C:\\Go\\bin") 

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
	  (set (make-local-variable 'compile-command)
		   "go build -v && go test && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-,") 'pop-tag-mark))

(add-hook 'go-mode-hook 'my-go-mode-hook)

;;auto complete mode for golang
(use-package auto-complete)
(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)

(use-package go-autocomplete)
(with-eval-after-load 'go-mode
  (require 'go-autocomplete))
