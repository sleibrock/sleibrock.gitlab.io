(load-template "page.rkt")

(current-title       "Differential Calculus in Haskell")
(current-description "How to do Differential Calculus with Haskell")
(current-keywords    "differential calculus haskell")
(current-filetarget  "diffcalc.html")
(current-date        "2019-12-16")


(para "Today I'd like to try to talk about using " '(b "Differential Calculus") " in Haskell. Or rather, " '(i "Symbolic Calculus."))

(para "Note: if you want skip the essay, " (link-to "Click this for source code" "https://github.com/sleibrock/haskell-notes/blob/master/programs/symbolic_calculus.lhs"))

(para "Symbolic Calculus is a strategy in ML-like languages that uses pattern matching on types to determine what action to take on a piece of data. A lot of libraries, like " (link-to "SymPy" "https://sympy.org") " often defer to this strategy because logically, it's the easiest to process by turning a string into a data type that can be transformed based on it's contents.")

(para "How is Haskell different than SymPy in this case? Really not much different other than using some of Haskell's advanced features like nested type matching rules on function definitions. But you will need to write a lot of different rules to match many different edge-cases used in Calculus, mostly in specific instances of 'oh, this happens when this side of the equation is this'.")


(h2 "The Data Type")

(para "Let's start with our core data type which we'll just call Expr. An Expr type is one that represents different types of functions and variables. It can be a constant value, a variable/symbol, an arithmetic expression, a function, or even a NaN value (not a number). It can be a value, a unary function, or a binary function, and you can feel free to add more if you want to go further. Currently, this only supports real numbers (though I'm curious about supporting complex numbers now).")

(para "You can also use any of the Haskell code and use it in OCaml or F#, or even Rust, but I tried Rust and found it very unintuitive to do this.")


(code "
data Expr a = NaN                    -- when something is div by zero
            | Var Char               -- a variable with a Char
            | Const a                -- a constant value ie 5
            | Add (Expr a) (Expr a)  -- distributive laws
            | Sub (Expr a) (Expr a)
            | Mul (Expr a) (Expr a)  -- product rule
            | Div (Expr a) (Expr a)  -- quotient rule
            | Pow (Expr a) (Expr a)  -- ax^(f(x))
            | Exp (Expr a) (Expr a)  -- ne^f(x)
            | Ln  (Expr a)           -- logarithm rule #1
            | Log (Expr a)           -- logarithm rule #2
            | Sin (Expr a)           -- trig laws, sin(x) = -cos(x)
            | Cos (Expr a)           -- cos(x) => sin(x)
            | Tan (Expr a)           -- tan(x) = sin(x)/cos(x)
              deriving (Show, Eq)
")


(para "The next steps will be as follows: " '(b "Simplifying") " and " '(b "Deriving") ".")


(h2 "Simplification")

(para "Simplification is the act of trying to convert one equation into something much easier to work with, and this will prove vital as we write rules for derivation, because we can't write rules for " '(i "every") " possible equation out there.")

(para "Simplification starts with this function header:")

(code "simplify :: Expr a -> Expr a")

(para "But later on this will not suffice because numbers are weird, so we need to declare what numbers we're actually going to work with. The best thing we got will be the RealFloat typeclass, so let's re-write this:")

(code "simplify :: (RealFloat a) => Expr a -> Expr a")

(para "First off, let's look at some basic arithmetic rules. In all of these simplification rules, we will be working with two sides; the left-hand operand and the right-hand operand. We will have to write rules that take into account both sides for full simplification. So let's start with some addition and subtraction, which is pretty easy.")

(code "
simplify (Add a         (Const 0))    = simplify a
simplify (Add (Const 0)         b)    = simplify b
simplify (Add (Const a) (Const b))    = Const (a + b)

simplify (Sub a         (Const 0))    = simplify a
simplify (Sub (Const 0)         b)    = simplify (neg b)
simplify (Sub (Const a) (Const b))    = Const (a - b)
simplify (Sub a (Mul (Const (-1)) b)) = Add a b
")

(para "The idea here is to 'crush' constant values into a singular constant value. And if zeroes are ever added into the mix, just crush those as well since they are not important. These rules are more of a 'just in case' measure.")

(para "Next we'll move onto multiplication and division, which are... more messy.")

(code "
simplify (Mul (Const a) (Const b)) = Const (a * b)
simplify (Mul a         (Const 1)) = simplify a
simplify (Mul (Const 1)         b) = simplify b
simplify (Mul a         (Const 0)) = Const 0
simplify (Mul (Const 0)         b) = Const 0
simplify (Mul (Var l)   (Const c)) = Mul (Const c) (Var l)
simplify (Mul (Mul (Const (-1)) f) (Mul (Const (-1)) g)) = Mul f g

-- combine equal terms (and when there's neg numbers involved)
simplify (Mul a                    b) | a==b = Pow a (Const 2)
simplify (Mul a (Mul (Const (-1)) b)) | a==b = Mul (Const (-1)) (Pow a (Const 2))
simplify (Mul (Mul (Const (-1)) a) b) | a==b = Mul (Const (-1)) (Pow a (Const 2))

-- division rules (divide by zero results in a NaN)
simplify (Div (Const a) (Const b)) = Const (a / b)
simplify (Div (Const 0)         _) = Const 0
simplify (Div _         (Const 0)) = NaN
simplify (Div a                 b) | a == b = Const 1   -- (x/x) = 1
simplify (Div a         (Const 1)) = simplify a
")

(para "For this there's a lot of special rules involving multiplication, so the equal terms area is all about combining similar values into Power expressions instead. Multiplying by one or zero also lead to easy reductions, and dividing by one or zero (or X divided by itself) are easy things to reduce.")

(para "I also try to make an effort to keep variables and constants, when multiplied, in a consistently arranged order. I try to keep constants on the left side and variables on the right side, because 3x is easier to interpret as opposed to x3.")

(para "Next is power rules.")

(code "
simplify (Pow (Const a) (Const b))         = Const (a ** b)
simplify (Pow a         (Const 1))         = simplify a
simplify (Pow a         (Const 0))         = Const 1
simplify (Pow (Pow c (Const b)) (Const a)) = Pow c (Const (a*b))
")

(para "As you can see, the easiest things we can pluck out all involve non-variable based power expressions like when we do 3^5, or x^0 or x^1.")

(para "Here's a silly tiny rule that will invert an odd additon into a subtraction")

(code "
-- instead of having (-f + g), lets turn it into (g - f)
simplify (Add (Mul (Const (-1)) a) b) = Sub b a
")

(code "Negative values often lead to a lot of nested values, so this helps reduce that kind of bloat.")

(para "Lastly here's some remaining ones, specifically involving the Euler identity.")

(code "
-- euler identities of sin(x)^2 + cos(x)^2 = 1
simplify (Add (Pow (Sin f) (Const 2)) (Pow (Cos g) (Const 2))) | f == g = Const 1
simplify (Add (Pow (Cos f) (Const 2)) (Pow (Sin g) (Const 2))) | f == g = Const 1
simplify (Sub (Mul (Const (-1)) (Pow (Sin f) (Const 2))) (Pow (Cos g) (Const 2))) | f == g = Const (-1)
simplify (Sub (Mul (Const (-1)) (Pow (Cos f) (Const 2))) (Pow (Sin g) (Const 2))) | f == g = Const (-1)
")

(para "Not that I think you'll run into these issues very often, but it happens quite a bit when doing trigonometric differentiation (we'll see later). Look at how all those nested values can be reduced so easily. It's ugly, but in the end, it's funny how it all boils down to a simple one.")

(para "The rest of the simplification process is recusively applying the simplify calls, but that's not terribly interesting. The source code will be linked to a single monofile where all the rules I wrote are listed.")

(h2 "Deriving Rules")

(para "Deriving or differentiating is where we take a function, put it in a limit with a delta, and slowly reduce the delta to zero to see the instantaneous change that the function will undergo. To save time on calculating limits by hand, there's a bunch of rules that students in math can remember to easily derive equations and get their first-derivatives.")

(ul '("Derivative of a not-a-number is simply NaN"
      "Derivative of one is zero"
      "Derivative of a single variable is one"
      "Derivative of A + B is derive(A) + derive(B)"
      "Derivative of subtraction is the same"))


(code "
derive :: (RealFloat a) => Expr a -> Expr a
derive NaN                     = NaN
derive (Const c)               = Const 0
derive (Var x)                 = Const 1
derive (Add f g)               = Add (derive f) (derive g)
derive (Sub f g)               = Sub (derive f) (derive g)
")


(para "Those are the easy ones, now we'll see what happens when we start incorporating variables with multiples, or even power functions (even though power functions are quite simple).")


(code "
derive (Mul (Const x) (Var l)) = Const x
derive (Mul (Var l) (Const x)) = Const x
derive (Pow (Var l) (Const n)) = Pow (Mul (Const n) (Var l)) (Const (n-1))
derive (Pow (Mul (Const c) (Var l)) (Const n)) = Pow (Mul (Const (n*c)) (Var l)) (Const (n-1))
derive (Pow f (Const n)) = Mul (derive f) (Pow (Mul (Const n) f) (Const (n-1)))
")

(para "The derivative of any variable with a multiple is simply that number itself, because that's the rate at which that variable will change over it's domain. For any function raised to a specific power, let's say n, it's derivative is that power multiplied by n-1. The last rule is when we have a function raised to a power, we have to derive further while also applying the power rule. This is the chain rule for those familiar with it.")

(para "Let's move onto some easier rules.")

(code "
derive (Ln (Var c)) = (Div (Const 1) (Var c))
derive (Sin (Var c)) = Cos (Var c)
derive (Cos (Var c)) = neg (Sin (Var c))
derive (Sin f)       = Mul (derive f) (Cos f)
derive (Cos f)       = Mul (neg (derive f)) (Sin f)
")

(para "The logarithm rule is easy when it's a singular variable, and the trig rules are easy when it's only a single variable. When those contain nested functions, we must use the chain rule further to get the full derivative, where we multiply the inner value's derivative by the derivation of the original.")

(para "Next are multiplication and division rules. Multiplication rule looks like a Cartesian product almost where derivatives of each are applied to the other side, then it's all mushed together. The division rule also does that, but then divides by the right-hand operand taken to a power of 2.")

(code "
derive (Mul f g) = Add (Mul f (derive g)) (Mul (derive f) g)
derive (Div f g) = Div (Sub (Mul g (derive f)) (Mul f (derive g))) (Pow g (Const 2)) 
")


(para "Here is where I found myself stopping, because I haven't fully mapped out every and all differentiation edge-case, and again, I might pick this up again when I start looking at complex number calculus. This is a good enough point to do some basic calculus, so let's look at how we might go about printing these out.")

(code "
join :: (Foldable t) => t String -> String
join = foldl (++) ""

pretty :: (RealFloat a, Show a) => Expr a -> String
pretty (Const a)              = show a
pretty (Var a)                = join [(a:"")]
pretty (Add f g)              = join [\"(\", (pretty f), \" + \", (pretty g), \")\"]
pretty (Sub f g)              = join [\"(\", (pretty f), \" - \", (pretty g), \")\"]
pretty (Mul f (Const 1))      = pretty f
pretty (Mul (Const 1) f)      = pretty f
pretty (Mul (Const (-1)) f)   = join [\"-\", (pretty f)]
pretty (Mul f (Const (-1)))   = join [\"-\", (pretty f)]
pretty (Mul f (Const x))      = join [(show x), (pretty f)]
pretty (Mul (Const x) f)      = join [(show x), (pretty f)]
pretty (Mul f g)              = join [\"(\", (pretty f), \" * \", (pretty g), \")\"]
pretty (Div f g)              = join [\"(\", (pretty f), \" / \", (pretty g), \")\"]
pretty (Pow a (Const x))      = join [\"[\", (pretty a), \"^\", (show x), \"]\"]
pretty (Pow a n)              = join [\"[\", (pretty a), \"^(\", (pretty n), \")]\"]
pretty (Sin f)                = join [\"sin(\", (pretty f), \")\"]
pretty (Cos f)                = join [\"cos(\", (pretty f), \")\"]
pretty (Tan f)                = join [\"tan(\", (pretty f), \")\"]
pretty (Ln f)                 = join [\"log|\", (pretty f), \"|\"]
pretty f                      = show f -- <- last resort formatter
")

(para "Here is my Pretty Printing rule for command line output. I actually rigged an experimental function for LaTeX rendering, but you can see that in the source code for yourself.")

(para "With all the above code, you can write some test solvers for yourself in Haskell.")

(code "
main :: IO ()
main = do
  putStrLn \"Differentiating x^2\"
  putStrLn $ pretty $ simplify $ derive (Pow (Var 'x') (Const 2))
")


(para (link-to "Source code can be found here!" "https://github.com/sleibrock/haskell-notes/blob/master/programs/symbolic_calculus.lhs") " Let me know what you think if you see any issues or have questions.")
