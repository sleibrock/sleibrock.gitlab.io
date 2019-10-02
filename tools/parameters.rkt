#lang racket/base

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
         )



(define current-title        (make-parameter ""))
(define current-date         (make-parameter ""))
(define current-description  (make-parameter ""))
(define current-keywords     (make-parameter ""))
(define current-stylesheets  (make-parameter ""))
(define current-scripts      (make-parameter ""))
(define current-postscripts  (make-parameter ""))
(define current-contents     (make-parameter ""))
(define current-template     (make-parameter ""))
(define current-filetarget   (make-parameter ""))


;; non publishing parameters
(define current-verbosity (make-parameter #f))

; end
