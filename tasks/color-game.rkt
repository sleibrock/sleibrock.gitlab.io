(load-template "page.rkt")

(current-title "Color Game")
(current-description "")
(current-keywords "")
(current-postscripts '("../static/js/lib.js"
                       "../static/js/color_game.js"))
(current-stylesheets '("../static/css/style.css"))

(define color-mapping
  '((1 . "red")
    (2 . "green")
    (3 . "blue")
    (4 . "purple")
    (5 . "cyan")
    (6 . "yellow")))

(current-contents
 `((p "This is the color game")
   (canvas ([id "color_game"])
           (p "This browser does not support Canvas/HTML5"))
   (div ([style "margin:0 auto;"])
        (input ([type "button"] [value "Reset"]
                [onclick "shuffle_map()"]))
        ,@(map (λ (p)
                 `(input ([type "button"]
                          [onclick ,(format "on_click(~a)" (car p))]
                          [value ,(format "~a" (cdr p))])))
               color-mapping))))

(render-to "games/color-game.html")



;; Now let's do some level editing...

;end
