(current-template
 `(html
   ,(*header*)
   
   (body
    (div ([id "container"])
         ,(*nav*)

         (div ([id "content"])
              (article
               (section
                (p "Welcome to the personal homepage of Steven Leibrock")
                (p "For the most part there is nothing really stored here... For now.")
                
                (h2 "Code")
                (p "I upload all my code to two sources:")
                ,(unordered-list `(,(link-to "GitHub" "https://github.com/sleibrock")
                                   ,(link-to "GitLab" "https://gitlab.com/sleibrock")))
                
                (h2 "Computer Builds")
                (p ,(link-to "Click here" "builds.html") " to see all of my computer builds")
                )))

         ,(*footer*)

         ))))
         

(xexpr->file (current-template) "public/index.html") 
