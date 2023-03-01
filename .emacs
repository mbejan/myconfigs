;; -*- lexical-binding: t; -*-

;;2023-03-01          Initial Release


;;
;;  General configs
;;
(setq max-lisp-eval-depth 10000)


;; Local .elpa folder used to move across devices without internet
(setq package-user-dir "~/.elpa")

; list the packages you want
(setq package-list '(zenburn-theme jedi json-mode yaml-mode))
; list the repositories containing them
(setq package-archives '())    
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("nongnu" . "http://elpa.nongnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(require 'package)
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


;; ;;
;; ;;  Windows specific
;; ;;
;; (if (eq system-type 'windows-nt)
;;     (progn
;;       (setq exec-path (cons "c:/users/bejanm/tools/emacs/" exec-path))
;;       (setq exec-path (cons "c:/users/bejanm/tools/mingw64/msys/1.0/bin/" exec-path))
;;       (setq exec-path (cons "c:/users/bejanm/tools/git/bin" exec-path))
;;       (setq exec-path (cons "c:/users/bejanm/tools/node" exec-path))
;;       (setq exec-path (cons "c:/users/bejanm/tools/node/node_modules/.bin" exec-path))
;;       (setq exec-path (cons "c:/tmpuser/tools/emacs/" exec-path))
;;       (setq exec-path (cons "c:/tmpuser/tools/mingw64/msys/1.0/bin/" exec-path))
;;       ))


;;
;;  Workspace
;;
(menu-bar-mode -1)
(if window-system
    (custom-set-variables '(tool-bar-mode nil)
                          '(tooltip-mode nil)
                          )
)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

(setq inhibit-startup-message t)
(setq visible-bell nil)
(setq ring-bell-function (lambda () ))
(setq visible-bell 1)

;;
;; Editor
;;
(setq backup-inhibited t)
(setq auto-save-default nil)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(put 'downcase-region 'disabled nil)

;;
;;  Python
;;
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional
(setq jedi:complete-on-dot t)                 ; optional
;;(setq jedi:environment-root "c:/users/bejanm/ANZ/work/_git/authentic/scripts/axis/venv")
;;(setq jedi:environment-virtualenv "c:/users/bejanm/ANZ/work/_git/authentic/scripts/axis")
;;(setq venv-location (expand-file-name "c:/users/bejanm/ANZ/work/_git/authentic/scripts/axis"))
;;(setq python-environment-directory venv-location)

(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'auto-revert-mode)


;;
;; C/C++
;;
(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (other . "stroustrup")))



;;
;;  Console stuff
;;
(unless window-system
  (progn
    (use-package color-theme-approximate)
    (color-theme-approximate-on)
    (xterm-mouse-mode)
    ;;    (require 'mouse+)

    (defvar alternating-scroll-down-next t)
    (defvar alternating-scroll-up-next t)

    (defun alternating-scroll-down-line ()
      (interactive "@")
      (when alternating-scroll-down-next
                                        ;      (run-hook-with-args 'window-scroll-functions )
        (scroll-down-line 10))
      (setq alternating-scroll-down-next (not alternating-scroll-down-next)))

    (defun alternating-scroll-up-line ()
      (interactive "@")
      (when alternating-scroll-up-next
                                        ;      (run-hook-with-args 'window-scroll-functions)
        (scroll-up-line 10))
      (setq alternating-scroll-up-next (not alternating-scroll-up-next)))

    (global-set-key (kbd "<mouse-4>") 'alternating-scroll-down-line)
    (global-set-key (kbd "<mouse-5>") 'alternating-scroll-up-line)
    (global-set-key (kbd "<mouse-2>") 'x-clipboard-yank)
    ))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(zenburn))
 '(custom-safe-themes
    '("2dc03dfb67fbcb7d9c487522c29b7582da20766c9998aaad5e5b63b5c27eec3f" default))
 '(package-selected-packages '(yaml-mode json-mode jedi zenburn-theme))
 '(tool-bar-mode nil)
 '(tooltip-mode nil))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Cascadia Code" :foundry "outline" :slant normal :weight normal  :width normal)))))
