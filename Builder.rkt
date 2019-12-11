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
                  listof
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

         (only-in "tools/logging.rkt"
                  vprint
                  )
         (only-in "tools/contracts.rkt"
                  file-path?
                  )
         (only-in "tools/filewatch.rkt"
                  proc-on-file-change
                  )
         )

;; In order to use module+, we must provide definitions
(provide *name*
         *fullname*
         *email*
         *sitename*
         *keybase*
         )


;; Define some site-wide constant variables
(define/contract *name*     string? "Steven")
(define/contract *fullname* string? "Steven Leibrock")
(define/contract *email*    string? "steven.leibrock@gmail.com")
(define/contract *sitename* string? "Steven's Site")
(define/contract *sitepath* string? "https://sleibrock.xyz")
(define/contract *keybase*  string? "https://keybase.io/sleibrock")


;; Directory configurations for the project
(define/contract root-directory path?
  (path->complete-path "web"))
(define/contract build-directory path?
  (path->complete-path "public"))
(define/contract task-directory path?
  (path->complete-path "tasks"))
(define/contract templates-directory path?
  (path->complete-path "templates"))


; Set verbosity for maximum debug
(current-verbosity #t)

;; Our namespace anchor in which definitions get loaded into.
;; Loading tasks will reference this namespace anchor accordingly
(define-namespace-anchor a)


;; Renders a given xexpr tree to a filename
;; Checks if the given fname path/directory structure exists
;; and creates it using make-directory*
(define/contract (xexpr->file xexpr-t fname)
  (-> xexpr? string? any/c)
  (define fpath (string->path fname))
  (define-values (dir fp _)
    (split-path fpath))
  (unless (directory-exists? dir)
    (make-directory* dir))
  (call-with-output-file fpath 
    #:exists 'replace
    (λ (output-port)
      (parameterize ([current-output-port output-port])
        (display "<!doctype html>")
        (write-xml/content (xexpr->xml xexpr-t)))))
  (vprint (format "Wrote file to '~a'" (path->string fpath))))


;; A shortcut function to use in tasks
;; Applies xexpr->file to our current-template parameter
;; with a supplied filepath
(define/contract (render-to fname)
  (-> string? any/c)
  (xexpr->file ((current-template)) fname))


;; Load a template file by filename from the templates directory.
;; Each template file should set the current-template parameter
(define/contract (load-template fname)
  (-> string? any/c)
  (define fpath (build-path templates-directory fname))
  (define cn (namespace-anchor->namespace a))
  (parameterize ([current-namespace cn])
    (load fpath)))
  

;; Copy the root directory over to our build directory (web->public)
;; This is mostly used to copy non-codebound files (images/js/css/etc)
(define/contract (copy-root-directory)
  (-> any/c)
  (vprint "Copying root directory to build directory")
  (when (directory-exists? build-directory)
      (delete-directory/files build-directory))
  (copy-directory/files root-directory build-directory))


;; Remove the build directory just to clean it up
(define/contract (clean-build-directory)
  (-> any/c)
  (when (directory-exists? build-directory)
    (vprint "Deleting build directory")
    (delete-directory/files build-directory)))


;; Run a given task file path and evaluate it
(define/contract (run-task task-path)
  (-> (and/c file-exists? path?) any/c)
  (define cn (namespace-anchor->namespace a))
  (parameterize ([current-namespace cn]
                 [current-task task-path])
    (vprint (format "Executing '~a'" task-path))
    (load task-path)))


;; Apply run-task to all task file paths in the /tasks folder
;; Note: only tasks go in the task folder, don't put anything else
(define/contract (run-all-tasks)
  (-> any/c)
  (for-each run-task (directory-list #:build? #t task-directory)))


;; A function which just incorporates the entire build process
;; Is only used from the entry point section
(define/contract (build-whole-site) (-> any/c)
  (vprint "Building whole website")
  (unless (production?)
      (current-basepath (path->string build-directory)))
  (copy-root-directory)
  (run-all-tasks)
  (displayln (format "Site written to ~a~a"
                     (if (production?) "" "file://")
                     (path->string build-directory))))


;; Activate a file change service
(define/contract (watch-for-changes) (-> any/c)
  (define watcher-thread (proc-on-file-change run-task))
  (thread-wait watcher-thread))


;;
(define/contract (entry-point) (-> any/c)
  (command-line
   #:program "builder"

   #:once-each [("-p" "--prod") "Build site for production"
                                (displayln "**PRODUCTION MODE SET**")
                                (production? #t)
                                (current-basepath *sitepath*)]
   #:args    (action)
   (cond ([string=? action "build"] {build-whole-site})
         ([string=? action "tasks"] {run-all-tasks})
         ([string=? action "clean"] {clean-build-directory})
         ([string=? action "watch"] {watch-for-changes})
         ([string=? action "watch"] {displayln "bigshrug"})
         (else (displayln (format "error: invalid command '~a'" action))))))


; Add running entry-point as our main module
(module+ main (entry-point))
  

; end
