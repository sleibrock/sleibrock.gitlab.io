(current-template
 (λ ()
   `(rss ([version "2.0"])
         (channel
          (title ,(*sitename*))
          (description "The RSS feed for Steven Leibrock's website")
          (link ,(*sitepath*))
          (category ([domain ,(*sitepath*)])
                    "Computers/Software/Internet/Programming/Code")
          (copyright "MIT 2020 Steven Leibrock")
          (docs ,(string-append (*sitepath*) "/rss.xml"))
          (language "en-us")
          (lastBuildDate ,(format "~a" (seconds->date (current-seconds))))
          (managingEditor ,(*email*))
          (pubDate "Not implemented currently")
          (webMaster ,(*email*))
          (generator "https://github.com/sleibrock/sleibrock.gitlab.io")
          
          ,(cons 'posts
                 (map
                  (λ (page-chunk)
                    `(item
                      (title ,(page-title page-chunk))
                      (description ,(page-desc page-chunk))
                      (date ,(page-datestr page-chunk))
                      (link ,(string-append (*sitepath*)
                                            "pages"
                                            (page-filedst page-chunk)))))
                  (current-pagechunks)))))))

(render-to "rss.xml")

; end rss.rkt
