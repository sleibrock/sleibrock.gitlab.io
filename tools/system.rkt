#lang racket/base

(require (only-in racket/file
                  file->string
                  ))


(provide get-git-version
         )


;; This function can only be used locally
;; When CI builds, it does not copy the .git folder
;; so this is for local builds only, not CI-related
(define (get-git-version)
  (file->string (build-path ".git" "refs" "heads" "main")))

; end
