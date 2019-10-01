#lang racket/base

(require (only-in xml
                  xexpr?
                  xexpr->xml
                  write-xml/content
                  validate-xexpr
                  )
         (only-in racket/contract
                  ->
                  any/c
                  none/c
                  and/c
                  define/contract
                  )
         (only-in racket/cmdline
                  command-line
                  )
         (only-in racket/file
                  copy-directory/files
                  delete-directory/files
                  make-directory*
                  )

         ;; custom tooling (only-in not very necessary)
         "tools/html-shortcuts.rkt"
         ;"tools/config.rkt"
         "tools/parameters.rkt"

         (only-in "tools/contracts.rkt"
                  file-path?
                  )

         (only-in "tools/filewatch.rkt"
                  proc-on-file-change
                  )
         )

(provide *name*)

(define root-directory      (path->complete-path "web"))
(define build-directory     (path->complete-path "public"))
(define task-directory      (path->complete-path "tasks"))
(define templates-directory (path->complete-path "templates"))


;; Define some site-wide constant variables
(define *name*     "Steven")
(define *fullname* "Steven Leibrock")
(define *email*    "steven.leibrock@gmail.com")
(define *sitename* "Steven's Site")
(define *keybase*  "https://keybase.io/sleibrock")



;; Publishing parameters (changes links, etc)
(define production?       (make-parameter #f))

;; Task processing parameters here
(define current-file      (make-parameter ""))
(define current-path      (make-parameter ""))
(define current-task      (make-parameter ""))
(define current-verbosity (make-parameter #t))


;; Our namespace anchor in which definitions get loaded into.
;; Loading tasks will reference this namespace anchor accordingly
(define-namespace-anchor a)


;; Renders a given xexpr tree to a filename
(define/contract (xexpr->file xexpr-t fname) (-> xexpr? string? any/c)
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


(define/contract (render-to fname) (-> string? any/c)
  (xexpr->file ((current-template)) fname))



(define/contract (load-template fname) (-> string? any/c)
  (define fpath (build-path templates-directory fname))
  (define cn (namespace-anchor->namespace a))
  (parameterize ([current-namespace cn])
    (load fpath)))
  


;;
(define/contract (copy-root-directory) (-> any/c)
  (when (current-verbosity)
    (displayln "Copying root directory to build directory"))
  (when (directory-exists? build-directory)
      (delete-directory/files build-directory))
  (copy-directory/files root-directory build-directory))


;;
(define/contract (clean-build-directory) (-> any/c)
  (when (current-verbosity)
    (displayln "Deleting build directory"))
  (when (directory-exists? build-directory)
    (delete-directory/files build-directory)))


;;
(define (run-task task-path) (-> (and/c file-exists? path?) any/c)
  (define cn (namespace-anchor->namespace a))
  (parameterize ([current-namespace cn]
                 [current-file task-path]
                 [current-path task-path])
    (when (current-verbosity)
      (displayln (format "Executing '~a'" (current-file))))
    (load task-path)))


;; Apply run-task to all valid task file paths in the /tasks folder
(define/contract (run-all-tasks)
  (-> any/c)
  (for-each run-task
            (filter file-path? 
                    (directory-list #:build? #t task-directory))))


;;
(define/contract (build-whole-site) (-> any/c)
  (when (current-verbosity)
    (displayln "Building whole website"))
  (copy-root-directory)
  (run-all-tasks))


;; Activate a file change service
(define/contract (watch-for-changes) (-> any/c)
  (define watcher-thread (proc-on-file-change run-task))
  (thread-wait watcher-thread))
  


;;
(define/contract (entry-point) (-> any/c)
  (command-line
   #:program "builder"
   #:args    (action)
 
   (cond ([string=? action "build"] {build-whole-site})
         ([string=? action "tasks"] {run-all-tasks})
         ([string=? action "clean"] {clean-build-directory})
         ([string=? action "watch"] {watch-for-changes})
         ([string=? action "watch"] {displayln "bigshrug"})
         (else (displayln (format "error: invalid command '~a'" action))))))

(module+ main (entry-point))
  

; end
