(load-template "page.rkt")

(current-title "Steven's Site")
(current-description "Steven Leibrock's Personal Website")
(current-keywords "Steven Leibrock personal website")

(current-stylesheets '("static/css/style.css"))

(current-contents
 `((p "Welcome to the personal homepage of Steven Leibrock")
   (p "This website is written entirely within "
      ,(link-to "Racket" "https://racket-lang.org/")
      ", as well as some bits of JavaScript. It is compiled within GitLab's Continuous Integration system using Racket and compiled into static HTML. Any apps and demos I write are hosted here as well.")
   (hr)
   (h2 "Code")
   (p "I upload all my code to two webistes:")
   ,(unordered-list (list (link-to "GitHub" "https://github.com/sleibrock")
                          (link-to "GitLab" "https://gitlab.com/sleibrock")))))

(render-to "index.html")
