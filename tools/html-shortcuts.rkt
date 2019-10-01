#lang racket/base

(provide link-to
         anchor
         css
         unordered-list
         ordered-list
         table-of-contents
         )


(define (link-to str url)
  `(a ([href ,url]) ,str))

;; should this check if :anch begins with a # and append one if needed?
(define (anchor str anch)
  
  `(a ([href ,anch]) ,str))


(define (css fpath)
  `(link ([rel "stylesheet"] [href ,fpath])))


(define (unordered-list lst)
  (cons 'ul
        (map (λ (item) `(li ,item)) lst)))

(define (ordered-list lst)
  (cons 'ol
        (map (λ (item) `(li ,item)) lst)))


;; TODO: recreate a table of contents from a list of pairs
(define (table-of-contents lst)
  (cons 'ol (list 1)))


; end
