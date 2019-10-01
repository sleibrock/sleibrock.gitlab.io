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

   (h2 "Code")
   (p "I upload all my code to two webistes:")
   ,(unordered-list (list (link-to "GitHub" "https://github.com/sleibrock")
                          (link-to "GitLab" "https://gitlab.com/sleibrock")))))

(render-to "public/index.html") 
