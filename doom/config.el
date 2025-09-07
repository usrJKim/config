;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Junho Kim"
      user-mail-address "jnhkm11581@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;

(unless (facep 'quote) (make-face 'quote))
(setq doom-font (font-spec :family "Victor Mono" :size 20 )
      doom-variable-pitch-font (font-spec :family "Roboto" :size 20))
(setq-default line-spacing 2)
(setq doom-themes-enable-italic t
      doom-themes-enable-bold t)
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-type-face :slant italic)
  )
(setq default-input-method "korean-hangul")
(set-fontset-font t 'hangul (font-spec :name "Noto Sans KR"))

(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-SPC") nil)
  (define-key company-active-map (kbd "C-@") nil)
  (define-key company-mode-map (kbd "C-SPC") nil)
  (define-key company-mode-map (kbd "C-@") nil)
  )

(global-set-key (kbd "C-SPC") 'toggle-input-method)
(global-set-key (kbd "C-@")   #'toggle-input-method) ;; 터미널 대응

(map! :i "C-SPC" #'toggle-input-method
      :i "C-@"   #'toggle-input-method
      :n "C-SPC" #'toggle-input-method
      :v "C-SPC" #'toggle-input-method
      :o "C-SPC" #'toggle-input-method)

(map! :after vterm
      :map vterm-mode-map
      :ni "C-c" #'vterm-send-C-c
      :ni "C-z" #'vterm-send-C-z
      :ni "C-d" #'vterm-send-C-d)


(dolist (map '(minibuffer-local-map
               minibuffer-local-completion-map
               minibuffer-local-filename-completion-map
               minibuffer-local-must-match-map))
  (define-key (symbol-value map) (kbd "C-SPC") #'toggle-input-method)
  (define-key (symbol-value map) (kbd "C-@")   #'toggle-input-method)) ; TTY 대응

(after! emojify
  ;; 이미지를 써서 렌더 (폰트 말고 PNG)
  (setq emojify-display-style 'image)               ;; :contentReference[oaicite:0]{index=0}
  ;; 유니코드 이모지 + :smile: 같은 깃허브식도 인식
  ;; (setq emojify-emoji-styles '(unicode github))     ;; :contentReference[oaicite:1]{index=1}
  ;; 사용할 이미지 세트: 트위터의 Twemoji v2
  (setq emojify-emoji-set "twemoji-v2")             ;; :contentReference[oaicite:2]{index=2}
  ;; 이미지가 없으면 자동으로 받도록
  (setq emojify-download-emojis-p t))

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(add-to-list 'custom-theme-load-path "/home/junho/.config/doom/themes/")
;; (setq doom-theme 'doom-monokai-pro)
;; (setq doom-theme 'doom-nano-light)
(setq doom-theme 'doom-nano-dark)

;; dark-thene
(setq nano-color-faded "#677691")
(setq nano-color-subtle "#434C5E")
(setq nano-color-foreground "#ECEFF4")
;; light-theme
;; (setq nano-color-faded "#B0BEC5")
;; (setq nano-color-subtle "ECEFF1")
;; (setq nano-color-foreground "37474F")

(setq doom-modeline-height 45)
;; (remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)
;; (add-hook! '+doom-dashboard-functions (hide-mode-line-mode 1))
(setq fancy-splash-image "/home/junho/Pictures/mandu.png")
(assoc-delete-all "Open private configuration" +doom-dashboard-menu-sections)
(assoc-delete-all "Open documentation" +doom-dashboard-menu-sections)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)
(global-visual-line-mode 1)

;; doom-nano-modeline
(use-package! doom-nano-modeline
  :config
  (doom-nano-modeline-mode 1)
  (global-hide-mode-line-mode 1))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq make-backup-files nil
      auto-save-default nil)

(setq treemacs-position 'right)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
(add-hook 'LaTeX-mode-hook #'lsp-deferred)
(after! lsp-mode

  (setq lsp-enable-snippet t
        lsp-completion-enable-additional-text-edit t
        lsp-eldoc-render-all nil
        lsp-idle-delay 0.1)
  ;; texlab로 전달할 설정(JSON-RPC setConfiguration)
  (lsp-register-custom-settings
   `(("texlab.auxDirectory"           "build")
     ("texlab.logDirectory"           "build")
     ("texlab.pdfDirectory"           "build")

     ;; chktex
     ("texlab.chktex.onEdit"          t)
     ("texlab.chktex.onOpenAndSave"   t)

     ;; forward search: Zathura
     ("texlab.forwardSearch.executable" "zathura")
     ("texlab.forwardSearch.args"      ["--synctex-forward" "%l:%c:%f" "%p"])

     ;; build: Docker 스크립트 + latexmk args
     ("texlab.build.onSave"            t)
     ("texlab.build.forwardSearchAfter" t)
     ("texlab.build.executable"        "latexdockercmd.sh")
     ("texlab.build.args"
      ["latexmk" "-cd" "-f" "-interaction=batchmode" "-pdf" "-output-directory=build"]))))

(after! tex
  (setq TeX-view-program-selection '((output-pdf "Zathura")))
  (setq TeX-source-correlate-mode t
        TeX-source-correlate-start-server t))

;; (선택) Zathura에서 inverse-search 쓸 때 편한 에디터 커맨드 예시:
;;   zathura --synctex-editor-command="emacsclient --no-wait +%{line} %{input}" foo.pdf
;; 필요시 zathura.conf에 설정하거나, texlab forwardSearch만 써도 됨.

;; ── 편의: 빌드 아웃풋 디렉토리 존재 보장 ────────────────────────────
(defun my/latex-ensure-build-dir ()
  ;; "현재 TeX 프로젝트 루트에 build 디렉터리가 없으면 만든다."
  (when buffer-file-name
    (let* ((root (or (and (fboundp 'projectile-project-root)
                          (projectile-project-root))
                     (locate-dominating-file buffer-file-name ".git")
                     default-directory))
           (build (expand-file-name "build" root)))
      (unless (file-directory-p build)
        (make-directory build t)))))
(add-hook 'LaTeX-mode-hook #'my/latex-ensure-build-dir)

(after! org
  (setq org-image-align 'center)
  (plist-put org-format-latex-options :justify 'center)

  (defun org-justify-fragment-overlay (beg end image imagetype)
    "Adjust the justification of a LaTeX fragment.
The justification is set by :justify in
`org-format-latex-options'. Only equations at the beginning of a
line are justified."
    (cond
     ;; Centered justification
     ((and (eq 'center (plist-get org-format-latex-options :justify))
           (= beg (line-beginning-position)))
      (let* ((img (create-image image 'imagemagick t))
             (width (car (image-size img)))
             (offset (floor (- (/ (window-text-width) 2) (/ width 2)))))
        (overlay-put (ov-at) 'before-string (make-string offset ? ))))
     ;; Right justification
     ((and (eq 'right (plist-get org-format-latex-options :justify))
           (= beg (line-beginning-position)))
      (let* ((img (create-image image 'imagemagick t))
             (width (car (image-display-size (overlay-get (ov-at) 'display))))
             (offset (floor (- (window-text-width) width (- (line-end-position) end)))))
        (overlay-put (ov-at) 'before-string (make-string offset ? ))))))

  (defun org-latex-fragment-tooltip (beg end image imagetype)
    "Add the fragment tooltip to the overlay and set click function to toggle it."
    (overlay-put (ov-at) 'help-echo
                 (concat (buffer-substring beg end)
                         "mouse-1 to toggle."))
    (overlay-put (ov-at) 'local-map (let ((map (make-sparse-keymap)))
                                      (define-key map [mouse-1]
                                                  `(lambda ()
                                                     (interactive)
                                                     (org-remove-latex-fragment-image-overlays ,beg ,end)))
                                      map)))

  ;; advise the function to a
  (advice-add 'org--format-latex-make-overlay :after 'org-justify-fragment-overlay)
  (advice-add 'org--format-latex-make-overlay :after 'org-latex-fragment-tooltip)

  (require 'org-indent)
  (add-hook 'org-mode-hook #'org-indent-mode)
  (require 'org-element)
  (defun writer-mode--num-format (numbering)
    "Alternative numbering format for org-num.

First level: 1 | xxx
Second level: 1.1 — xxx
Third level: 1.1.1 - xxx
etc.
"""
    (if (= (length numbering) 1)
        (propertize (concat (mapconcat
                             #'number-to-string
                             numbering ".") " | " )
                    'face `(:family "Roboto Condensed"
                            :height 250
                            :foreground ,nano-color-faded))
      (propertize (concat (mapconcat
                           #'number-to-string
                           numbering ".") " — " )
                  'face `(:family "Roboto Condensed"
                          :foreground ,nano-color-faded))))

  ;; Specific face for headline stars
  (font-lock-add-keywords 'org-mode
                          '(("^*+ " 0 `(:family "Roboto Mono"
                                        :height 140
                                        :foreground ,nano-color-faded) prepend)
                            ) 'append)

  (defun writer-mode--compute-prefixes ()
    "Compute prefix strings for regular text and headlines."

    (setq org-indent--heading-line-prefixes
          (make-vector org-indent--deepest-level nil))
    (setq org-indent--inlinetask-line-prefixes
          (make-vector org-indent--deepest-level nil))
    (setq org-indent--text-line-prefixes
          (make-vector org-indent--deepest-level nil))

    (let* ((min-indent 5)
           (levels (org-element-map (org-element-parse-buffer) 'headline
                     (lambda (item) (org-element-property :level item ))))
           (max-level (if levels (apply #'max levels) 0))
           (indent (max (+ 1 max-level) min-indent)))

      (dotimes (n org-indent--deepest-level)
        (aset org-indent--heading-line-prefixes n
              (make-string
               (min indent (max 0 (- indent 1 n))) ?\s))
        (aset org-indent--inlinetask-line-prefixes n
              (make-string indent ?\s))
        (aset org-indent--text-line-prefixes n
              (make-string indent ?\s)))))

  (add-hook 'org-mode-hook (lambda () (display-line-numbers-mode -1)))
  (add-hook 'org-mode-hook (lambda () (vi-tilde-fringe-mode -1)))
  (setq org-directory "~/org/"
        org-agenda-files '("~/org/" "~/org/daily/" "~/org/roam/notes/" "~/org/roam/projects/")
        org-roam-directory (expand-file-name "roam" org-directory)
        org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory)
        org-roam-completion-everywhere t)
  (setq org-todo-keywords '((sequence "TODO(t)" "DOING(g)" "NEXT(n)" "|" "DONE(d)")))
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0)

  (add-hook 'org-mode-hook 'variable-pitch-mode)
  (plist-put org-format-latex-options :scale 2)

  (face-remap-add-relative 'org-level-1
                           :overline nano-color-subtle
                           :family "Roboto" :height 180)
  (face-remap-add-relative 'org-level-2
                           :family "Roboto" :height 160)
  (face-remap-add-relative 'org-level-3
                           :family "Roboto" :height 150)
  (face-remap-add-relative 'org-document-info
                           :inherit 'nano-face-faded)
  (face-remap-add-relative 'org-document-title
                           :foreground nano-color-foreground
                           :family "Roboto Slab"
                           :height 200
                           :weight 'medium)

  (setq-local org-hidden-keywords '(title author date startup))

  (setq header-line-format nil)
  (setq fill-column 72)
  (setq-default line-spacing 1)


  (custom-set-faces!
    '(org-block :inherit nil :family "Victor Mono")
    '(org-block-begin-line :inherit nil :family "Victor Mono")
    '(org-block-end-line :inherit nil :family "Victor Mono")
    '(org-table :inherit nil :family "Victor Mono")
    '(org-modern-checkbox :inherit (org-checkbox fixed-pitch)
      :foreground unspecified
      :background unspecified)
    '(org-checkbox :inherit (fixed-pitch) :foreground unspecified
      :background unspecified)
    '(org-code :inherit nil :family "Viictor Mono")
    '(org-verbatim :inherit nil :family "Victor Mono")
    '(org-formula :inherit nil :family "Victor Mono")
    )

  (setq org-src-fontify-natively t
        org-src-preserve-indentation t
        org-edit-src-content-indentation 0)
  ;; inline image 자동 표시
  (setq org-startup-with-inline-images t
        org-image-actual-width '(300))
  ;;org babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages '((C . t) (cpp . t) (python . t)))
  (setq org-startup-folded nil)
  (setq org-level-color-stars-only nil)
  (setq org-hide-leading-stars nil)
  (setq org-hide-emphasis-markers t)
  (advice-add 'org-indent--compute-prefixes :override
              #'writer-mode--compute-prefixes)

  (add-hook 'org-mode-hook #'org-modern-mode)
  (with-eval-after-load 'org-modern
    (customize-set-variable 'org-modern-star nil)
    (when (boundp 'org-modern-hide-stars)
      (customize-set-variable 'org-modern-hide-stars nil))
    )

  (add-hook 'org-mode-hook #'org-num-mode)
  (with-eval-after-load 'org-num
    (setq org-num-skip-unnumbered t)
    (setq org-num-skip-footnotes t)
    (setq org-num-max-level 2)
    (setq org-num-face nil)
    (setq org-num-format-function 'writer-mode--num-format)
    )

  (define-key org-mode-map (kbd "C-c >") 'org-timestamp-inactive)
  )
(add-hook 'org-mode-hook 'olivetti-mode)

(after! org
  (define-key org-mode-map (kbd "C-c h") 'org-habit-stats-view-habit-at-point)
  )

(after! org-agenda
  (define-key org-agenda-mode-map (kbd "C-c h") 'org-habit-stats-view-habit-at-point-agenda)
  (setq org-agenda-custom-commands
        '(("w" "Weekly Agenda"
           ((agenda "" ((org-agenda-span 7)
                        (org-deadline-warning-days 7)))
            (todo ""
                  ((org-agenda-overriding-header "TODOs"))))))
        org-agenda-block-separator " ")
  )

(use-package! org-alert
  :custom (alert-default-style 'libnotify)
  :config
  (setq org-alert-interval 300
        org-alert-notify-cutoff 15
        org-alert-notify-after-event-cutoff 5
        org-alert-notification-title "Org Alert"
        org-alert-time-match-string "\\(?:SCHEDULED\\|DEADLINE\\):.*?<.*?\\([0-9]\\{2\\}:[0-9]\\{2\\}\\).*>")
  (org-alert-enable))

(use-package! org-ql
  :after org
  :config (require 'org-ql-view))

(setq org-roam-database-connector 'sqlite-builtin)

(map! :leader
      :desc "org-roam find node"    "n r f" #'org-roam-node-find
      :desc "org-roam insert node"  "n r i" #'org-roam-node-insert
      :desc "org-roam buffer"       "n r l" #'org-roam-buffer-toggle
      :desc "org-roam capture"      "n r c" #'org-roam-capture
      :desc "org-roam graph"        "n r g" #'org-roam-graph
      :desc "dailies today"         "n r d" #'org-roam-dailies-capture-today
      :desc "org-roam open ui"      "n r u" #'org-roam-ui-open
      :desc "org-download"         "n d"   nil
      :desc "org-download clipboard""n d c" #'org-download-clipboard)


;; 캡처 템플릿(기본/문헌/프로젝트)
(after! org-roam
  (setq org-roam-capture-templates
        '(("n" "note" plain
           "%?"
           :if-new (file+head "notes/${slug}.org"
                              "#+title: ${title}\n#+date: %<%Y-%m-%d>\n#+filetags: :note:\n")
           :unnarrowed t)
          ("l" "literature" plain
           "* Reference\n- Source: %?\n* Notes\n"
           :if-new (file+head "literature/${slug}.org"
                              "#+title: ${title}\n#+filetags: :lit:\n")
           :unnarrowed t)
          ("p" "paper" plain
           "* ${title}\n:PROPERTIES:\n:TYPE: paper\n:AUTHOR: %^{author}\n:YEAR: %^{year}\n:VENUE: %^{venue}\n:STATUS: %^{status|TODO|DOING|DONE}\n:URL: %^{url}\n:END:\n\n%?"
           :if-new (file+head "literature/${slug}.org"
                              "#+title: ${title}\n#+filetags: :paper:\n")
           :unnarrowed t)
          ("j" "project" plain
           "* ${title}\n:PROPERTIES:\n:TYPE: project\n:STATUS: %^{status|TODO|DOING|DONE}\n:END:\n\n%?"
           :if-new (file+head "projects/${slug}.org"
                              "#+title: ${title}\n#+filetags: :project:\n")
           :unnarrowed t)))
  (setq org-roam-dailies-directory "~/org/daily/"
        org-roam-dailies-capture-templates
        '(("d" "default" entry
           "* %?\n%U"
           :if-new (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n")))))

;; org-roam-ui (선택)
(use-package! org-roam-ui
  :after org-roam
  :hook (org-roam . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))

(require 'org-download)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

;; org-modern: 체크박스, 표, 코드블록, 헤더 꾸미기
(use-package! org-modern
  :hook ((org-agenda-finalize . org-modern-agenda))
  :config
  (setq org-modern-block-fringe 8
        org-modern-checkbox '((?X . "✅") (?- . "⬛") (?\s . "⬜"))
        org-modern-list '((?* . "•") (?+ . "•") (?- . "•"))
        org-modern-block-fringe t
        org-modern-block-name t
        org-modern-table nil
        org-modern-table-horizontal ?_
        org-modern-table-vertical 3
        org-modern-todo t)
  )


;; valign: 표 열 정렬 (GUI only)
(when (display-graphic-p)
  (use-package! valign
    :hook (org-mode . valign-mode))
  )

;; org-appear: 링크/특수문자 편집 시 자동 표시
(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autoentities t
        org-appear-autokeywords t
        org-appear-autolinks t))


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
