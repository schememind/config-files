;; TODO before run:
;; 1. ag (Silver searcher) - download and add to PATH environment variable
;; 2. plantuml - download jar file (specify its location in variables below)
;; 3. graphviz - download and add to PATH environment variable
;; 4. Add folder containing diff.exe to PATH environment variable
;;    (e.g. as a part of Git Bash located inside C:\Program Files\Git\usr\bin)
;;    in order to use ediff.

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

;; Multiple cursors (For find'n'replace I personally use 'M-%' or 'Helm + C-c C-e' more often)
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)       ;; First select region, then run this command to edit all its lines.
         ("C->" . mc/mark-next-like-this)      ;; If region is selected: MARK NEXT OCCURRENCE; If region not selected: ADD CURSOR TO NEXT LINE.
         ("C-<" . mc/mark-previous-like-this)  ;; If region is selected: MARK PREVIOUS OCCURRENCE; If region not selected: ADD CURSOR TO PREVIOUS LINE.
         ("C-c C->" . mc/mark-all-like-this))
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
  (setq helm-ag-base-command '--vimgrep)  ;; Windows users should set this option for using helm-do-ag (to search with additional command line arguments)
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

;; Automatic closing of parentheses
(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode t)
  (setq sp-show-pair-from-inside 1)
  (require 'smartparens-config)
  :diminish smartparens-mode)

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

;; ========
;; LSP mode
;; ========
;; To activate this mode run command 'lsp' (not 'lsp-mode'!) for every file you open.
;; Better simply apply a hook script.
;; Useful commands: lsp-find-definition, lsp-find-declaration, lsp-find-references
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  (c++-mode . lsp-deferred)
  (c-mode . lsp-deferred)
  ;;(java-mode . lsp-deferred)
  ;; The following programs must be in the PATH for D language (TODO: still no working):
  ;; - DCD
  ;; - serve-d (https://github.com/Pure-D/serve-d#installation)
  ;;(d-mode . lsp-deferred)
  ;;(python-mode . lsp-deferred)
  (lsp-mode . lsp-enable-which-key-integration)
  )
;; Useful commands: lsp-ui-peek-find-definitions (M-.), lsp-ui-peek-find-references (M-?) <-- TODO
(use-package lsp-ui
  :commands lsp-ui-mode)
(use-package helm-lsp
  :commands helm-lsp-workspace-symbol)
;; All commands start with 'lsp-treemacs...'
(use-package lsp-treemacs
  :ensure t)

;; ============
;; Dired tweaks
;; ============
;; When helm is started before displaying dired, always choose the top-most directory in the list!
;; (https://github.com/Fuco1/dired-hacks)
;; 1. Expand folders with indentation (i - expand; ; - shrink)
(use-package dired-subtree
  :ensure t
  :config
  (bind-keys :map dired-mode-map
             ("i" . dired-subtree-insert)
             (";" . dired-subtree-remove)
             ))

;; ===============
;; Org-mode tweaks
;; ===============
(setq ;; org-startup-indented t             ;; Visually indent levels of org files (indentation is not real)
      calendar-week-start-day 1          ;; Monday as start date of the week
;;      org-pretty-entities t              ;; Nicer looking special symbols (e.g. superscript)
;;      org-hide-emphasis-markers t        ;; hide ** for bold, // for italic etc
      org-startup-with-inline-images t   ;; Inline images
;;      org-image-actual-width '(300)      ;; #+attr_org: :width 300 - by default
      )

;; ============================================================
;; Zettelkasten - 'zetteldeft' package on top of 'deft' package
;; ============================================================
;; All notes are kept as plain text files in a single folder.
;; TODO: currently evil mode is turned on automatically when new note is created?
;; C-c d n: new note
;; C-c d N: new note + link
;; C-c d B: new note + backlink
;; C-c d f: follow link
;; C-c d o: open note from zetteldeft folder
(use-package deft
  :ensure t
  :custom
    (deft-extensions '("org" "md" "txt"))
    (deft-directory "~/notes")             ;; Folder for all notes
    (deft-use-filename-as-title t))
(use-package zetteldeft
  :ensure t
  :after deft
  :config (zetteldeft-set-classic-keybindings))

;; ========
;; PlantUML
;; ========
;; Requires plantuml.jar and optianally GraphViz for additional graph types.
;;
;; In org-mode file add '#+startup: inlineimages' option and create babel block like this:
;;
;; #+begin_src plantuml :file testdiagram.png :exports results
;;     ...
;; #+end_src
;;
;; When in babel block run 'C-c C-c' to render/refresh the image.

;; Optionally install plantuml-mode for syntax highlighting in babel blocks:
(use-package plantuml-mode
  :ensure t)
(setq plantuml-jar-path "c:/MyPrograms/PlantUML/plantuml.jar")      ;; TODO modify accordingly
(setq plantuml-default-exec-mode 'jar)                              ;; Use local jar instead of server
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))  ;; Files with .plantuml extension

;; Configure org-babel to render plantuml graphs
(with-eval-after-load 'org
(org-babel-do-load-languages
 'org-babel-load-languages
 '((plantuml . t)
   (dot . t)    ;; graphviz
   )))

(setq org-plantuml-jar-path
      (expand-file-name "c:/MyPrograms/PlantUML/plantuml.jar"))     ;; TODO modify accordingly

(setq org-confirm-babel-evaluate nil)                               ;; Execute block evaluation without confirmation
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)  ;; Display/update images in the buffer after evaluation

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

;; Taken from http://blog.bookworm.at/2007/03/pretty-print-xml-with-emacs.html
(defun zk-pretty-format_xml (begin end)
  "Format selected XML"
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
      (backward-char) (insert "\n") (setq end (1+ end)))
    (indent-region begin end)))

(defun zk-insert-src ()
  "Insert org source code block at cursor position"
  (interactive)
  (insert "#+BEGIN_SRC ")
  (newline)
  (insert "#+END_SRC")
  (forward-line -1)
  (forward-char 12))

(defun zk-insert-plantuml ()
  "Insert plantuml org source block with a sample code at cursor position"
  (interactive)
  (insert (concat "#+BEGIN_SRC plantuml :file " (read-string "Output file name without extension: ") ".png :exports results"))
  (newline)
  (insert "' Press C-c C-c to generate and display results.")
  (newline)
  (insert "' Call org-indent-region (C-M-\\) to format the block.")
  (newline)
  (insert "' Add line '#+STARTUP: inlineimages' to this file in order to see images.")
  (newline)
  (insert "' Good reference page: https://plantuml.com/deployment-diagram")
  (newline)
  (newline)
  (insert "package mypackage as \"Package title\" {")
  (newline)
  (insert "    left to right direction")
  (newline)
  (insert "    rectangle r1 as \"Some text\\n    here\"")
  (newline)
  (insert "    node n2 as \"And here\"")
  (newline)
  (insert "}")
  (newline)
  (insert "actor a1 as \"Person\" #lightblue")
  (newline)
  (newline)
  (insert "r1 <--> n2 : \"Link description\"")
  (newline)
  (insert "r1 ..> a1")
  (newline)
  (insert "#+END_SRC")
  (forward-line -10))

(defun zk-insert-graphviz ()
  "Insert graphviz org source block with a sample code at cursor position"
  (interactive)
  (setq gvfn (read-string "Output file name without extension: "))
  (setq gvext (completing-read "Output format: " '("pdf" "png")))
  (setq gveng (completing-read "Layout engine" ("dot" "fdp" "twopi" "circo" "neato" "osage" "patchwork" "sfdp")))
  (insert (concat "#+BEGIN_SRC dot :file " gvfn "." gvext " :cmdline -K" gveng " -T" gvext ))
  (newline)
  (insert "' Press C-c C-c to generate and display results.")
  (newline)
  (insert "' Call org-indent-region (C-M-\\) to format the block.")
  (newline)
  (insert "' Examples:")
  (newline)
  (insert "' - Subgraphs: https://graphviz.org/Gallery/directed/cluster.html")
  (newline)
  (insert "#+END_SRC")
  (forward-line -1))

(global-set-key (kbd "M-o") 'zk-smart-open-line)
(global-set-key (kbd "M-O") 'zk-smart-open-line-above)

;; Use F7 for helm-ag.
;; Or use C-u F7 to select a folder before searching.
(global-set-key (kbd "<f7>") 'helm-ag)  ;; TODO temporarily moved it here, as binding inside use-package block did not work for some reason

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
(global-auto-revert-mode t)  ;; Auto refresh buffers from the disk
;; Store all backup~ files in a specific directory and don't delete hardlinks
(setq backup-directory-alist '(("." . "~/.emacs.d/zk_backups")))
(setq backup-by-copying t)

;; Smooth scrolling:
;; Good speed and allow scrolling through large images (pixel-scroll).
;; Note: Scroll lags when point must be moved but increasing the number
;;       of lines that point moves in pixel-scroll.el ruins large image
;;       scrolling. So unfortunately I think we'll just have to live with
;;       this.
(pixel-scroll-mode)
(setq pixel-dead-time 0) ; Never go back to the old scrolling behaviour.
(setq pixel-resolution-fine-flag t) ; Scroll by number of pixels instead of lines (t = frame-char-height pixels).
(setq mouse-wheel-scroll-amount '(1)) ; Distance in pixel-resolution to scroll each mouse wheel event.
(setq mouse-wheel-progressive-speed nil) ; Progressive speed is too fast for me.

;; Font
(set-face-attribute 'default nil
                    :family "Consolas"
                    :height 100
                    :weight 'normal
                    :width 'normal)
;; Mac OS X: use Command key as "M" instead of Alt
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)
;; For Leuven theme: fontify the whole line for headings (with a background color).
(setq org-fontify-whole-heading-line t)
;; Open config file at startup
(find-file "~/.emacs.d/init.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(custom-enabled-themes '(leuven))
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
(put 'narrow-to-page 'disabled nil)
