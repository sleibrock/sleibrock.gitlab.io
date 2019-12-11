#lang racket/base

(require (only-in "parameters.rkt"
                  production?
                  writing-mode?
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

(define (link-to str url)
  `(a ([href ,url]) ,str))

;; should this check if :anch begins with a # and append one if needed?
(define (anchor str anch)
  
  `(a ([href ,anch]) ,str))


(define (root-link str url)
  (link-to str 
           (if (string=? "" url)
               (path->string (current-basepath))
               (path->string (build-path (current-basepath) url)))))


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


;; TODO: complete Gist widget
(define (gist url)
  `(script ([src ,(string-append "https://gist.github.com/" url ".js")]) ""))


; end
