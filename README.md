# Steven's Website

This is my website, constructed with a lot of [Racket](https://racket-lang.org/).

## Personal Racket Style Guideline

**Definitions** - definitions are variables or functions, but the naming convention should be consistent throughout for a better understanding of what variables or functions do. Functions should have unique names that specify (in as little characters as possible) briefly what they are going to do. Variables should follow convention based on what they are/do/provide for the overall project.

**Parameters** - all parameters should start with a `current-` prefix, because parameters can change at a moment's notice and be manipulated by `parameterize`, it's nice to have a prefix to indicate that a definition is indeed a parameter. If we have a parameter `current-file`, then at any time when that parameter is called, it most definitely means "the current file at the time of invoking `current-file`".

Without the `current-` prefix, it might appear as `file` somewhere in code, without a clear indication that it is indeed a parameter (unless for some reason you also wanted to add a `parameter?` call into the mix, but you really don't).

**Requires** - try as best to constrain all `require` use to also have a `only-in` modifier on packages being imported. Without a `only-in` block, `require` will import all names/functions into our program, when we might only want a handful of functions.
