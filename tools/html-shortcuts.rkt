#lang racket/base

(provide link-to
         unordered-list
         )


(define (link-to str url)
  `(a ([href ,url]) ,str))


(define (unordered-list lst)
  (cons 'ul (map
         (λ (item)
           `(li ,item))
         lst)))


; end
