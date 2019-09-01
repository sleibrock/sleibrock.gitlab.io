#lang racket/base

(provide watch-file
         )


(define (watch-file parent-thread file-path)
  (thread
   (λ ()
     (define (loop)
       (define evt-thing 0)
       ;(sync evt-thing?)
       (sleep 1)
       (loop))
     (loop))))


; end
