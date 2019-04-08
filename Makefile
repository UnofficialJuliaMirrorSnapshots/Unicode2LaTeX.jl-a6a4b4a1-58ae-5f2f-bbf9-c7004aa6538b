# vim: set ts=4 noexpandtab:

julia_cmd=julia --project
coverage=false

.PHONY: test
test: julia_cmd+=--check-bounds=yes
test:
	${julia_cmd} -e "using Pkg; Pkg.test(coverage=${coverage})"

.PHONY: coverage
coverage: coverage=true
coverage: test

.PHONY: instantiate
instantiate:
	${julia_cmd} -e "using Pkg; Pkg.instantiate()"

.PHONY: generate
generate:
	${julia_cmd} -e 'using Unicode2LaTeX; Unicode2LaTeX.generate(nowarn=true)'

.PHONY: clean
clean:
	find . -name '*.cov' | xargs -r rm
