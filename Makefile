.PHONY: lint
lint:
	for script in scripts/*.sh herdr/bin/*.sh bin/wt; do bash -n "$$script" || exit 1; done
	shellcheck $$(find scripts herdr bin -name '*.sh')
	jq empty iterm2.json omp/prompt.omp.json
	zsh -n zshrc
	zsh -n zprofile
