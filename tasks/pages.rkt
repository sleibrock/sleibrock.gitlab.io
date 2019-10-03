(load-template "page.rkt")


; Collect 
(define/contract page-files list?
  (directory-list #:build? #t (path->complete-path "pages")))

;; Create an easy-to-pass tuple
(struct page (title desc date file))

;; Gather page data
(define/contract page-data
  (listof page?)
  (map
   (λ (page-task-path)
     (parameterize
         ([current-title       ""]
          [current-description ""]
          [current-date        ""]
          [current-keywords    ""]
          [current-stylesheets '("../static/css/style.css")]
          [current-scripts     '()]
          [current-postscripts '()]
          [current-filetarget  ""])
       (run-task page-task-path)
       (render-to
        (path->string
         (build-path build-directory "pages" (current-filetarget))))
       (page (current-title)
             (current-description)
             (current-date)
             (current-filetarget))))
   page-files))


; Do this afterwards
(current-title       "Pages | Steven's Site")
(current-description "Steven's writing pages")
(current-keywords    "Steven Leibrock writings")
(current-stylesheets '("static/css/style.css"))
(current-contents
 (cons
  '(p "Here is where you can browse all of my writings.")
  (map
   (λ (page-chunk)
     `(div ([class "page-block"])
           (p ,(link-to (page-title page-chunk)
                        (path->string
                         (build-path "pages"
                                     (page-file page-chunk))))
              (br)
              ,(page-desc page-chunk)
              (br)
              (sub "Posted ",(page-date page-chunk)))))
              
   page-data)))

(render-to "public/pages.html")
