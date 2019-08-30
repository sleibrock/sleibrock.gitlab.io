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
                  )

         ;; custom tooling (only-in not very necessary)
         "tools/html-shortcuts.rkt"
         )

(provide *name*)

(define root-directory   "web")
(define build-directory  "public")
(define task-directory   "tasks")
(define templates-directory "templates")

;; Define some site-wide constant variables
(define *name*     "Steven")
(define *fullname* "Steven Leibrock")
(define *email*    "steven.leibrock@gmail.com")
(define *sitename* "Steven's Site")
(define *keybase*  "https://keybase.io/sleibrock")

;; Define parameters here
(define current-file      (make-parameter ""))
(define current-path      (make-parameter ""))
(define current-task      (make-parameter ""))
(define current-data      (make-parameter ""))
(define current-template  (make-parameter ""))
(define current-verbosity (make-parameter #t))


;; Our namespace anchor in which definitions get loaded into.
;; Loading tasks will reference this namespace anchor accordingly
(define-namespace-anchor a)




;; HTML sections to preserve/reuse (for now)
(define current-title (make-parameter "Steven Leibrock's Website"))
(define *header*
  (λ ()
    `(head
      (title ,(current-title))
      (link ([rel "stylesheet"] [href "static/css/style.css"]))
      (meta ([charset "utf-8"]))
      (meta ([viewport "width=device-width, initial-scale=1.0"]))
      (meta ([keywords "Steven Leibrock personal website"]))
      (meta ([author "Steven Leibrock"]))
      (meta ([description "Steven Leibrock's Personal Website"])))))

(define *nav*
  (λ ()
    `(div ([id "navbar"])
          (span ([id "navtitle"]) "Steven's Site")
          (span ([class "navlink"]) ,(link-to "About" "about.html")))))

(define *footer*
  (λ ()
    `(div ([id "footer"])
          (p "Steven Leibrock 2019"))))
  

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
  (when (current-verbosity)
    (displayln "Copying root directory to build directory"))
  (define-values (root build)
    (values (string->path root-directory)
            (string->path build-directory)))
  (when (directory-exists? build)
      (delete-directory/files build))
  (copy-directory/files root build))


;;
(define (clean-build-directory)
  (when (current-verbosity)
    (displayln "Deleting build directory"))
  (define build-dir (string->path build-directory))
  (when (directory-exists? build-dir)
    (delete-directory/files (string->path build-directory))))


;;
(define (run-tasks)
  (define cn (namespace-anchor->namespace a))
  (define task-files (directory-list task-directory))
  (for-each
   (λ (task-path)
     (parameterize ([current-namespace cn]
                    [current-file task-path]
                    [current-path task-path])
       (when (current-verbosity)
         (displayln (format "Executing '~a'" (current-file)))
         ;(displayln (format "Template: ~a" (current-template)))
         )
       (load (build-path task-directory task-path))))
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
         (else (displayln (format "error: invalid command '~a'" action))))))

(module+ main
  (entry-point))
  

; end
