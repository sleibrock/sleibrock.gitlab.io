#lang racket/base

(provide file-path?
         )

(define (file-path? p)
  (and (file-exists? p) (path? p)))


(define (racket-file? p)
  0)


(define (filepath/c x) 0)
(define (url/c x) 0)

; end
