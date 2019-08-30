(current-template
 (λ (content)
   `(html
     ,(*header*)
     
     (body
      (div ([id "container"])
           ,(*nav*)
           
           (div ([id "content"])
                (article
                 (cons 'section ,(content))))
           
           ,(*footer*)
           
           )))))
 
