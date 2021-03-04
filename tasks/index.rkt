(load-template "page.rkt")

(current-title "Steven's Site")
(current-description "Steven Leibrock's Personal Website")
(current-keywords "Steven Leibrock personal website")

(current-stylesheets '("static/css/style.css"))

(current-contents
 `((p "Welcome to the personal homepage of Steven Leibrock")
   (p "This website itself is still heavily under development as I'm writing my own website publishing system in "
      ,(link-to "Racket" "https://racket-lang.org/")
      " so it takes time to create new features.")


   (h3 "Latest post")
   ,(let ([last-post (car (current-pagechunks))])
      `(p ,(link-to (page-title last-post)
                    (path->string (build-path "pages"
                                              (page-filedst last-post))))
          (br)
          ,(page-desc last-post)
          (br)
          ))

   (hr)
   (h2 "Code")
   (p "I upload all my code to two webistes:")
   ,(unordered-list (list (link-to "GitHub" "https://github.com/sleibrock")
                          (link-to "GitLab" "https://gitlab.com/sleibrock")))))

(render-to "index.html")
