(current-template
 (λ ()
   `(html ([lang "en"] [class "no-js"])
     ,(cons 'head
            (append
             (map css (current-stylesheets))
             `((title              ,(current-title))
               (meta ([author      ,(*fullname*)]))
               (meta ([keywords    ,(current-keywords)]))
               (meta ([description ,(current-description)]))
               (meta ([charset     "UTF-8"]))
               (meta ([viewport    "width=device-width, initial-scale=1.0"]))
               (link ([rel "apple-touch-icon"]
                      [sizes "180x180"]
                      [href "/apple-touch-icon.png"]))
               (link ([rel "icon"]
                      [type "image/png"]
                      [sizes "32x32"]
                      [href "/favicon-32x32.png"]))
               (link ([rel "icon"]
                      [type "image/png"]
                      [sizes "16x16"]
                      [href "/favicon-16x16.png"]))
               (link ([rel "manifest"] [href "/site.webmanifest"]))
               (link ([rel "mask-icon"]
                      [href "/safari-pinned-tab.svg"]
                      [color "#5bbad5"]))
               (meta ([name "msapplication-TileColor"]
                      [content "#da532c"]))
               (meta ([name "theme-color"]
                      [content "#000000"])))))
     
     (body
      (div ([id "container"])
           (div ([id "navbar"])
                (span ([id "navtitle"])
                      ,(root-link "Steven's Site" "index.html"))
                (span ([class "navlink"])
                      ,(root-link "About" "about.html")))
           
           (div ([id "content"])
                (article
                 ,(cons 'section (current-contents))))
           
           (div ([id "footer"])
                (span ([id "footleft"])
                 ,(*fullname*)
                 " "
                 ,(format "~a" (date-year (seconds->date (current-seconds))))
                 " >>= "
                 ,(root-link "home" "index.html"))
                (span ([id "footright"])
                      "version "
                      ,(let ([git-sha (current-git-sha)])
                         (link-to (substring git-sha 0 7)
                                  (format
                                   "https://github.com/sleibrock/sleibrock.gitlab.io/commit/~a" git-sha))))))))))
