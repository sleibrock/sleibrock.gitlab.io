#lang racket/base

(require racket/cmdline)
(require xml)

(provide *name*)


;; Define some site-wide constant variables
(define *name*     "Steven")
(define *fullname* "Steven Leibrock")
(define *email*    "steven.leibrock@gmail.com")
(define *sitename* "Steven's Site")
(define *keybase*  "https://keybase.io/sleibrock")

(define (xexpr->file xexpr-t fname)
  (define fpath (string->path fname))
  (unless (xexpr? xexpr-t)
    (error "xexpr->file: not supplied a Xexpr tree"))
  (call-with-output-file fpath
    (λ (output-port)
      (parameterize ([current-output-port output-port])
        (write-xml/content (xexpr->xml xexpr-t))))
    #:exists 'replace)
  (displayln "Finished writing file"))

(define current-file     (make-parameter ""))
(define current-path     (make-parameter ""))
(define current-template (make-parameter ""))
(define-namespace-anchor a)
(define files (list "index.rkt"))

(define (build-site)
  (for-each
   (λ (fname)
     (parameterize ([current-namespace (namespace-anchor->namespace a)]
                    [current-file fname]
                    [current-path fname])
       (current-template "before")
       (load fname)
       (displayln (format "Template after load: ~a" (current-template)))

       (xexpr->file (current-template) "public/index.html") 
     ))
   files))

(define (entry-point)
  (command-line
   #:program "builder"
   #:args (action)
 
   (cond ([string=? action "build"] {build-site})
         (else (displayln "shrug")))))


(module+ main (entry-point))
  

; end
