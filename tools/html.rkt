#lang racket/base

(provide link-to)


(define (link-to str url)
  `(a ([href url]) ,str))


; end
