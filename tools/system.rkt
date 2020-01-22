#lang racket/base

(require (only-in racket/file
                  file->string
                  ))


(provide get-git-version
         get-git-version-pair
         )


(define (get-git-version)
  (file->string (build-path ".git" "refs" "heads" "master")))

(define (get-git-version-pair)
  (let ([v (get-git-version)])
    `(,(substring v 0 7) . ,v)))


; end
