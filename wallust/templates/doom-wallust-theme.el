;;; doom-wallust-theme.el --- dark variant of Wallust -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Added: March 8, 2018 (c503ebdacac1)
;; Author: fuxialexander <https://github.com/fuxialexander>
;; Maintainer:
;; Source: https://www.wallusttheme.com
;;
;;; Commentary:
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup doom-wallust-theme nil
  "Options for the `doom-wallust' theme."
  :group 'doom-themes)

(defcustom doom-wallust-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-wallust-theme
  :type 'boolean)

(defcustom doom-wallust-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-wallust-theme
  :type 'boolean)

(defcustom doom-wallust-comment-bg doom-wallust-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-wallust-theme
  :type 'boolean)

(defcustom doom-wallust-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-wallust-theme
  :type '(choice integer boolean))

(eval-and-compile
  (defcustom doom-wallust-region-highlight t
    "Determines the selection highlight style. Can be 'frost, 'snowstorm or t
(default)."
    :group 'doom-wallust-theme
    :type 'symbol))


;;
;;; Theme definition

(def-doom-theme doom-wallust
    "A dark theme inspired by Wallust."
  :family 'doom-wallust
  :background-mode 'dark

  ;; name        default   256       16
  ((bg         '("{{background}}" nil       nil            ))
   (bg-alt     '("{{color0}}" nil       nil            ))
   (base0      '("{{color8}}" "{{color8}}"   "black"        ))
   (base1      '("{{color0}}" "{{color0}}" "brightblack"  ))
   (base2      '("{{color0}}" "{{color0}}" "brightblack"  ))
   (base3      '("{{color8}}" "{{color8}}" "brightblack"  ))
   (base4      '("{{color8}}" "{{color8}}" "brightblack"  ))
   (base5      '("{{color8}}" "{{color8}}" "brightblack"  ))
   (base6      '("{{color7}}" "{{color7}}" "brightblack"  ))
   (base7      '("{{color7}}" "{{color7}}" "brightblack"  ))
   (base8      '("{{color15}}" "{{color15}}" "white"        ))
   (fg         '("{{foreground}}" "{{foreground}}" "white"        ))
   (fg-alt     '("{{color15}}" "{{color15}}" "brightwhite"  ))
   (grey       base4)
   (red        '("{{color1}}" "{{color1}}" "red"          ))
   (orange     '("{{color9}}" "{{color9}}" "brightred"    ))
   (green      '("{{color2}}" "{{color2}}" "green"        ))
   (teal       '("{{color6}}" "{{color6}}" "brightgreen"  ))
   (yellow     '("{{color3}}" "{{color3}}" "yellow"       ))
   (blue       '("{{color4}}" "{{color4}}" "brightblue"   ))
   (dark-blue  '("{{color12}}" "{{color12}}" "blue"         ))
   (magenta    '("{{color5}}" "{{color5}}" "magenta"      ))
   (violet     '("{{color13}}" "{{color13}}" "brightmagenta"))
   (cyan       '("{{color14}}" "{{color14}}" "brightcyan"   ))
   (dark-cyan  '("{{color6}}" "{{color6}}" "cyan"         ))

   ;; face categories -- required for all themes
   (highlight      blue)
   (vertical-bar   (doom-darken base1 0.2))
   (selection      dark-blue)
   (builtin        blue)
   (comments       (if doom-wallust-brighter-comments dark-cyan (doom-lighten base5 0.2)))
   (doc-comments   (doom-lighten (if doom-wallust-brighter-comments dark-cyan base5) 0.25))
   (constants      blue)
   (functions      cyan)
   (keywords       blue)
   (methods        cyan)
   (operators      blue)
   (type           teal)
   (strings        green)
   (variables      base7)
   (numbers        magenta)
   (region         (pcase doom-wallust-region-highlight
                     (`frost teal)
                     (`snowstorm base7)
                     (_ base4)))
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg) "black" "black"))
   (-modeline-bright doom-wallust-brighter-modeline)
   (-modeline-pad
    (when doom-wallust-padded-modeline
      (if (integerp doom-wallust-padded-modeline) doom-wallust-padded-modeline 4)))

   (region-fg
    (when (memq doom-wallust-region-highlight '(frost snowstorm))
      base0))

   (modeline-fg     'unspecified)
   (modeline-fg-alt base6)

   (modeline-bg
    (if -modeline-bright
        (doom-blend bg base5 0.2)
      `(,(doom-darken (car bg) 0.1) ,@(cdr base2))))
   (modeline-bg-l
    (if -modeline-bright
        (doom-blend bg base5 0.2)
      base1))
   (modeline-bg-inactive   `(,(doom-darken (car bg) 0.1)   ,@(cdr base2)))
   (modeline-bg-inactive-l `(,(doom-darken (car bg) 0.025) ,@(cdr base2))))


  ;;;; Base theme face overrides
  ((fringe :foreground teal)
   ((line-number &override) :foreground (doom-lighten 'base5 0.2))
   ((line-number-current-line &override) :foreground base7)
   ((font-lock-comment-face &override)
    :background (if doom-wallust-comment-bg (doom-lighten bg 0.05) 'unspecified))
   ((tab-line &override) :background modeline-bg :foreground blue)
   ((tab-line-tab-inactive &override) :foreground dark-blue)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if -modeline-bright base8 highlight))
   ((region &override) :foreground (or region-fg 'unspecified))

   (hl-line :background (doom-lighten base5 0.1))

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)
   ;;;; doom-modeline
   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))
   (doom-modeline-project-root-dir :foreground base6)
   ;;;; elscreen
   (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")
   ;;;; highlight-symbol
   (highlight-symbol-face :background (doom-lighten base4 0.1) :distant-foreground fg-alt)
   ;;;; highlight-thing
   (highlight-thing :background (doom-lighten base4 0.1) :distant-foreground fg-alt)
   ;;;; ivy
   ((ivy-current-match &override) :foreground (or region-fg 'unspecified) :weight 'semi-bold)
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-lighten base3 0.05))
   ;;;; mic-paren
   ((paren-face-match &override) :foreground bg :background teal :weight 'ultra-bold)
   ((paren-face-mismatch &override) :foreground base7 :background red :weight 'ultra-bold)
   ;;;; org <built-in>
   (org-hide :foreground hidden)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))
   ;;;; vimish-fold
   ((vimish-fold-overlay &override) :inherit 'font-lock-comment-face :background base3 :weight 'light)
   ((vimish-fold-fringe &override)  :foreground teal))

  ;;;; Base theme variable overrides-
  ())

;;; doom-wallust-theme.el ends here
