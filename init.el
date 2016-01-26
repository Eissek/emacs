(menu-bar-mode -1)
(tool-bar-mode -1)

;;;;
;; Packages
;;;;

;; Define package repositories
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
;; (add-to-list 'package-archives
             ;; '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                          ("marmalade" . "http://marmalade-repo.org/packages/")
;;                          ("melpa" . "http://melpa-stable.milkbox.net/packages/")))


;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

(load-theme 'cyberpunk t)
;; (add-hook 'after-init-hook 
      ;; (lambda () (load-theme 'cyberpunk t)))

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))


(require 'workgroups2)

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    ;cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-ubiquitous

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit

    ;;workgroups 2 save buffer position
    workgroups2
    ))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;




;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")

;; (load-theme 'cyberpunk t)
;; (add-hook 'after-init-hook 
      ;; (lambda () (load-theme 'cyberpunk t)))



(define-key global-map (kbd "RET") 'newline-and-indent)

(add-hook 'after-init-hook #'global-flycheck-mode)

;;Major Mode for js2-mode of JavaScript
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; Minor mode
(add-hook 'js-mode-hook 'js2-minor-mode)



 ;; Set your lisp system and, optionally, some contribs
(require 'slime)
(setq inferior-lisp-program "/usr/local/bin/csi")
 (setq slime-contribs '(slime-fancy slime-banner))
;;(slime-setup '(slime-fancy slime-banner))
(add-to-list 'load-path "/usr/local/lib/chicken/7/")   ; Where Eggs are installed
(autoload 'chicken-slime "chicken-slime" "SWANK backend for Chicken" t)

(add-hook 'scheme-mode-hook
          (lambda ()
           (slime-mode t)))

;; (setq slime-csi-path "/usr/local/bin/csi")


;; Geiser settings
(setq geiser-repl-use-other-window nil)
;; Tell Geiser to look for only Chicken Scheme files
(setq geiser-active-implementations '(chicken))
(setq geiser-debug-jump-to-debug-p nil)
(setq geiser-debug-show-debug-p nil)

;;(require 'autopair)
;;(autopair-global-mode) ;; enable autopair in all buffers

;; turn on automatic bracket insertion by pairs. New in emacs 24
(electric-pair-mode 1)

(global-unset-key (kbd "C-z"))

(defun cider-figwheel-repl ()
  (interactive)
  (save-some-buffers)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(require 'figwheel-sidecar.repl-api)
             (figwheel-sidecar.repl-api/cljs-repl)")
    (cider-repl-return)))

(global-set-key (kbd "C-c C-f") 'cider-figwheel-repl)

;; Change some settings
(workgroups-mode 1)  ; put this one at the bottom of .emacs
