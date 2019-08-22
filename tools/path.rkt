#lang racket/base

(provide is-racket-file?
         )


(define (is-racket-file? path)
  (define s (path->string path))
  (values 0))


; end
