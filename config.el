;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 20 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/Orgzly/")

(after! org
  (setq org-capture-templates
      '(("i" "input" entry (file "~/Dropbox/Orgzly/Eingang.org")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :empty-lines 1)
        ("b" "bookmark" entry (file "~/Dropbox/Orgzly/Lesezeichen.org")
         "* [[%x][%?]] :Link:\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :empty-lines 1))))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; no confirmation needed when quitting emacs
(setq confirm-kill-emacs nil)

;; search path for projectile, use M-x projectile-discover-projects-in-search-path to actually search and set projects
(setq projectile-project-search-path '("~/Dokumente/documentation/"
                                       "~/Dokumente/Meine-Mathe-Skripts/"))

;; in dired copy and move to dir in next dired buffer
(setq dired-dwim-target t)


(map! :leader
      (:prefix-map ("j" . "folding")
       ;;(:prefix ("j" . "journal")
        :desc "outline show all" "S" #'outline-show-all
        :desc "outline hide body" "H" #'outline-hide-body
        :desc "outline show entry" "s" #'outline-show-entry
        :desc "outline hide entry" "h" #'outline-hide-entry
;;        :desc "evil close fold" "c" #'evil-close-fold
;;        :desc "evil open fold" "o" #'evil-open-fold
;;        :desc "evil close folds" "C" #'evil-close-folds
;;        :desc "evil open folds" "O" #'evil-open-folds
))

(map! :leader
      (:prefix-map ("r" . "region")
       :desc "comment" "c" #'comment-region
       :desc "uncomment" "u" #'uncomment-region)
      (:prefix-map ("b" . "buffer")
       :desc "menu" "m" #'buffer-menu
       :desc "eval" "e" #'eval-buffer))

(map! (:when (featurep! :lang latex)
       (:map LaTeX-mode-map
        :localleader
        :desc "svg" "s" #'ykey-latex-to-svg)))

;; always turn on outline-minor-mode in latex-mode
(add-hook! 'latex-mode-hook 'outline-minor-mode)

(global-set-key (kbd "C-c b") 'buffer-menu)
;; test
(global-set-key (kbd "C-c c") 'buffer-menu)

(defun ykey-latex-to-svg ()
  (interactive)
  (let ((file
         (concat "\""
                 (file-name-sans-extension
                  (file-name-nondirectory
                   (buffer-file-name)))
                 "\"")))
  (call-process-shell-command "latex" nil nil nil file)
  (call-process-shell-command "dvisvgm" nil nil nil file)
  (ykey-revert-file-buffers)))

(defun ykey-revert-file-buffers ()
  (interactive)
  (let (file)
    (dolist (buf (buffer-list))
      (setq file (buffer-file-name buf))
      (when (and file (file-readable-p file))
        (with-current-buffer buf
          (with-demoted-errors "Error: %S" (revert-buffer t t)))))))
