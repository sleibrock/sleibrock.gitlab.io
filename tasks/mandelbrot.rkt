(load-template "page.rkt")

(current-title "Mandelbrot")
(current-description "?")
(current-keywords "?")
(current-stylesheets '("../static/css/style.css"))
(current-scripts '("../static/js/complex.js"
                       "../static/js/mandelbrot.js"))

(current-contents
 `((p "This is a mandelbrot generator")
   (canvas ([id "mandelbro"]
            [width "640"]
            [height "480"])
           (p "Browser does not support HTML5/canvas"))))

(render-to "demos/mandelbrot.html")
