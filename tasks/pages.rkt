(load-template "page.rkt")


(for-each
 (λ (chunk)
   (page->file chunk xexpr->file
               (build-path (build-directory) "pages")))
 (current-pagechunks))


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
                                     (page-filedst page-chunk))))
              (br)
              ,(page-desc page-chunk)
              (br)
              (sub "Posted " ,(page-datestr page-chunk)))))
   (current-pagechunks))))

(render-to "pages.html")
