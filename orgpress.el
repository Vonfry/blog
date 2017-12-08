(load-file "config.el")
(require 'color-theme)
(color-theme-initialize)
(color-theme-gtk-ide)
(require 'clojure-mode)
(require 'scala-mode)
(require 'haskell)
(require 'ob-sh)
(require 'ob-ruby)

(clojure-font-lock-setup)
(require 'org)
(require 'org-blog)
(require 'htmlize)
(setq make-backup-files nil)
(setq debug-on-error t)
(setq blog-path (expand-file-name "org"))
(setq assets-path (expand-file-name "assets"))
(setq org-html-validation-link nil)
(setq org-confirm-babel-evaluate nil)

(require 'ox-deck)
(setq slide-path (expand-file-name "slides"))
(setq org-deck-base-url "https://blog.oyanglul.us/deck.js")
(setq org-deck-theme "web-2.0.css")
(setq org-deck-transition "horizontal-slide.css")
(setq org-deck-postamble "<p>%t - %a</p>")
(setq org-export-babel-evaluate nil)
(custom-set-variables
  '(org-publish-timestamp-directory
     (convert-standard-filename "public/.org-timestamps/")))
(setq postamble (with-temp-buffer
                  (insert-file-contents "html/postamble.html")
                  (buffer-string)))
(setq preamble (with-temp-buffer
                  (insert-file-contents "html/preamble.html")
                  (buffer-string)))
(setq header (with-temp-buffer
                  (insert-file-contents "html/header.html")
                  (buffer-string)))
(defun set-org-publish-project-alist ()
  "Set publishing projects for Orgweb and Worg."
  (interactive)
  (setq org-publish-project-alist
    `(("blog-notes"
       ;; Directory for source files in org format
        :base-directory ,blog-path
        :base-extension "org"
        :html-doctype "html5"
        :html-head ,header
        :html-html5-fancy t
        :html-preamble ,preamble
        :html-postamble ,postamble
        ;; HTML directory
        :publishing-directory "public"
        :publishing-function org-html-publish-to-tufte-html
        :recursive t
        :headline-levels 4
        :with-sub-superscript nil
        :section-numbers nil
        :auto-preamble nil
        :auto-sitemap t
        :sitemap-filename "index.org"
        :exclude "\!.*\.org"
        :sitemap-function org-blog-export
        :blog-entry-format ,config-entry-format
        :blog-export-dates t
        :sitemap-date-format ,config-date-format
        :blog-title ,config-blog-title
        :makeindex t
        :html-head-include-default-style nil
        )

      ("slides"
         :base-directory ,slide-path
         :base-extension "org"
         :publishing-directory "public/slides"
         :recursive t
         :publishing-function org-deck-publish-to-html
       )
       ;; where static files (images, pdfs) are stored
       ("blog-static"
         :base-directory ,blog-path
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|svg\\|pdf\\|mp3\\|woff2\\|woff"
         :publishing-directory "public"
         :recursive t
         :publishing-function org-publish-attachment
         )
       ("assets"
         :base-directory ,assets-path
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|svg\\|pdf\\|mp3\\|woff2\\|woff\\|html\\|md\\|ico"
         :publishing-directory "public"
         :recursive t
         :publishing-function org-publish-attachment
         )
       ("rss"
         :base-directory ,blog-path
         :base-extension "org"
         :html-link-home ,config-base-url
         :html-link-use-abs-url t
         :rss-extension "xml"
         :publishing-directory "public"
         :publishing-function (org-rss-publish-to-rss)
         :section-numbers nil
         :exclude ".*"            ;; To exclude all files...
         :include ("index.org")   ;; ... except index.org.
         :table-of-contents nil)
       ("blog" :components ("blog-notes" "slides" "blog-static" "rss"))
       )))
(set-org-publish-project-alist)
