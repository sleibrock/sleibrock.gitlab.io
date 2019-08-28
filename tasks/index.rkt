(current-template
 `(html
   (head
    (title "Steven Leibrock's Website")
    (link ([rel "stylesheet"] [href "static/css/style.css"]))
    (meta ([charset "utf-8"]))
    (meta ([viewport "width=device-width, initial-scale=1.0"]))
    (meta ([keywords "Steven Leibrock personal website"]))
    (meta ([author "Steven Leibrock"]))
    (meta ([description "Steven Leibrock's personal website"])))
   
   (body
    (article
      (h1 "Steven's Site")
      (section
       (p "Welcome to the personal homepage of Steven Leibrock")
       (p "For the most part there is nothing really stored here... For now.")
       
       (h2 "Code")
       (p "I upload all my code to two sources:")
       ,(unordered-list `(,(link-to "GitHub" "https://github.com/sleibrock")
                          ,(link-to "GitLab" "https://gitlab.com/sleibrock")))

       (h2 "Computer Builds")
       (p ,(link-to "Click here" "builds.html") " to see all of my computer builds")
       ))
    
    (hr)
    (footer
     (nav
      (p "Steven Leibrock 2019"))))))

(xexpr->file (current-template) "public/index.html") 
