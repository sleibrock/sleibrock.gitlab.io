#lang racket/base

(require
 (only-in xml
          xexpr?
          )
 (only-in racket/contract
          define/contract
          ->
          )
 (only-in "parameters.rkt"
          production?
          current-basepath
          ))


(provide link-to
         anchor
         css
         root-link
         unordered-list
         ordered-list
         table-of-contents

         gist
         )

(define/contract (link-to str url)
  (-> string? string? xexpr?)
  `(a ([href ,url]) ,str))

;; should this check if :anch begins with a # and append one if needed?
(define/contract (anchor str anch)
  (-> string? string? xexpr?)
  `(a ([href ,anch]) ,str))


(define/contract (root-link str url)
  (-> string? string? xexpr?)
  (link-to str 
           (if (string=? "" url)
               (path->string (current-basepath))
               (path->string (build-path (current-basepath) url)))))


(define/contract (css fpath)
  (-> string? xexpr?)
  `(link ([rel "stylesheet"] [href ,fpath])))


(define/contract (list-wrap type)
  (-> symbol? (-> list? xexpr?))
  (λ (lst)
    (cons type
          (map (λ (item) `(li ,item)) lst))))

(define/contract unordered-list (-> list? xexpr?) (list-wrap 'ul))
(define/contract ordered-list   (-> list? xexpr?) (list-wrap 'ol))


;; TODO: recreate a table of contents from a list of pairs
(define (table-of-contents lst)
  (cons 'ol (list 1)))


;; TODO: complete Gist widget
(define/contract (gist url)
  (-> string? xexpr?)
  `(script ([src ,(string-append "https://gist.github.com/" url ".js")]) ""))


; end
