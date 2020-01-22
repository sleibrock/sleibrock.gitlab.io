#lang racket/base

(require
 (only-in "parameters.rkt"
          current-title
          current-description
          current-date
          current-keywords
          current-stylesheets
          current-scripts
          current-postscripts
          current-filetarget
          current-contents
          current-pagechunks
          current-template
          current-basepath
          )
 )

(provide (struct-out page)
         get-pagefiles
         files->pages
         page->file
         )

(struct page (title desc datestr filedst contents))



(define (get-pagefiles path-of-pages)
  (directory-list #:build? #t
                  (path->complete-path path-of-pages)))


(define (files->pages listof-pages evalf)
  (map
   (λ (page-path)
     (parameterize
         ([current-title         ""]
          [current-description   ""]
          [current-date          ""]
          [current-keywords      ""]
          [current-contents     '()]
          [current-stylesheets  '("../static/css/style.css")]
          [current-scripts      '()]
          [current-postscripts  '()]
          [current-filetarget    ""])
       (evalf page-path)
       (page (current-title)
             (current-description)
             (current-date)
             (current-filetarget)
             ((current-template)))))
       listof-pages))



(define (page->file chunk writerf base-path)
  (writerf (page-contents chunk)
           (path->string
            (build-path base-path (page-filedst chunk)))))

; end
