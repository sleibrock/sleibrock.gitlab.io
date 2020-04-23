(load-template "page.rkt")

(current-title       "Racket's Return")
(current-description "Why am I using Racket again?")
(current-keywords    "racket coding website")
(current-filetarget  "racket-return.html")
(current-date        "2020-04-21")

(para "As few may remember, I made a leap from a Racket-built website to one using a framework written in Rust called Zola. Why the switch to begin with at all? Why revert back to an older commit with my most modern Racket code? Let's dig in.")

(h2 "Abandonment")

(para "At the time, when I had switched to Zola, I had a lot of widespread issues just getting used to the platform itself. Getting a basic skeleton website up proved tricky, and I had to do a lot of ground work to get something usable. I copied a lot of templates from the Racket version and in turn modified it to make it work with Zola. That part didn't turn out to be the hardest part of all, it was really mostly all problems I had learning Zola itself.")

(para "Zola is a big undertaking for anyone to use, it's a lot of documentation, and not particularly very easy at first. There's a lot of variables and config-file modification to get through, and even understanding how their templating system worked with subdirectories proved a hassle. Every sub-directory could have it's own templates defined, and if none were found, it defaulted to a parent directory's templates as a backup. The structure became more troublesome the more deeper-nested it would become as the templates folder tree would really just have to mirror the public content's tree structure one-for-one.")

(para "Inheriting templates was confusing at first, loading static images was another issue I ran into, and then when it came to doing pagination and generating page-by-page numbering systems, I just lost hope. While it was nice that Zola lifted a lot of work off my shoulders for publishing, I lost a lot of clarity in how my website was published. It was super fast, but that became less important to me as I noticed I stopped trying to make contributions to my website.")

(para "I'll admit that COVID-19 has stopped me in producing code or hacking things for fun. I would say it's taken its mental toll on lots of people. But once COVID-19 lockdown came around, I lost a lot of creativity, and that reflected on me wanting to work on a Zola-based website even further.")


(h2 "Racket's Grand Return")

(para "So in spite of all things, I git-reset my way back here, and to no surprise, it works perfectly. I decided that I'll just keep trying to work on this instead, because I did find it pretty fun. I might have some more ideas for how to make publishing content even more easier with some future macros, and I might be able to create an auto-generated table-of-contents per page.")

(para "The advantage is that I have a better understanding of this codebase, and know fully what I need to implement. It's just a matter of actually implemting things which becomes the challenge later on, but that's not the worst of it all really.")

(para "A list of some of the things I might want to work on would be:")

(ul '("A Racket #lang mode specific to making posts"
      "A bettter way of doing some things automatically, like grabbing date from file stat info"
      "A Markdown parser? (I attempted this once and was really bad at it)"
      "More templates for more interesting pages"
      "Better logging support (its ugly)"))

(para "Now that I've returned to Racket with a more fresh perspective, I'd like to take another go at it. I have a tiny laundry list of things to do, so I'm gonna do my best to post more actively, before it becomes another one of those blogs that keep saying \"I'll try to update more frequently\".")

; end
