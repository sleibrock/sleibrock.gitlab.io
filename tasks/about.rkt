(load-template "page.rkt")

(current-title "About Steven | Steven's Site")
(current-description "Description of Steven Leibrock")
(current-keywords "Steven Leibrock about page")

(current-stylesheets '("static/css/style.css"))

(current-contents
 `((p "Hi there, my name is Steven Leibrock, and I a hobbyist computer nerd and tech enthusiast. I advocate for free open-source software, I enjoy writing in functional programming languages, and I like retro gaming in my spare time. Also I prefer Emacs over Vim, but still use Vim occasionally.")

   (p "")


   ; more as follows when needed

   ))
     

(render-to "about.html")
