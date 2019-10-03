#lang racket/base

(require (only-in racket/contract
                  define/contract
                  parameter/c
                  or/c
                  none/c
                  listof
                  ->
                  ))

(provide current-title
         current-date
         current-description
         current-keywords
         current-stylesheets
         current-scripts
         current-postscripts
         current-contents
         current-template
         current-filetarget

         current-verbosity
         current-task
         production?
         )


;; Publishing content based parameters
(define/contract current-title
  (parameter/c string?)
  (make-parameter ""))

(define/contract current-date
  (parameter/c string?)
  (make-parameter ""))

(define/contract current-description
  (parameter/c string?)
  (make-parameter ""))

(define/contract current-keywords
  (parameter/c string?)
  (make-parameter ""))

(define/contract current-stylesheets
  (parameter/c (listof string?)) 
  (make-parameter '()))

(define/contract current-scripts
  (parameter/c (listof string?))
  (make-parameter '()))

(define/contract current-postscripts
  (parameter/c (listof string?))
  (make-parameter '())) 

(define/contract current-contents
  (parameter/c list?)
  (make-parameter '()))

(define/contract current-template
  (parameter/c (-> list?))
  (make-parameter ""))

(define/contract current-filetarget
  (parameter/c string?)
  (make-parameter ""))


;; non publishing parameters
(define/contract current-verbosity
  (parameter/c boolean?)
  (make-parameter #f))

(define/contract current-task
  (parameter/c (or/c string? path?))
  (make-parameter ""))

(define/contract production?
  (parameter/c boolean?)
  (make-parameter #f))



; end
