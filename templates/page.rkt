(current-template
 (λ ()
   `(html
     ,(cons 'head
            (append
             (map css (current-stylesheets))
             `((title              ,(current-title))
               (meta ([author      ,(*fullname*)]))
               (meta ([keywords    ,(current-keywords)]))
               (meta ([description ,(current-description)]))
               (meta ([charset     "utf-8"]))
               (meta ([viewport    "width=device-width, initial-scale=1.0"])))))
     
     (body
      (div ([id "container"])
           (div ([id "navbar"])
                (span ([id "navtitle"])
                      ,(root-link "Steven's Site" "index.html"))
                (span ([class "navlink"])
                      ,(root-link "About" "about.html"))
                (span ([class "navlink"])
                      ,(root-link "Writings" "pages.html")))
           
           (div ([id "content"])
                (article
                 ,(cons 'section (current-contents))))
           
           (div ([id "footer"])
                (span ([id "footleft"])
                 ,(*fullname*)
                 " 2019 >>= "
                 ,(root-link "home" "index.html"))
                (span ([id "footright"])
                      "version "
                      ,(let ([git-sha (current-git-sha)])
                         (link-to (substring git-sha 0 7)
                                  (string-append
                                   "https://github.com/sleibrock/sleibrock.gitlab.io/commit/" git-sha))))))))))
