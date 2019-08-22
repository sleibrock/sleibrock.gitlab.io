#lang racket/base

(require racket/cmdline)
(require xml)
(require (only-in racket/file
                  copy-directory/files
                  delete-directory/files))

(provide *name*)

(define root-directory   "web")
(define build-directory  "public")
(define task-directory   "tasks")

;; Define some site-wide constant variables
(define *name*     "Steven")
(define *fullname* "Steven Leibrock")
(define *email*    "steven.leibrock@gmail.com")
(define *sitename* "Steven's Site")
(define *keybase*  "https://keybase.io/sleibrock")


(define *verbose* (make-parameter #t))


(define (copy-root-directory)
  (define-values (root build)
    (values (string->path root-directory)
            (string->path build-directory)))
  (when (directory-exists? build)
      (delete-directory/files build))
  (copy-directory/files (string->path root-directory)
                        (string->path build-directory)))



(define (xexpr->file xexpr-t fname)
  (define fpath (string->path fname))
  (unless (xexpr? xexpr-t)
    (error "xexpr->file: not supplied a Xexpr tree"))
  (call-with-output-file fpath
    (λ (output-port)
      (parameterize ([current-output-port output-port])
        (write "<!doctype html>")
        (write-xml/content (xexpr->xml xexpr-t))))
    #:exists 'replace)
  (displayln "Finished writing file"))


(define current-file     (make-parameter ""))
(define current-path     (make-parameter ""))
(define current-template (make-parameter ""))
(define-namespace-anchor a)
(define cn (namespace-anchor->namespace a))
(define files (list "index.rkt"))


(define task-files (directory-list task-directory))

(define (build-whole-site)
  (copy-root-directory)
  (for-each
   (λ (tfpath)
     (parameterize ([current-namespace cn]
                    [current-file tfpath]
                    [current-path tfpath])
       (displayln (format "Executing ~a" (current-file)))
       (load (build-path task-directory tfpath))
     ))
   files))

(define (entry-point)
  (command-line
   #:program "builder"
   #:args (action)
 
   (cond ([string=? action "build"] {build-whole-site})
         (else (displayln "shrug")))))


(module+ main
  (entry-point))
  

; end
