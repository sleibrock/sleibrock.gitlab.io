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

   (h3 "Latest updates")
   (p "Recently I had a problem with my Racket program where fullpaths weren't properly expanded/set like my 'About' button. I've added some new code to allow me to set root links and set a 'production' mode flag when I publish my website through GitLab.")
   (p "I wish everyone reading this site a Happy Holidays!")
   (sub "Edited 2019-12-11")
   
   (hr)
   (h2 "Code")
   (p "I upload all my code to two webistes:")
   ,(unordered-list (list (link-to "GitHub" "https://github.com/sleibrock")
                          (link-to "GitLab" "https://gitlab.com/sleibrock")))))

(render-to "public/index.html") 
