#lang racket/base

(require
 (only-in xml
          xexpr?
          )
 (only-in racket/contract
          define/contract
          ->
          any/c
          )
 (only-in "parameters.rkt"
          production?
          current-basepath
          current-contents
          ))


(provide link-to
         anchor
         css
         root-link
         unordered-list
         ordered-list
         table-of-contents

         gist


         para
         h1
         h2
         h3
         h4
         h5
         code
         ul
         ;ol
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




;; Writing mode assisted functions
(define/contract (push-to-contents anything)
  (-> list? any/c)
  (current-contents (append (current-contents) anything)))

(define/contract (tag-wrap sym data)
  (-> symbol? list? any/c)
  (push-to-contents (list (cons sym data))))


(define (para . restargs) (tag-wrap 'p restargs))
(define (h1 . restargs) (tag-wrap 'h1 restargs))
(define (h2 . restargs) (tag-wrap 'h2 restargs))
(define (h3 . restargs) (tag-wrap 'h3 restargs))
(define (h4 . restargs) (tag-wrap 'h4 restargs))
(define (h5 . restargs) (tag-wrap 'h5 restargs))

(define (code . restargs) (tag-wrap 'pre restargs))

(define (ul lst)
  (push-to-contents (list (unordered-list lst))))


; end
