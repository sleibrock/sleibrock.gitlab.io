(load-template "page.rkt")

(current-title       "About this Website")
(current-description "How I built this website using Racket")
(current-keywords    "Website publishing Racket")
(current-filetarget  "about-website.html")
(current-date        "2019-10-2")

(current-contents
 `((p "I'm gonna take some time to explain the mental gymnastics I went through creating this website in such a weird and unique way that I don't think many other people will ever attempt to do: using Racket.")

   (h2 "Racket + XML Trees")

   (p "It all starts with a simple XML tree, known as an X-expression (xexpr). The xexpr tree is a list of symbols with sub-lists of more elements. It's exactly like an S-expression tree (sexpr), but with the intent of being used to represent XML trees.")

   (p "This is used in conjunction with the Racket XML library which can transform an xexpr tree into an XML document. Naturally since HTML is in part some kind of weird derivation of XML, this can also be used to write HTML documents.")

   (p "I got the weird idea that if I used this, I could create a statically-hosted website, such as the one you're reading right now. GitLab CI, which is used, downloads a Racket-based Docker image and runs the Racket source files, which really just writes a bunch of xexpr trees to files. So if you're reading this, you're reading an xexpr tree.")

   (h2 "Parameters, Tasks and Templates")

   (p "I write all of my website from within Racket. Could I write my website from purely Markdown files, as many other static site generators (SSGs) do? Well.... I thought about it, but decided not to.")

   (p "The beauty of Racket is how simple it is to code. I like the idea of data and code not being separate entities, that is I don't design a Racket program to parse text files, I design a Racket program to interpret Racket data structures.")

   (p "Thing is, with Markdown and SSGs, they usually are very restrictive in what you can and can't do. Images usually have very little presentation without additional tools; they're just embedded images. If I wanted to display an image with a caption, I'd have to either create a custom Markdown plugin script in an SSG, or embed HTML in my Markdown files each time. Not a fantastic option, but...")

   (p "I started working on a Markdown parser, before quickly questioning myself 'why am I even doing this? I don't even really like Markdown'. There had to be a better way to structure my pages, something more tolerable.")

   (p "I decided to abuse two things in Racket: evaluating code files, and using parameters. This lead to the creation of my 'task' system, where parts of my website are assigned responsibilities to tasks.")

   (p "What is a task file? It's just a list of Racket functions I want evaluated each time I want to build my website. Each time a task is ran, it should accomplish a goal in the build stage of my website. For example, my 'index.rkt' file has the goal to create my root 'index.html' file.")

   (p "How it works is that Racket will load a file and evaluate the code as-is with the current namespace of Racket functions. To make it simple, I create a set of functions to use within tasks that simplify the process to create a web page (or multiple).")

   (p "However I had some shortcomings; evaluating files doesn't import definitions, it just runs the code. The only way to communicate from the parent process to the evaluated code is using parameters to modify data. This actually isn't a problem for me, and I can make great use of it. (Importing definitions requires some additional work from racket/load)")

   (p "If I create a bunch of parameters, it's easy to pass data between evalulated files. I can set a title, a date, descriptions, stylesheets, and even the page's contents itself. This leads to another tidbit: templates. X-expression re-use is vital as I don't want to spend a lot of time copy/pasting templates between tasks. It's better just to share. So alongside tasks, there's template files, which get evaluated in the same way, but toggle a parameter which gives us a template function. The template's function job is to give us a template each time it's called, which will also lazy-call parameters for us. If not for the lazy-call, parameters will be evaluated before they're even set.")

   (h2 "Custom HTML Tooling")

   (p "I said that Markdown isn't very customizable, which it definitely isn't. It's a set language requiring a complex abstract syntax tree evaluator. I didn't want to get hung up on that, so it's better for me to just write Racket code.")

   (p "The plus side it's very easy to add new features to my templates, just by writing functions that create complex mini-HTML structures for me. If I wanted to create an image with a caption, it's very easy to create a function that accepts two values and does all the work for me. I couldn't achieve this with raw Markdown itself without some overhead.")

   (p "One advanced function I can do is creating a table of contents with not much difficulty. There is no system I can think of that allows you to do this. It's as simple as marking sub-headers as anchors and creating a list of all your names and anchors at the top of your document.")

   (h2 "Sub-Task Execution")

   (p "So here's where it starts to become tricky. This page is part of my writing section where I can write whatever the heck I feel like. You most likely got here by navigating the pages section, but how was this part generated?")

   (p "I said that tasks should have responsibilities, so the responsibility for this section (and hopefully many others) will rely on a task to sub-evaluate certain files as well for indexing purposes.")

   (p "The pages task's goal is to evaluate a list of pages, and generate an index from which they can be browsed. With more parameter tricks, we can do that. It's just as simple as generating a list of files, using my special run-task function, and collecting data from parameters to create an index.")

   (h2 "Live File Rebuilding")

   (p "This part is a struggle, and might continue to be one for a while, because there's no clear-cut solution to it. While developing, it's easier to just rebuild files when they change as opposed to having to rebuild the entire project. But because of how my tasks are delegated, that causes a little bit of tricky tracking.")

   (p "It's easy to watch a given file for changes with some events in Racket, it's harder to keep track of multiple files, but when files are hidden behind task execution stages, then it's probably a very hard thing to keep track of.")

   (p "One idea here is to simply monitor files which are utilized by the tasks and keep a list of associations for files. If pages.rkt builds multiple pages, monitor all the pages, and if any of them ever change, just re-execute the pages.rkt task. Not exactly precise since that may rebuild all the pages over again despite not all of them changing, but it's close.")

   (p "There may be alternate strategies I could employ, but I'm not too worried about it right now. The better my code becomes, the less I'm rebuilding to look for mistakes.")

   ))

; end
