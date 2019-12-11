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
         current-basepath

         current-verbosity
         current-task
         production?
         writing-mode?
         )


;; Publishing content based parameters
(define/contract current-title
  (parameter/c string?)
  (make-parameter ""))


; A page's current datestring
(define/contract current-date
  (parameter/c string?)
  (make-parameter ""))


; An SEO optimized (yea ok) description for a page
(define/contract current-description
  (parameter/c string?)
  (make-parameter ""))


; List of SEO (yea ok) keywords for a page
(define/contract current-keywords
  (parameter/c string?)
  (make-parameter ""))


; List of stylesheets for the <head> section
(define/contract current-stylesheets
  (parameter/c (listof string?)) 
  (make-parameter '()))


; List of scripts to be loaded before the <body>
(define/contract current-scripts
  (parameter/c (listof string?))
  (make-parameter '()))


; A list of postscripts to be loaded after a <body> section
(define/contract current-postscripts
  (parameter/c (listof string?))
  (make-parameter '())) 


; Defines a list of element data that will be written to a template
; use (current-contents) in a template to print it
(define/contract current-contents
  (parameter/c list?)
  (make-parameter '()))


; Determines our current template function for writing files with
(define/contract current-template
  (parameter/c (-> list?))
  (make-parameter ""))


; Defines our current target for writing a file
(define/contract current-filetarget
  (parameter/c string?)
  (make-parameter ""))


; Current build folder location
; eg /home/steve/code/sleibrock.gitlab.io
(define/contract current-basepath
  (parameter/c string?)
  (make-parameter (path->string (path->complete-path "."))))


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


; Determine if a script is in writing mode
; All HTML shortcuts will be pushed to current-contents
(define/contract writing-mode?
  (parameter/c boolean?)
  (make-parameter #f))



; end
