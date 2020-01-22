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

   ,(unordered-list
     (list
      (link-to "Keybase" "https://keybase.io/sleibrock")
      (link-to "Instagram" "https://instagram.com/sleibrock")))

   (h2 "Computer Gear")

   (p "Here is an (almost) accurate list of what my computer parts are for my desktop.")

   ,(unordered-list
     '("CPU := AMD FX-8350"
       "GPU := MSI Radeon RX 480"
       "Motherboard := GIGABYTE GA-78LMT"
       "SSD := Samsung 860 EVO 500GB"
       "RAM := 16GB (8x2) Corsair 1600MHz DDR3"
       "Cooling := Corsair H110i Water Cooler"
       "Mouse := Logitech G400s"
       "Keyboard := Corsair K70 Cherry MX"
       "OS := NixOS"))

   (p "Other devices are as follows:")

   ,(unordered-list
     '("Refurbished Thinkpad T440 (240GB, NixOS)"
       "iPad Pro 2017 edition 64GB"
       "Alienware Alpha (240GB, NixOS)"))

   ; more as follows when needed

   ))
     

(render-to "about.html")
