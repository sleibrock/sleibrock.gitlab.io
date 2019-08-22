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
     (section
      (h1 "Steven's Site")
      (p "Welcome to the personal homepage of Steven Leibrock")
      (p "For the most part there is nothing really stored here... For now.")
      
      (h2 "Other Details")
      (p "Honestly it's still a work in progress currently.")))

    (hr)
    (footer
     (nav
      (p "Steven Leibrock 2019"))))))

(xexpr->file (current-template) "public/index.html") 
