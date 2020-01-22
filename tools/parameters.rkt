#lang racket/base

(require
 (only-in racket/contract
          define/contract
          parameter/c
          or/c
          none/c
          listof
          ->
          ))

(provide *name*
         *fullname*
         *email*
         *sitename*
         *sitepath*
         *keybase*

         articles-per-page

         current-pagechunks

         root-directory
         build-directory
         task-directory
         templates-directory
         
         current-title
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
         current-git-sha

         current-verbosity
         current-task
         production?
         )

;; Personal configuration strings/etc
(define/contract *name*
  (parameter/c string?)
  (make-parameter ""))

(define/contract *fullname*
  (parameter/c string?)
  (make-parameter ""))

(define/contract *email*
  (parameter/c string?)
  (make-parameter ""))

(define/contract *sitename*
  (parameter/c string?)
  (make-parameter ""))

(define/contract *sitepath*
  (parameter/c string?)
  (make-parameter ""))

(define/contract *keybase*
  (parameter/c string?)
  (make-parameter ""))


;; Number of articles per page
(define/contract articles-per-page
  (parameter/c number?)
  (make-parameter 10))


(define/contract current-pagechunks
  (parameter/c list?)
  (make-parameter '()))


;; Current Git SHA for the ref we're building on
(define/contract current-git-sha
  (parameter/c string?)
  (make-parameter ""))


;; Build parameters
(define/contract root-directory
  (parameter/c path?)
  (make-parameter (path->complete-path "web")))

(define/contract build-directory
  (parameter/c path?)
  (make-parameter (path->complete-path "public")))

(define/contract task-directory
  (parameter/c path?)
  (make-parameter (path->complete-path "tasks")))

(define/contract templates-directory
  (parameter/c path?)
  (make-parameter (path->complete-path "templates")))




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


;; Determine if we should publish more verbose output
(define/contract current-verbosity
  (parameter/c boolean?)
  (make-parameter #f))


;; The current task being ran
(define/contract current-task
  (parameter/c (or/c string? path?))
  (make-parameter ""))


; Determines if we are set for production mode
; Production mode will change functionality for most
; website-publishing tools like root links, paths, etc
(define/contract production?
  (parameter/c boolean?)
  (make-parameter #f))


; end
