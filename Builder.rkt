#lang racket/base

(require (only-in xml
                  xexpr?
                  xexpr->xml
                  write-xml/content
                  )
         (only-in racket/cmdline
                  command-line
                  )
         (only-in racket/file
                  copy-directory/files
                  delete-directory/files
                  ))

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

;; Define parameters here
(define current-file     (make-parameter ""))
(define current-path     (make-parameter ""))
(define current-task     (make-parameter ""))
(define current-template (make-parameter ""))
(define current-verbosity (make-parameter #t))


(define-namespace-anchor a)



;;
(define (xexpr->file xexpr-t fname)
  (define fpath (string->path fname))
  (unless (xexpr? xexpr-t)
    (error "xexpr->file: not supplied a Xexpr tree"))
  (call-with-output-file fpath 
    #:exists 'replace
    (λ (output-port)
      (parameterize ([current-output-port output-port])
        (display "<!doctype html>")
        (write-xml/content (xexpr->xml xexpr-t)))))
  (when (current-verbosity)
    (displayln "Finished writing file")))


;;
(define (copy-root-directory)
  (define-values (root build)
    (values (string->path root-directory)
            (string->path build-directory)))
  (when (directory-exists? build)
      (delete-directory/files build))
  (copy-directory/files root build))


;;
(define (clean-build-directory)
  (delete-directory/files (string->path build-directory)))


;;
(define (run-tasks)
  (define cn (namespace-anchor->namespace a))
  (define task-files (directory-list task-directory))
  (for-each
   (λ (task-file-path)
     (parameterize ([current-namespace cn]
                    [current-file task-file-path]
                    [current-path task-file-path])
       (when (current-verbosity)
         (displayln (format "Executing ~a" (current-file))))
       (load (build-path task-directory task-file-path))))
   task-files))


;;
(define (build-whole-site)
  (when (current-verbosity)
    (displayln "Building whole website"))
  (copy-root-directory)
  (run-tasks))


;;
(define (entry-point)
  (command-line
   #:program "builder"
   #:args (action)
 
   (cond ([string=? action "build"] {build-whole-site})
         ([string=? action "tasks"] {run-tasks})
         ([string=? action "clean"] {clean-build-directory})
         ([string=? action "watch"] {displayln "bigshrug"})
         (else (displayln (format "error: invalid command '~a" action)))))

(module+ main
  (entry-point))
  

; end
