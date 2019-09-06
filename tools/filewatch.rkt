#lang racket/base

(require (only-in "contracts.rkt"
                  file-path?
                  ))

(provide proc-on-file-change
         )

;; TODO: test and make ready for use
(define (proc-on-file-change dpath proc)
  (unless (directory-exists? dpath)
    (error "proc-on-file-change: given file not a valid directory path"))
  (unless (procedure? proc)
    (error "proc-on-file-change: given proc not a procedure"))
  (define (evt-threader parent-t fpath)
    (thread
     (λ ()
       (define (loop)
         (define evt (filesystem-change-evt fpath))
         (sync evt)
         (thread-send parent-t fpath)
         (loop))
       (loop))))
  (define (proc-threader)
    (thread
     (λ ()
       (define (loop)
         (define datum (thread-receive))
         (proc datum)
         (loop))
       (loop))))

  ; files to apply procs to when files are modified
  (define files (directory-list dpath #:build? #t))

  ; return a new thread which can be controlled
  (thread
   (λ ()
     (define proc-t (proc-threader))
     (define watchers
       (map (λ (fpath) (evt-threader proc-t fpath)) files))

     ; empty loop (does nothing currently)
     (define (loop)
       (sleep 60)
       (loop))
     (loop))))
         
       


; end
