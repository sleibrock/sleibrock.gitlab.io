(load-template "page.rkt")

(current-title       "Racket Contracts")
(current-description "Why Racket Contracts are Cool")
(current-keywords    "racket contracts coding")
(current-filetarget  "contracts.rkt")
(current-date        "2021-03-01")


(para "I haven't written a lot of Racket code in some time, so I went back through some of my old Racket projects and started cleaning them up and seeing where I can do better. Apart from beginner mistakes in not using higher-order functions that may do exactly what I need without rewriting code entirely, I suppose my biggest mistake is not using contracts properly.")

(para "A Racket Contract is a special system. It's a series of macros that ensures runtime safety of types. Racket isn't a typed language (unless you declare it to be), and because of that you can easily run into non-typed language issues like mismatched types in arithmetic functions, or mismatched list data types. Contracts can guarantee type safety, but they can also add an extra layer of security by adding even more restraints.")

(h2 "Basic Contracts")

(para "In this section, I will cover how to use define/contract, which is the most common macro for definitions with contracts.")


(para "A define/contract syntax is the same as define, except it takes something after the name syntax and requires something called a binding contract. The contract tells us what type of data we can expect with the variable. If we want a number, we can assign a contract to ensure that it will always be a number. Even if re-assigned, it will always follow the contract in that scope.")


(code "
#lang racket/base

; import our contract functions/macros
(require racket/contract)

; define a new number variable
(define/contract my-number number? 3)

; define a new string (but it breaks the contract)
(define/contract bad-string string? 'not-a-string)

; try to mutate our number binding
(set! my-number 5) ; good
(set! my-number 'not-a-number) ; bad
")

(para "Upon running this you'll see immediately that the bad-string is indeed not a string, and causes a runtime exception. You'll notice predicate functions like number? and string? are used, and while these are common predicates that we can easily use ourself to ensure better safety, it's much easier to use define/contract. Let's try to define a function with a contract.")

(code "
(define/contract (fibonacci n)
  (-> number? number?) ; takes a number, spits a number out
  (if (< n 2)
      n
      (+ (fibonacci (- n 1)) (fibonacci - n 2))))

; good
(fibonacci 10) ; -> 55

; bad - contract violation
(fibonacci \"this is not a number\") ; expected number? got string
")


(para "This is quite useful as opposed to not having contracts. While this might add a bit of runtime overhead, the guarantees from it are quite powerful. As long as contracts aren't too overbearing or require too much processing, the extra layer of security is quite nice.")

(para "The -> keyword there refers to a function. It acts as an intermediate to define a contract that further defines what the function takes and returns. It however can be re-written to look a lot cleaner.")

(code "
(define/contract (gcd a b)
  (number? number? . -> . number?)
  (if (zero? b)
    a
    (gcd b (modulo a b))))

(gcd 25 5) ; 5
(gcd 'x 5) ; contract violation
")


(para "So far we've been using predicate functions (functions that are normally used to check the type of data), but we can get a little fancier using things called flat contracts.")

(h2 "Flat Contracts")

(para "A Flat Contract is a type of contract that can be used to create complex contracts that add more layers of security. It's one thing to check if a value is a string, but it's another thing to check if it meets a certain length or contains characters.")

(para "Let's start with a simple dilemma: you're working with network code. You want to open a socket. A socket needs a port to bind to or to connect to. So you designate a function to open up a socket with a given port. In theory it would look like this:")

(code "
(define (socket-open port-no)
  (define sock (open-socket))
  (socket-connect! sock \"192.168.1.1\" port-no)
  (if (socket-connected? sock)
    (displayln \"Socket connected\")
    (displayln \"Socket not connected\"))
  sock)

")

(para "So this looks okay... but wait, is it? Not really. What happens if we start poking?")

(code "
(socket-open 1234) ; valid port
(socket-open 'not-a-port) ; runtime error - not a number
(socket-open 123456) ; runtime error - not a valid unix port
")

(para "Not only do we not guarantee that port-no is a number or not, Unix network ports can only be between 0 and 65535. If we're providing a network library, we just provided a very easy-to-break library that will cause many user headaches. Let's avoid that with contracts.")


(code "
; create a new cooler contract
(define port-number? (between/c 0 65535))

; use the new contract
(define/contract (socket-open port-no)
  (port-number? . -> . socket?)
  (define sock (open-socket))
  (socket-connect! sock \"192.168.1.1\" port-no)
  (displayln (if (socket-connected? sock)
    \"Socket connected\"
    \"Socket not connected\"))
  sock)

; poke holes in it
(socket-open 123) ; works
(socket-open 'p)  ; fail - not a number
(socket-open 65536) ; fail - not in unix port range
")

(para "So first we define our new contract, called port-number?. It's a kind of predicate function that goes a bit beyond, and sees whether it is a number, and then determines whether it is in our desired range. It applies a bit of Racket magic and adds some extra security to our library. It saves us time and our users time when they struggle to make our library work. They will get a full error report seeing where exactly where things went wrong.")

(para "These kind of special contracts like between/c allow us to create intermediate functions that can be used as contracts to further define our data types and program flow. Most of the time you don't have to use special contract generators, you can just write Racket code directly into the contract.")

(code "
; Accepts only non-empty strings
(define/contract (double str)
  (-> (λ (s) (not (= 0 (string-length s)))) string?)
  (string-append str str))

; tests
(double \"hey\") ; -> \"heyhey\"
(double \"\") ; -> contract failure: expected ???
")

(para "Doing it this way doesn't leave us with a very good error message. In most cases, it's better to use some tools to leave better messages when things go wrong, and what to expect. This contract has no information about what type we want, or the parameters it failed to meet. Enter flat-contract-with-explanation.")

(code "
; define a new non-empty string contract
(flat-contract-with-explanation
  #:name 'non-empty-string?
  (λ (str)
    (cond
      ([< 0 (string-length str)] #t)
      (else
        (λ (blame)
          (raise-blame-error blame str
                             '(expected: \"a non-empty string\"
                               given: \"~e\") val))))))

; then use it in your functions
(define/contract (double str)
  (-> non-empty-string? string?)
  ...
)

(double \"\") ; -> contract failure: expected a non-empty string
")

(para "That was a bit of code, but it's an interesting dive into how we can define contracts, and how the error system works in the sense of bubbling errors upwards via the blame variable (the computation looks for the error, assigns the blame, then the blame retrieves the reason for failure and yields it back to the user). But this contract code looks very intense, and we could shorten it a bit by using some other flat contract combinations.")


(para "So two flat contracts we can try, not/c and string-len/c. A not/c will invert the results of any contracts it receives, and string-len/c will recognize any strings with fewer characters than a number it is given.")


(code "
; string-len/c passes on strings with fewer than N characters
; so we use not/c to invert the result on strings with 1 or more characters
(define non-empty/string? (not/c (string-len/c 1)))

(define/contract (double str)
  (-> non-empty-string? string?)
  ...
)

(double \"\") ; -> contract failure: expected (not/c (string-len/c 1))
")

(para "While it is more convenient to use flat contracts to create intermediates, sometimes it is better to create contracts with flat-contract-with-explanation, simply because it would allow you to create more meaningful errors for your end-users.")

(para "A lot of flat contracts follow some core logic rules like and/c and or/c, where all contracts must be met, or only one contract must be met. Another one that gives us a cool level of control is listof, where it checks the contract against all values in a list.")


(code "
(define/contract (sum lst)
  (-> (listof number?) number?)
  (foldr + 0 lst))

(sum '(1 2 3)) ; -> 6
(sum '(hello world)) ; -> contract failure
")

(para "There are other list-based contracts that allow you to define the size of a desired list, such that the shape of lists must match a certain size. In an untyped language, this can be a boon. But this can add a layer of overhead, as Racket may see this as open grounds for iterating through the entire list, so this may not be ideal on very large datasets.")


(h2 "Wrap-Up")

(para "A lot of this seems almost unnecessary, like why add pseudo-typing to an untyped Lisp-based language when it doesn't have any performance benefits at runtime? I think that might be a bit of a loaded question mostly because it's not entirely about performance, but moreso the security and user benefits of having smarter code that is easier to reason about. Adding static typing to a language makes it easier to infer a variable is indeed of one type, but checking whether a type is in a certain range, or if it meets certain conditions, is pretty damn cool too.")

(para "It adds some overhead, but it's not mandatory to use. You can roll your own error messages and linearly iterate through a series of error bubblings yourself all you want. It's just the define/contract macro would do that for you if you provide it the right info. Is it worth using everywhere? Probably not, but it's worth using if it would clear up code for you, or if you are a library writer. I wish languages like Rust might add these things some day because it's a cool use of functional programming in a very interesting way.")

(para "Be sure to check out " (link-to "Typed Racket" "https://docs.racket-lang.org/ts-guide/index.html?q=and%2Fc") " if you liked the idea of contracts in Racket. It might be what you need if you want more performance benefits with a Lisp-like language.")
