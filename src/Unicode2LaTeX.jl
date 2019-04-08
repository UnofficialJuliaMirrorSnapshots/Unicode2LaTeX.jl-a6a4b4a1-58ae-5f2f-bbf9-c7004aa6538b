# vim: set ts=8 sw=4 sts=4 et:

module Unicode2LaTeX

export unicode2latex

# Mapping generated from the LaTeX distribution.
include("u2latex.jl")

unicode2latex(c::Char) = get(u2latex, c, string(c))
function unicode2latex(s::String)
    o = IOBuffer()
    for (i, c) in enumerate(s)
        write(o, unicode2latex(c))
    end
    String(take!(o))
end

function generate(;nowarn=false)
    nowarn || @warn "Do not call unless you are the package maintainer"
    texp       = "base/utf8ienc.dtx"
    (ver, tex) = mktempdir() do d
        cd(d) do
            run(`git clone --quiet https://github.com/latex3/latex2e.git`)
            cd("latex2e")
            ver = chomp(read(`git log --pretty='%h' -n 1 --no-merges $texp`,
                String))
            tex = read(texp, String)
            (ver, tex)
        end
    end
    mktemp() do p, f
        print(f, """
            # This file is programmatically generated, do not edit it!
            #   Generated from `$texp` from the LaTeX 2e source tree.
            #   Available under the LaTeX Project Public License (LPPL).
            #   File commit hash: $ver
            """)
        println(f, "const u2latex = Dict(")
        d = Dict{Char,String}()
        i = 1
        while true
            m = match(
                r"""
                \\DeclareUnicodeCharacter{
                        ([0-9A-Fa-f]+)
                    }{
                        ((?:[^{}]|(?R))+)
                    }
                """x,
                tex, i)
            m !== nothing || break
            i = last(m.offsets)
            c = Char(parse(Int, m[1], base=16))
            # Remove redefinition protection.
            s = replace(m[2], "@tabacckludge" => "")
            haskey(d, c) == ((c => s) in d) || error("Multiple mappings: $c")
            d[c] = s
            println(f, "    $(:($c => $s)),")
        end
        println(f, ")")
        close(f)
        cp(p, "$(dirname(@__FILE__))/u2latex.jl", force=true)
        length(d)
    end
end

end # module
