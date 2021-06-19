(setq inhibit-startup-message t)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives'
         ("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; Bootstrap 'use-package': a package for easier package management
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Now we use "use-package" to install other packages
;; "try": lets user try packages without installing them
(use-package try
       :ensure t)

;; "which-key": brings up help on key combinations
(use-package which-key
       :ensure t
       :config
       (which-key-mode))

;; "company": autocompletion
(use-package company
    :ensure t
    :config
        (setq company-idle-delay 0)
        (global-company-mode 1)
        (global-set-key (kbd "C-<tab>") 'company-complete))

;; Syntax checker (also used in LSP mode)
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;; Avy - like easymotion (but not to use in evil/vim mode)
;; https://github.com/abo-abo/avy
(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-char))

;; Expand region with C-=
;; Shrink region with C-+
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region)
  :bind ("C-+" . er/contract-region)
  )

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c d" . mc/mark-all-like-this))
  )

;; helm enhanced searching
(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x f" . helm-recentf)
        ; ("C-SPC" . helm-dabbrev)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-buffers-list))
  :config (progn
      (setq helm-buffers-fuzzy-matching t)
        (helm-mode 1)))
(use-package helm-swoop     ; Replace standard C-s with helm search
  :ensure t
  :bind (("C-s" . helm-swoop)
         ;;("M-s" . helm-swoop-back-to-last-point)
         )
  )
(use-package helm-ag  ;; Use Silver Searcher installed and specified in PATH variable
  :ensure t
  :requires helm
  :config
  (setq helm-ag-base-command '--vimgrep)
  :bind (("<f7>" . helm-ag))  ;; This does not work for some reason
  )

;; Projectile
(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (projectile-mode +1))
(use-package helm-projectile
  :ensure t
  :config (helm-projectile-on))

;; D language
(use-package d-mode
  :ensure t)

;; YAML mode + file association + correct newline handling
(use-package yaml-mode
  :ensure t)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-hook 'yaml-mode-hook
    '(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; =========
;; evil-mode
;; =========
(use-package evil
  :ensure t ;; install the evil package if not installed
  :init ;; tweak evil's configuration before loading it
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  ;;(setq evil-search-module 'evil-search)
  ;;(setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config ;; tweak evil after loading it
  (evil-mode -1)    ;; change to 1 to enable evil mode at startup

  ;; example how to map a command in normal mode (called 'normal state' in evil)
  ;;(define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit)
  )
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; =====================
;; My personal functions
;; =====================
(defun zk-smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun zk-smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "M-o") 'zk-smart-open-line)
(global-set-key (kbd "M-O") 'zk-smart-open-line-above)

;; =======================
;; My personal preferences
;; =======================
;; Toolbars
(tool-bar-mode -1)
(menu-bar-mode -1)
;; Always show column number
(setq column-number-mode t)
;(toggle-scroll-bar -1)
;; Line numbers
(setq-default display-line-numbers 'relative)
;; Set tab to 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;(setq indent-line-function 'insert-tab)
(setq c-default-style "stroustrup")
;; Personal key bindings
(global-set-key (kbd "<f8>") 'toggle-menu-bar-mode-from-frame)
;; Display time
;; (display-time-mode 1)
;;(display-time-day-and-date 1)
;;(display-time-24hr-format display-time-format 1)
(delete-selection-mode t)    ;; Delete selection when typing
(setq visible-bell t)        ;; Disable beeping
(global-visual-line-mode t)  ;; Word wrap by whole words
(setq show-paren-delay 0)
(show-paren-mode t)          ;; Mark matching parentheses
(setq show-paren-style 'parenthesis)    ;; 'expression to color-mark the whole expression between parentheses
;; Font
(set-face-attribute 'default nil
                    :family "Consolas"
                    :height 100
                    :weight 'normal
                    :width 'normal)
;; Open config file at startup
(find-file "~/.emacs.d/init.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(wombat))
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(evil-collection evil d-mode helm-projectile projectile which-key use-package try flycheck company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
