#lang racket/base

(require
 (only-in xml
          xexpr?
          xexpr->xml
          write-xml/content
          validate-xexpr
          permissive-xexprs
          )
 (only-in racket/contract
          ->
          any/c
          none/c
          and/c
          listof
          define/contract
          )
 (only-in racket/list
          range
          last
          )
 (only-in racket/string
          string-join
          string-trim
          string-split
          )
 (only-in racket/cmdline
          command-line
          )

 "tools/html-shortcuts.rkt"
 "tools/parameters.rkt"

 (only-in "tools/fileio.rkt"
          xexpr->file
          copy-root-directory
          clean-build-directory
          )
 (only-in "tools/logging.rkt"
          vprint
          )
 (only-in "tools/contracts.rkt"
          file-path?
          )
 (only-in "tools/system.rkt"
          get-git-version
          )
 )

(provide root-directory)

(*name* "Steven")
(*fullname* "Steven Leibrock")
(*email* "steven.leibrock@gmail.com")
(*sitename* "Steven's Site")
(*sitepath* "https://sleibrock.xyz")
(*keybase* "https://sleibrock.keybase.pub/")


(current-verbosity #t)
(permissive-xexprs #t)

(define-namespace-anchor a)


(define/contract (run-task task-path)
  (-> (and/c file-exists? path?) any/c)
  (define cn (namespace-anchor->namespace a))
  (parameterize ([current-namespace cn]
                 [current-task task-path])
    (vprint (format "Executing ~a" task-path))
    (load task-path)))


(define (load-template fname)
  (-> string? any/c)
  (define fpath (build-path (templates-directory) fname))
  (define cn (namespace-anchor->namespace a))
  (parameterize ([current-namespace cn])
    (load fpath)))

(define/contract (render-to fname)
  (-> string? any/c)
  (xexpr->file ((current-template))
               (path->string (build-path (build-directory) fname))))


(define/contract (run-all-tasks)
  (-> any/c)
  (for-each run-task
            (directory-list #:build? #t (task-directory))))


(define (build-website)
  (vprint "Building website")
  (unless (production?)
    (current-basepath (path->string (build-directory))))
  (define actions (list clean-build-directory
                        copy-root-directory
                        run-all-tasks
                        ))
  (vprint "Running all actions")
  (for-each
   (λ (action)
     (displayln (format "Running action `~a`" action))
     (action))
   actions)
  (displayln (format "Site written to ~a~a"
                     (if (production?) "" "file://")
                     (path->string (build-directory)))))



(module+ main
  (command-line
   #:program "Builder2"
   #:once-each [("-p" "--prod") "Build site for production"
                                (displayln "** PRODUCTION MODE **")
                                (production? #t)
                                (current-basepath (*sitepath*))]
   #:multi [("-s" "--sha") gv
                           "Set the Git commit version we're on"
                           (displayln (format "Git version: ~a" gv))
                           (current-git-sha gv)]
   #:args (action)
   (when (string=? "" (current-git-sha))
     (current-git-sha (get-git-version)))
   (cond ([string=? action "build"] {build-website})
         ([string=? action "clean"] {clean-build-directory})
         (else (displayln (format "error: invalid command ~e" action))))))

; end

