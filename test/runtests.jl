# vim: set ts=8 sw=4 sts=4 et:

using Unicode2LaTeX, Test

@testset "Unicode2LaTeX" begin

@testset "Conversion" begin

@test unicode2latex('a')   == "a"
@test unicode2latex('¥')   == "\\textyen"
@test unicode2latex("Foo") == "Foo"
@test unicode2latex("Föö") == "F\\\"o\\\"o"

end #testset

@testset "Generation" begin

@test Unicode2LaTeX.generate(nowarn=true) > 0

end #testset

@testset "LaTeX" begin

mktempdir() do d
    cd(d) do
        for s in values(Unicode2LaTeX.u2latex)
            # Bruteforce output encoding, can not be known in advance.
            t = false
            for e in ("T1", "X2", "T2B", "T2C", "OT2")
                p = open(`latex`, "w", devnull)
                println(p.in, """
                \\documentclass{article}

                \\usepackage[$e]{fontenc}
                % Additional text symbol support.
                \\usepackage{textcomp}

                \\begin{document}

                $s

                \\end{document}
                """)
                close(p.in)
                wait(p)
                t = p.exitcode == 0
                !t || break
            end
            @test t
        end
    end
end

end #testset

end #testset
