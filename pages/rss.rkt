(load-template "page.rkt")

(current-title       "The Road to rss.xml")
(current-description "Or \"why I re-structured my website program to accomodate for RSS feed generation\"")
(current-keywords    "Racket rss website publishing ssg")
(current-filetarget  "rss.html")
(current-date        "2020-01-22")


(para "Remember all that time I spent talking about my website in a really long post, fantasizing about how my static website program was so different from others? Well, I recently went back and decided to re-do my master program, which I just refer to as Builder.rkt")

(para "Why did I decide to do this and create Builder2.rkt? I had a lot of major flaws (and at some point, a lot of original Builder.rkt became almost unreadable to me), so I decided to re-think how I did some things regarding my posts, the readability of the code, separation of functions into new files, and ultimately I feel I did a better job with Builder2.rkt. So let's dig in.")


(h2 "An rss.xml Goal")

(para "I was contemplating adding an RSS feed for a while, because while I might think it's a bit of a dead technology, it might be useful somewhere down the line, or even a fun experiment just to produce.")

(code "
(struct page (title desc datestr filedst contents))
")

(para "But here's where I ran into a stitch: re-using articles. In one task, I already delegated reading and writing my article files from one task. It's not exactly fair to my system to have to re-read these articles over again every time I want to use bits of it for something as simple as generating an RSS feed. The only way I could see to lift this burden was by adding a new build parameter: a list of all my pages.")

(para "From the get-go, I will define structs that contain the contents of each page and it's properties, so that I can access portions of the page with field access functions. The struct would look something like title, description, date, file to write to, and then the whole page itself as an XML tree. All these pages would then be loaded into a new parameter that can be accessed by multiple tasks instead, since that makes more sense because multiple parts of a website may require information about the articles.")

(code "
(define (page->file chunk writerf base-path)
  (writerf (page-contents chunk)
           (path->string
            (build-path base-path (page-filedst chunk)))))
")

(para "Afterwards I modified some functions that did a lot of writing to be able to support this new page struct idea. Previously I executed a templates parameter to trigger other template variable parameters to create an XML tree as needed. Instead by binding the entire XML tree to each page struct, I'm just able to push that through my XML writing function directly. Then defining a higher-order write function can be mapped over all my pages once I'm ready to write their pages.")



(h2 "Rewriting Builder")

(para "I mentioned that my Builder.rkt code got unmanageable, and in truth, it was. I had a lot of functions mangled into one program space, and as my logic for building the website more troublesome and harder to deal with, a lot of my program space became cluttered. My parameters.rkt file has also gotten so long that sometimes it's nigh impossible to remember which parameters do what and why I put them there and oh gosh is it a nightmare to manage.")

(para "I opted to re-write Builder from the ground up, copying some old bits, testing behavior, and playing around. I separated a lot of functions into new files (namely fileio.rkt) because it made sense to isolate things and put them into their own modules as opposed to keeping it all in my build module. As it turns out, there was a lot of code in my Builder.rkt I didn't really need anymore, so I'm still in the process of trimming the fat and making sure it's cleaner and more manageable.")


(code "
(define/contract (build-whole-site)
  (-> any/c)
  (vprint \"Building whole website\")
  (unless (production?)
      (current-basepath (path->string build-directory)))
  (copy-root-directory)
  (run-all-tasks)
  (displayln (format \"Site written to ~a~a\"
                     (if (production?) \"\" \"file://\")
                     (path->string build-directory))))
")

(para "Looking back at this code, while simple, I definitely wasn't a fan of it now. It only includes two primary actions, one being copy-root-directory and the other being run-all-tasks. I think it's better off if we describe a list of actions we want to run in order, then map an executor over it, so it becomes easier to edit in order exactly what actions we want to run when we finally build our website.")


(code "
(define (build-website)
  (vprint \"Building website\")
  (unless (production?)
    (current-basepath (path->string (build-directory))))

  ; our actions in order of building our website
  (define actions (list clean-build-directory
                        copy-root-directory
                        load-pagechunks
                        run-all-tasks
                        ))

  (vprint \"Running all actions\")
  (for-each (λ (action) (action)) actions)
  (displayln (format \"Site written to ~a~a\"
                     (if (production?) \"\" \"file://\")
                     (path->string (build-directory)))))
")

(para "I think this does it better of creating a manageable list of actions to run, even with a silly executing lambda that looks really silly, but it is visually easier to mentally process what's going on. I need to figure out a better way of calculating some minor details however, but for now it's a decent change in my mind. Also ignore that I removed a contract bind, I'll put it back later.")


(h2 "Lastly, Generating RSS")

(para "It seems fitting that I use the racket/xml library for something that properly uses XML. Since I'm already so experienced with mangling with Xexpr trees, I quickly whip up an RSS mock feed copying from examples, and put it into somethin g I can use.")

(code "
(current-template
 (λ ()
   `(rss ([version \"2.0\"])
         (channel
          (title ,(*sitename*))
          (description \"The RSS feed for Steven Leibrock's website\")
          (link ,(*sitepath*))
          (category ([domain ,(*sitepath*)])
                    \"Computers/Software/Internet/Programming/Code\")
          (copyright \"MIT 2020 Steven Leibrock\")
          (docs ,(string-append (*sitepath*) \"/rss.xml\"))
          (language \"en-us\")
          (lastBuildDate ,(format \"~a\" (seconds->date (current-seconds))))
          (managingEditor ,(*email*))
          (pubDate \"Not implemented currently\")
          (webMaster ,(*email*))
          (generator \"https://github.com/sleibrock/sleibrock.gitlab.io\")
          
          ,(cons 'posts
                 (map
                  (λ (page-chunk)
                    `(item
                      (title ,(page-title page-chunk))
                      (description ,(page-desc page-chunk))
                      (date ,(page-datestr page-chunk))
                      (link ,(string-append (*sitepath*)
                                            \"pages\"
                                            (page-filedst page-chunk)))))
                  (current-pagechunks)))))))
")

(para "It's mostly some boilerplate I copied from a tutorial website about how to create RSS feeds, but I'm hoping it's at least usable " '(i "somewhere") ". I'll most likely be paying attention to it for a bit but unless I get some complaints somewhere from someone, I probably will not be changing this much. At a bare minimum, it provides me exactly what I wanted: something that resembles an RSS feed.")

(para "The important part to note is that I can now access a build parameter containing all my articles, so building things like this is no longer a hinderance but instead just something more natural.")


(h2 "Summary")

(para "Starting now, I have an RSS feed. I don't expect it will be good, but overall, since I changed how I load pages onto here, that is the building block for how future edits to my website will go. Other goals include pagination, categories, proper time/date navigation for posts, and maybe some other things. But for now, having an RSS feed is a sign of some new functionality that previously wasn't here.")

(para "I also have a new link in the bottom-right pointing to my current Git commit. That one was fun to implement/solve the mystery for. As it turns out, GitLab CI does not inherently copy over the entire Git history folder in a project when ran through the CI services. Instead, it pre-processes all Git information into several variables, meaning I could either pass data in from the program invocation, or I could inherit data from the environment. I opted for the former with a new command line entry point.")


(code "
(module+ main
  (command-line
   #:program \"Builder2\"
   #:once-each [(\"-p\" \"--prod\") \"Build site for production\"
                                (displayln \"** PRODUCTION MODE **\")
                                (production? #t)
                                (current-basepath (*sitepath*))]
   #:multi [(\"-s\" \"--sha\") gv
                           \"Set the Git commit version we're on\"
                           (displayln (format \"Git version: ~a\" gv))
                           (current-git-sha gv)]
   #:args (action)
   (when (string=? \"\" (current-git-sha))
     (current-git-sha (get-git-version)))
   (cond ([string=? action \"build\"] {build-website})
         ([string=? action \"clean\"] {clean-build-directory})
         (else (displayln (format \"error: invalid command ~e\" action))))))
")

(para "Which means... yes, there's another parameter to add to my list of crazy parameters. But it's not one I have to worry about much, and it's quite simple to interact with, it all gets dealt with way before the build process starts.")

(para "Stay tuned for more posts about the joy of developing this well-glued together website. Or maybe some posts about writing actual non-website code, who knows!")



