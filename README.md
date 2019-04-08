**Unicode2LaTeX** is a tiny [Julia][julia] library for mapping
[Unicode][unicode] characters to their corresponding [LaTeX][latex]-internal
form. While modern TeX engines have Unicode support, passing pure [ASCII][ascii]
data is a safer option when programmatically generating content to be consumed
by a TeX engine not under your control.

[julia]:   https://julialang.org/
[unicode]: https://en.wikipedia.org/wiki/Unicode 
[latex]:   https://en.wikipedia.org/wiki/LaTeX
[ascii]:   https://en.wikipedia.org/wiki/ASCII

# Installation

Simply use the Julia package manager:

```julia
    add Unicode2LaTeX
```

# Usage

Unicode2LaTeX exports a single function that maps strings and characters to
their corresponding LaTeX-internal form:

```julia
    using Unicode2LaTeX

    unicode2latex('ö') # => "\\\"o"
    unicode2latex("Kurt Gödel") # => "Kurt G\\\"odel"
```

Do note that ASCII characters are left in place, as TeX already knows how to
interpret them.

# Extracurricular reading

To produce this library it was necessary to go deep down a rabbit hole of LaTeX
internals. If you also want to find out what lurks in the depths of LaTeX input
encoding and font output encoding, you may find the following documents useful:

1. [“Providing some UTF-8 support via inputenc”][utf8ienc]
2. [“LaTeX font encodings”][encguide]
3. [“Cyrillic languages support in LaTeX”][cyrguide]

[utf8ienc]: http://tug.ctan.org/macros/latex/base/utf8ienc.pdf
[encguide]: https://www.latex-project.org/help/documentation/encguide.pdf
[cyrguide]: https://www.latex-project.org/help/documentation/cyrguide.pdf
