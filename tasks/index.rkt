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
   (p "I've been working more on NixOS things than I have been code-related. Sadly it means I have been lacking in major feature changes to this website. The good news is, after all my NixOS experiments, I can go back to doing some more Racket for fun, and maybe cleaning some things up as well.")
   (p "I survived the holidays and the New Years, so I'm happy to get back to doing some more coding in either Racket or Haskell going forward. As well as read some more books and go back to the gym some more. There's too much to do, so let's see what happens.")
   (sub "Edited 2020-01-11")
   
   (hr)
   (h2 "Code")
   (p "I upload all my code to two webistes:")
   ,(unordered-list (list (link-to "GitHub" "https://github.com/sleibrock")
                          (link-to "GitLab" "https://gitlab.com/sleibrock")))))

(render-to "public/index.html") 
