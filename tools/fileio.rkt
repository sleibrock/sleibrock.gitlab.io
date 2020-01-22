#lang racket/base


(require
 (only-in xml
          xexpr?
          xexpr->xml
          write-xml/content
          )
 (only-in racket/contract
          ->
          any/c
          define/contract
          )
 (only-in racket/file
          copy-directory/files
          delete-directory/files
          make-directory*
          )
 (only-in "parameters.rkt"
          build-directory
          root-directory
          task-directory
          templates-directory
          )
 (only-in "logging.rkt"
          vprint
          )
 )


(provide copy-root-directory
         clean-build-directory
         xexpr->file
         )


(define/contract (copy-root-directory)
  (-> any/c)
  (vprint "Copying root directory to build directory")
  (when (directory-exists? (build-directory))
    (delete-directory/files (build-directory)))
  (copy-directory/files (root-directory) (build-directory)))


(define/contract (clean-build-directory)
  (-> any/c)
  (when (directory-exists? (build-directory))
    (vprint "Deleting build directory")
    (delete-directory/files (build-directory))))


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

; end
