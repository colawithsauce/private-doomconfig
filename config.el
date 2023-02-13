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

(setq save-interprogram-paste-before-kill t)
(setq kill-do-not-save-duplicates t)

;; (map! (:after evil-org
;;        :map evil-org-mode-map
;;        :n "gk" (cmd! (if (org-on-heading-p)
;;                          (org-backward-element)
;;                        (evil-previous-visual-line)))
;;        :n "gj" (cmd! (if (org-on-heading-p)
;;                          (org-forward-element)
;;                        (evil-next-visual-line)))
;;        :ni "M-)" (cmd! (insert "\\[\\]") (backward-char 2))
;;        :ni "M-(" (cmd! (insert "\\(\\)") (backward-char 2))))

(after! company
  (setq company-idle-delay nil))

(use-package! fanyi
  :config
  (setq read-extended-command-predicate #'command-completion-default-include-p)
  (map! :leader :desc "Translate" "s y" #'fanyi-dwim))

(after! rust-mode
  (use-package! rust-mode
    :config
    (setq rustic-analyzer-command '("rustup" "run" "nightly" "rust-analyzer"))))

(use-package! rime
  :custom
  (default-input-method "rime")
  :config
  (setq rime-disable-predicates
        '((lambda () (not (meow-insert-mode-p)))
          rime-predicate-prog-in-code-p
          rime-predicate-tex-math-or-command-p
          rime-predicate-hydra-p))
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
             :desc "Forward link" "m l" #'consult-org-roam-forward-links
             :desc "Backward link" "m h" #'consult-org-roam-backlinks))
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

(defun meow/setup-leader ()
  (map! :leader
        "?" #'meow-cheatsheet
        "/" #'meow-keypad-describe-key
        "1" #'meow-digit-argument
        "2" #'meow-digit-argument
        "3" #'meow-digit-argument
        "4" #'meow-digit-argument
        "5" #'meow-digit-argument
        "6" #'meow-digit-argument
        "7" #'meow-digit-argument
        "8" #'meow-digit-argument
        "9" #'meow-digit-argument
        "0" #'meow-digit-argument))

(defun meow/setup-doom-keybindings ()
  (map! :map meow-normal-state-keymap
        doom-leader-key doom-leader-map)
  (map! :map meow-motion-state-keymap
        doom-leader-key doom-leader-map)
  (map! :map meow-beacon-state-keymap
        doom-leader-key nil)
  (meow/setup-leader))

(defun set-useful-keybindings()
  (keymap-global-set "M-j" 'kmacro-start-macro-or-insert-counter)
  (keymap-global-set "M-k" 'kmacro-end-or-call-macro)
  ;;for doom emacs buffer management
  (map! :leader
        ;; make doom-leader-buffer-map alive
        (:prefix-map ("b" . "buffer")
         :desc "Toggle narrowing"            "-"   #'doom/toggle-narrow-buffer
         :desc "Previous buffer"             "["   #'previous-buffer
         :desc "Next buffer"                 "]"   #'next-buffer
         (:when (modulep! :ui workspaces)
           :desc "Switch workspace buffer"    "b" #'persp-switch-to-buffer
           :desc "Switch buffer"              "B" #'switch-to-buffer)
         (:unless (modulep! :ui workspaces)
           :desc "Switch buffer"               "b"   #'switch-to-buffer)
         :desc "Clone buffer"                "c"   #'clone-indirect-buffer
         :desc "Clone buffer other window"   "C"   #'clone-indirect-buffer-other-window
         :desc "Kill buffer"                 "d"   #'kill-current-buffer
         :desc "ibuffer"                     "i"   #'ibuffer
         :desc "Kill buffer"                 "k"   #'kill-current-buffer
         :desc "Kill all buffers"            "K"   #'doom/kill-all-buffers
         :desc "Switch to last buffer"       "l"   #'evil-switch-to-windows-last-buffer
         :desc "Set bookmark"                "m"   #'bookmark-set
         :desc "Delete bookmark"             "M"   #'bookmark-delete
         :desc "Next buffer"                 "n"   #'next-buffer
         :desc "New empty buffer"            "N"   #'+default/new-buffer
         :desc "Kill other buffers"          "O"   #'doom/kill-other-buffers
         :desc "Previous buffer"             "p"   #'previous-buffer
         :desc "Revert buffer"               "r"   #'revert-buffer
         :desc "Save buffer"                 "s"   #'basic-save-buffer
         ;;:desc "Save all buffers"            "S"   #'evil-write-all
         :desc "Save buffer as root"         "u"   #'doom/sudo-save-buffer
         :desc "Pop up scratch buffer"       "x"   #'doom/open-scratch-buffer
         :desc "Switch to scratch buffer"    "X"   #'doom/switch-to-scratch-buffer
         :desc "Bury buffer"                 "z"   #'bury-buffer
         :desc "Kill buried buffers"         "Z"   #'doom/kill-buried-buffers)))


;;;  meow setup
(defun meow-setup ()
  (set-useful-keybindings)
  ;; (meow/setup-doom-keybindings)
  ;; for doom emacs
  ;;(add-to-list 'meow-keymap-alist (cons 'leader doom-leader-map))
  ;;(meow-normal-define-key (cons "SPC" doom-leader-map))
  ;;(meow-motion-overwrite-define-key (cons "SPC" doom-leader-map))
  (map!
   (:when (modulep! :ui workspaces)
     :n "C-t"   #'+workspace/new
     :n "C-S-t" #'+workspace/display
     :g "M-1"   #'+workspace/switch-to-0
     :g "M-2"   #'+workspace/switch-to-1
     :g "M-3"   #'+workspace/switch-to-2
     :g "M-4"   #'+workspace/switch-to-3
     :g "M-5"   #'+workspace/switch-to-4
     :g "M-6"   #'+workspace/switch-to-5
     :g "M-7"   #'+workspace/switch-to-6
     :g "M-8"   #'+workspace/switch-to-7
     :g "M-9"   #'+workspace/switch-to-8
     :g "M-0"   #'+workspace/switch-to-final
     ))
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("q" . meow-cheatsheet))

  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("/" . meow-visit)
   '("a" . meow-append)
   '("A" . meow-join)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-symbol)
   '("E" . meow-mark-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-mark-word)
   '("M" . meow-mark-symbol)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("P" . pop-to-mark-command)
   '("q" . meow-open-below)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-grab)
   '("w" . meow-next-word)
   '("x" . meow-line)
   '("X" . meow-line-expand)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("\\" . quoted-insert)
   ;;'("<escape>" . mode-line-other-buffer)
   )
  ;; Let =C-[= be the =ESC= of =evil= in =meow=:
;;   (defun meow-insert-define-key (&rest keybindings)
;;     "Define key for insert state.

;; Usage:
;;   (meow-insert-define-key
;;    '(\"C-<space>\" . meow-insert-exit))"
;;     (mapcar (lambda (key-ref)
;;               (define-key meow-insert-state-keymap
;;                           (kbd (car key-ref))
;;                           (meow--parse-def (cdr key-ref))))
;;             keybindings))
;;   (meow-insert-define-key
;;    '("\C-[" . meow-insert-exit))

  (setq meow-expand-exclude-mode-list nil)
  (setq meow-expand-hint-remove-delay 1024)
  ;; TODO: replace define-key with keymap-set
  (define-key input-decode-map (kbd "C-[") [control-bracketleft])
  (define-key meow-insert-state-keymap [control-bracketleft] 'meow-insert-exit)
  ;;(keymap-set input-decode-map "C-[" 'meow-insert-exit)
  ;;(keymap-set meow-insert-state-keymap "C-[" 'meow-insert-exit)

  (setq meow-use-clipboard t
        meow-visit-sanitize-completion nil
        meow-expand-exclude-mode-list nil
        meow-expand-hint-remove-delay 1024
        )
  (add-to-list 'meow-mode-state-list '(hexl-mode . normal))
  )
(use-package meow
  :config
  (require 'meow)
  (meow-setup)
  (meow-global-mode 1)
  )
