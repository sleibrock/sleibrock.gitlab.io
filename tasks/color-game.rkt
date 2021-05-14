(load-template "page.rkt")

(current-title "Color Game")
(current-description "")
(current-keywords "")
(current-postscripts '("../static/js/lib.js"
                       "../static/js/color_levels.js"
                       "../static/js/color_game.js"))
(current-stylesheets '("../static/css/style.css"))

(define color-mapping
  '((1 . "red")
    (2 . "green")
    (3 . "blue")
    (4 . "purple")
    (5 . "cyan")
    (6 . "yellow")
    (7 . "brown")
    (8 . "grey")
    (9 . "white")))

(define difficulties
  '((5 . "I'm too young to die")
    (6 . "Hey, not too rough")
    (7 . "Hurt me plenty")
    (8 . "Ultra-Violence")
    (9 . "Nightmare")))


(define maps
  '(((0 . "Pi")
    . ("1111111111"
       "1111111111"
       "1100000001"
       "1110111011"
       "1110111011"
       "1110111011"
       "1110111011"
       "1110111011"
       "1111111111"
       "1111111111"))
    ((1 . "Sigma")
     . ("111111111111111"
        "111111111111111"
        "110000000000011"
        "110000000000011"
        "110011111111111"
        "111001111111111"
        "111100111111111"
        "111110011111111"
        "111100111111111"
        "111001111111111"
        "110011111111111"
        "110000000000011"
        "110000000000011"
        "111111111111111"
        "111111111111111"))
    ((2 . "Dota")
    . ("11111111111111111111"
       "11111111111111100001"
       "11000100000001110001"
       "11001111111111111001"
       "11011111111111111101"
       "11111111111111001111"
       "11011111111110011011"
       "11011111111100111011"
       "11011111111001111011"
       "11011111110011111011"
       "11011111100111111011"
       "11011111001111111011"
       "11011110011111111011"
       "11011100111111111011"
       "11111001111111111111"
       "10111011111111111011"
       "10011111111111110011"
       "10001100000001100011"
       "10000111111111111111"
       "11111111111111111111"
       ))


    ))
                  

(current-contents
 `((div
    (span ([id "score"]) "Turns: 0")
    (input ([type "button"]
            [value "Reset"]
            [style "float:right"]
            [onclick "shuffle_current_map()"]))
    (select
     ([id "difficulty_selector"]
      [style "float:right"])
     ,@(map
        (λ (datum)
          `(option
            ([value ,(format "~a" (car datum))])
            ,(cdr datum)))
        difficulties))
    (select
     ([id "level_selector"]
      [style "float:right"])
     (option ([value "777"]) "Random")
     ,@(map
        (λ (datum)
          `(option
            ([value ,(format "~a" (car (car datum)))])
            ,(cdr (car datum))))
        maps)))
          
   (div ([id "game_container"] [style "margin:0 auto;width:100%"])
        (canvas
         ([id "color_game"])
         (p "This browser does not support Canvas/HTML5")))
   (div
    ([style "margin:0 auto;width:100%;"])
    ,@(map (λ (p)
             `(input
               ([type "button"]
                [id ,(format "button~a" (car p))]
                [style ,(format "padding:5px;margin:2px;background-color: ~a;font-size: 2.0em;" (cdr p))]
                [onclick ,(format "on_click(~a)" (car p))]
                [value ,(format "~a" (cdr p))])))
           color-mapping))

   (p "This is the color game. Rules are as follows:")
   (ul
    (li "The game is a grid of colored squares. The goal is to get all squares to be the same color (in the case of 'walls', these do not need to be filled).")
    (li "The objective is to beat the game in as few turns as possible.")
    (li "There are varying degrees of difficulty. The starting number of colors is four. The number of colors can go up to 7.")
    (li "You will always start from the top-left corner. No pre-made level will have walls in the top left corner. Randomly generated levels will not generate walls, unless it is on the highest difficulty of Nightmare."))))

(render-to "games/color-game.html")



;; Now let's do some level publishing...


(call-with-output-file #:exists 'replace
  "public/static/js/color_levels.js"
  (λ (out)
    (parameterize ([current-output-port out])
      (displayln "var LEVELS = [")
      (for-each
       (λ (datum)
         (displayln "[")
         (for-each
          (λ (line)
            (displayln
             (format
              "[~a],"
              (string-join
               (map (λ (c) (format "~a" c))
                    (string->list line))
               ","))))
          (cdr datum))
         (displayln "],"))
       maps)
      (displayln "];"))))

;end
