(load-template "page.rkt")

(current-title "About Steven | Steven's Site")
(current-description "Description of Steven Leibrock")
(current-keywords "Steven Leibrock about page")

(current-stylesheets '("static/css/style.css"))


(current-contents
 `((p "Hi there, my name is Steven Leibrock, and I am a generic computer nerd of many degrees.")

   (p "I started experimenting on computers as early as the age of 10, growing up addicted to the Super Nintendo playing Super Mario World with my grandfather. I started programming when I was 14, starting with the rugged language PHP. Later on I moved into Python and explored all sorts of new fields with it such as game development, mathematics, web development and graphics.")

   (p "More recently in the last few years I've been working on functional programming as my main hobby development language. Languages like F#, Haskell, and mainly Racket are of great interest to me as they give developers new tools to work with and design programs.")

   (p "When I'm not coding, I'm usually at a boxing gym, running, reinstalling Linux on my computer, attempting to be a digital painter, or designing factories in Factorio.")

   (p "Below are social medias")

   ,(unordered-list (list (link-to "Keybase" "https://keybase.io/sleibrock")
                          (link-to "Instagram" "https://instagram.com/sleibrock")))))



(render-to "public/about.html")
