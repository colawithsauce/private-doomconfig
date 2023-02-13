;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "ColaWithSauce"
      user-mail-address "cola_with_sauce@foxmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "BlexMono Nerd Font" :size 24)
      doom-variable-pitch-font (font-spec :family "LXGW WenKai" :size 24))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-material)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq doom-modeline-buffer-file-name-style 'auto)
(setq line-number-mode nil)
(setq column-number-mode nil)
(setq size-indication-mode nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (add-to-list 'face-font-rescale-alist '("IBM Plex Sans JP" . 0.9))

(setq save-interprogram-paste-before-kill t)
(setq kill-do-not-save-duplicates t)

(map! (:after evil-org
       :map evil-org-mode-map
       :n "gk" (cmd! (if (org-on-heading-p)
                         (org-backward-element)
                       (evil-previous-visual-line)))
       :n "gj" (cmd! (if (org-on-heading-p)
                         (org-forward-element)
                       (evil-next-visual-line)))
       :ni "M-)" (cmd! (insert "\\[\\]") (backward-char 2))
       :ni "M-(" (cmd! (insert "\\(\\)") (backward-char 2))))

(after! company
  (setq company-idle-delay nil))

(use-package! fanyi
  :config
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  (map! :leader :desc "Translate" :nvie "s y" #'fanyi-dwim))

(after! rust-mode
  (use-package! rust-mode
    :config
    (setq rustic-analyzer-command '("rustup" "run" "nightly" "rust-analyzer"))))

(use-package! rime
  :custom
  (default-input-method "rime")
  :config
  (setq rime-mode-hook nil)
  (add-hook! 'rime-mode-hook :append
    (set-fontset-font t 'han (font-spec :family "LXGW WenKai"))
    (set-fontset-font t 'cjk-misc (font-spec :family "LXGW WenKai"))
    (set-fontset-font t '(#xf0000 . #xf0142) (font-spec :family "98WB-0"))))

(after! eglot
  (setq eglot-ignored-server-capabilities '(:documentHighlightProvider))
  (use-package! eldoc-box
    :config
    (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)))

(after! lsp-mode
  (add-hook! 'racket-mode-hook :append (lambda () (eldoc-mode -1))))

(after! telega
  (setq telega-server-libs-prefix "/usr/local"))

(after! org
  ;; (setq org-latex-packages-alist)
  (setq org-clock-mode-line-total 'today)
  (setq org-tag-alist '((:startgroup . nil)
                        ("@hard" . ?h) ("@medium" . ?m)
                        ("@easy" . ?e)
                        (:endgroup . nil)
                        (:startgroup . nil)
                        ("@tools" . ?t)
                        ("@program" . ?p)
                        ("@others" . ?o)
                        (:endgroup . nil)
                        (:startgroup . nil)
                        ("@notes" . ?n)
                        ("@article" . ?a)
                        ("@books" . ?b)
                        ("@paper" . ?l)
                        (:endgroup . nil)
                        ("card" . ?c)))
  (plist-put! org-format-latex-options :scale 2.0)
  (add-hook 'org-mode-hook (cmd! (display-line-numbers-mode -1)))
  (after! org-roam
    (use-package! consult-org-roam
      :init
      (consult-org-roam-mode 1)
      :config
      (map! :mode org-mode
            (:localleader
             :desc "Forward link" :ni "m l" #'consult-org-roam-forward-links
             :desc "Backward link" :ni "m h" #'consult-org-roam-backlinks))
      (setq org-roam-dailies-directory "journals/")
      (setq org-roam-capture-templates
            '(("d" "default" plain "%?" :target
               (file+head "${slug}.org" "#+title: ${title}\n")
               :unnarrowed t)))
      (add-to-list 'org-roam-file-exclude-regexp "logseq/bak"))))

;; (use-package! org-latex-impatient
;;   :defer t
;;   :load-path "~/Project/org-latex-impatient"
;;   :hook (org-mode . org-latex-impatient-mode)
;;   :init
;;   (setq org-latex-impatient-tex2svg-bin
;;         ;; location of tex2svg executable
;;         "~/node_modules/mathjax-node-cli/bin/tex2svg"))

(use-package! rime-regexp
  :load-path "~/.doom.d/lisp/rime-regexp.el"
  :after-call rime-mode-hook
  :config
  (rime-regexp-mode t))

(setq word-wrap-by-category t)

(after! rjsx-mode
  (setq js-indent-level 4))
