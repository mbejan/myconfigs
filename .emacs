(setq max-lisp-eval-depth 10000)

(setq package-user-dir "c:/users/bejanm/tools/emacs/.elpa/")        
;; ;;msys
;; (if (eq system-type 'windows-nt)
;;   else
;;   (setq package-user-dir "~/.elpa")
;;   )

(package-initialize)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Cascadia Mono" :foundry "outline" :slant normal :weight normal :height 98 :width normal)))))
                                       ; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         )

      )


(if (eq system-type 'windows-nt)
    (progn
      (setq exec-path (cons "c:/users/bejanm/tools/emacs/" exec-path))
      (setq exec-path (cons "c:/users/bejanm/tools/mingw64/msys/1.0/bin/" exec-path))
      (setq exec-path (cons "c:/users/bejanm/tools/LLVM/bin/" exec-path))
      (setq exec-path (cons "c:/users/bejanm/tools/cmake/bin/" exec-path))

      (setq load-path (cons "c:/users/bejanm/tools/emacs/" load-path))
      (add-to-list 'custom-theme-load-path "c:/Users/bejanm/tools/emacs/")
      (setq load-path (cons "c:/users/bejanm/tools/work" load-path))
      ))



(menu-bar-mode -1)



(if window-system
    (custom-set-variables '(tool-bar-mode nil)
                          '(tooltip-mode nil)
                          )
  ;;else
  ;;  ( (custom-set-variables '(irony-server-install-prefix "~/.emacs.d/irony/server")))
  )





(setq backup-inhibited t)
(setq auto-save-default nil)


(if (eq system-type 'windows-nt)
    (progn
      (setq exec-path (cons "c:/users/bejanm/tools/git/bin" exec-path))
      (setq exec-path (cons "c:/users/bejanm/tools/node" exec-path))
      (setq exec-path (cons "c:/users/bejanm/tools/node/node_modules/.bin" exec-path))
      )
  )


(defun my-load-irony-options()
  (if (eq system-type 'windows-nt)
      (progn
        (setq exec-path (cons "c:/users/bejanm/tools/emacs/xref" exec-path))
        (setq load-path (cons "c:/users/bejanm/tools/emacs/xref/emacs" load-path))
        (load "xrefactory")
        )
    )

  (require 'irony)


  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async)

  (irony-mode)
  (irony-cdb-autosetup-compile-options)

  ;; Default config for company-irony mode
  (eval-after-load 'company
    '(add-to-list
      'company-backends 'company-irony))

  (global-company-mode)
  (eval-after-load 'company
    '(add-to-list
      'company-backends 'company-irony))

  (add-hook 'c-mode-hook 'load-ide-c)
  (add-hook 'c++-mode-hook 'load-ide-c)

  )

(defun load-ide-helm()
  (interactive)
  (require 'use-package)
  (require 'bind-key)

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
                      ("C-x C-f" . helm-find-files)
                      ("M-y" . helm-show-kill-ring)
                      ("M-x" . helm-M-x)
                      ("C-x c o" . helm-occur)
                      ("C-x c s" . helm-swoop)
                      ("C-x c y" . helm-yas-complete)
                      ("C-x c Y" . helm-yas-create-snippet-on-region)
                      ("C-x c b" . my/helm-do-grep-book-notes)
                      ("C-x c SPC" . helm-all-mark-rings)))
  (ido-mode -1) ;; Turn off ido mode in case I enabled it accidentally


  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))

  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

  (when (executable-find "curl")
    (setq helm-google-suggest-use-curl-p t))

  (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
        helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
        helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
        helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
        helm-ff-file-name-history-use-recentf t
        helm-echo-input-in-header-line t)

  (defun spacemacs//helm-hide-minibuffer-maybe ()
    "Hide minibuffer in Helm session if we use the header line as input field."
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
        (overlay-put ov 'window (selected-window))
        (overlay-put ov 'face
                     (let ((bg-color (face-background 'default nil)))
                       `(:background ,bg-color :foreground ,bg-color)))
        (setq-local cursor-type nil))))


  (add-hook 'helm-minibuffer-set-up-hook
            'spacemacs//helm-hide-minibuffer-maybe)

  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)

  (helm-mode 1)

  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  ;;(helm-projectile-on)
  ;;(setq projectile-indexing-method 'alien)
  )

(defun load-ide-c()
  (interactive)
  (load-ide-helm)

  (my-load-irony-options)
  )

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;
;;  Python
;;
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional
(setq jedi:complete-on-dot t)                 ; optional
(setq jedi:environment-root "c:/users/bejanm/ANZ/work/_git/authentic/scripts/axis/venv")
(setq jedi:environment-virtualenv "c:/users/bejanm/ANZ/work/_git/authentic/scripts/axis")
(setq venv-location (expand-file-name "c:/users/bejanm/ANZ/work/_git/authentic/scripts/axis"))
(setq python-environment-directory venv-location)


(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'auto-revert-mode)
;;
;;  C++
;;

(add-hook 'c-mode-hook 'load-ide-c)
                                        ;(eval-after-load 'flycheck
                                        ;  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;;(add-hook 'c-mode-hook 'load-ide-c)
;;(add-hook 'c++-mode-hook 'load-ide-c)
;;(add-hook 'c-mode-hook 'my-load-irony-options)
;;(add-hook 'c++-mode-hook 'my-load-irony-options)
;;(add-hook 'objc-mode-hook 'my-load-irony-options)


;; Only needed on Windows
(when (eq system-type 'windows-nt)
  (setq w32-pipe-read-delay 0)


  (defun my-java-mode-hook ()
    ;; (load-ide-helm)

    ;; (setq help-at-pt-display-when-idle t)
    ;; (setq help-at-pt-timer-delay 0.1)
    ;; (help-at-pt-set-timer
    ;;  )


    ;; (eval-after-load 'company
    ;;   '(add-to-list
    ;;     'company-backends))

    (require 'company)
    (global-company-mode t)

    )
  (add-hook 'java-mode-hook 'my-java-mode-hook)

  )


;;(require 'auto-complete)
;;(global-auto-complete-mode nil)

(defun load-ide-js()
  (interactive)
  (require 'org)

  (if (eq system-type 'windows-nt)
      (add-to-list 'load-path "c:/users/bejanm/tools/node/node_modules/tern/emacs/")
    )

  (require 'tern)


  ;; Default config for company-irony mode
  (eval-after-load 'company
    '(add-to-list
      'company-backends 'company-tern))

  (tern-mode t)
  (global-company-mode)
  (load-ide-helm)
  (add-hook 'js2-mode-hook 'load-ide-js)
  )


(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;(add-hook 'web-mode-hook (lambda () (tern-mode t)))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(setq c-default-style '((java-mode . "java")
                        (awk-mode . "awk")
                        (other . "stroustrup")))

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

(put 'downcase-region 'disabled nil)

(setq inhibit-startup-message t)

(setq visible-bell nil)
(setq ring-bell-function (lambda () ))

(setq visible-bell 1)



(unless window-system
  (progn
    (require 'zenburn-theme)
    (require 'color-theme-approximate)
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

;;(setq xref-marker-ring-length 16)
;;(defclass xref-location () ()
;;  :documentation "A location represents a position in a file or buffer.")
;;(require 'pkg-info)

;;some flycheck
;;(require 'flycheck)
;; (flycheck-define-checker erlang-otp
;;                          "An Erlang syntax checker using the Erlang interpreter."
;;                          :command ("erlc" "-o" temporary-directory "-Wall"
;;                                    "-I" "../include" "-I" "../../include"
;;                                    "-I" "../../../include" source)
;;                          :modes(erlang-mode)
;;                          :error-patterns
;;                          ((warning line-start (file-name) ":" line ": Warning:" (message) line-end)
;;                           (error line-start (file-name) ":" line ": " (message) line-end)))

;; (defun load-ide-erlang()
;;   (interactive)

;;   ;;load helm
;;   (load-ide-helm)

;;   (require 'erlang-start)

;;   (setq inferior-erlang-machine-options '("-sname" "emacs"))
;;   ;; prevent annoying hang-on-compile
;;   (defvar inferior-erlang-prompt-timeout t)
;;   ;; tell distel to default to that node
;;   (setq erl-nodename-cache
;;         (make-symbol
;;          (concat
;;           "emacs@"
;;           ;; Mac OS X uses "name.local" instead of "name", this should work
;;           ;; pretty much anywhere without having to muck with NetInfo
;;           ;; ... but I only tested it on Mac OS X.
;;           (car (split-string (shell-command-to-string "hostname"))))))



;;   (setq distel-completion-get-doc-from-internet t)
;;   (setq company-distel-popup-help t)
;;   (setq company-distel-popup-height 30)

;;   (require 'company-distel)

;;   (custom-set-variables
;;    '(company-backends (quote (company-distel company-keywords
;;                                              company-files company-dabbrev)))
;;    )

;;   (global-company-mode)
;;   (flycheck-select-checker 'erlang-otp)
;;   (flycheck-mode)
;;   (add-hook 'erlang-mode-hook 'load-ide-erlang)
;;   )



;; (if (eq system-type 'windows-nt)
;;     (progn
;;       (setenv "HOMEDRIVE" "c:")
;;       (setenv "HOMEPATH" "/Users/UK17RE/AppData/Roaming")
;;       (setenv "PATH" (concat (getenv "PATH") ":c:/users/bejanm/tools/erlang/erts-8.1/bin"))
;;       (setq erlang-root-dir "c:/users/bejanm/tools/erlang/erts-8.1")
;;       (setq exec-path (cons "c:/users/bejanm/tools/erlang/erts-8.1/bin" exec-path))
;;       (add-to-list 'load-path "c:/users/bejanm/tools/emacs/distel/elisp")
;;       )
;;   )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(zenburn))
 '(custom-safe-themes
   '("e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" default))
 '(package-selected-packages
   '(wsd-mode company-jedi company web maven-test-mode json-mode tern magit markdown-mode virtualenvwrapper virtualenv zenburn-theme yaml-mode use-package pyenv-mode-auto powershell jenkins jedi javascript irony helm groovy-mode git-gutter+ git-commit-insert-issue git-command git flycheck-yamllint flycheck-pyflakes dockerfile-mode color-theme-approximate butler))
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(virtualenv-root "c:/users/bejanm/work/_git/authentic/scripts/axis/"))


