#lang racket/base


(require
 (only-in racket/contract
          define/contract
          ->
          any/c
          )
 (only-in "parameters.rkt"
          current-verbosity
          )
 )

(provide vprint
         )


(define/contract (vprint msg)
  (-> string? any/c)
  (when (current-verbosity)
    (displayln msg)))

; end
