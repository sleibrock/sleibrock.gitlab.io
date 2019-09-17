#lang racket/base


#|
Rackdown - a Markdown Parser in Racket?

More coming soon, still semi-experimental
|#

(require (only-in racket/list
                  empty?
                  index-of
                  takef
                  dropf
                  )
         (only-in racket/contract
                  one-of/c
                  not/c
                  )
         )

(struct token (type value len))



(define special-characters (string->list "_-*#[](){}>`\n"))


; define contracts
(define special/c (apply one-of/c special-characters))
(define regular/c (not/c special/c))


; Should produce '(token(#), token(hello, this is a title))
(define test-str "hello, #this is a title")
(define test-chars (string->list test-str))


; Char -> Bool
(define (is-special? x)
  (number? (index-of special-characters x)))

(define (isnt-special? x)
  (not (is-special? x)))


; Grab the first token from the head of the list,
; then return the remainder of the list
; (Listof Char) -> (Pair Token . (Listof Char))
(define (yank-token lst)
  (displayln (format "yank-token: ~a" lst))
  (if (special/c (car lst))
      `(,(token 'special (car lst) 1) . ,(cdr lst))
      (let* ([slice (takef lst regular/c)]
             [str   (list->string slice)]
             [len   (string-length str)]
             [rem   (dropf lst regular/c)])
        `(,(token 'string str len) . ,rem))))


; use `λ splitf-at` 
(define (tokenize str)
  (define chars (string->list str))

  (define (inner lst acc)
    (if (empty? lst)
        acc
        (let* ([result (yank-token lst)]
               [toke   (car result)]
               [rem    (cdr result)])
          (inner rem (cons toke acc)))))
  (inner chars '()))

(define (markdown->xexpr)
  0)

; end
