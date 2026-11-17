.PHONY: lint
lint:
	for script in scripts/*.sh herdr/bin/*.sh; do bash -n "$$script" || exit 1; done
	shellcheck $$(find scripts herdr -name '*.sh')
	jq empty iterm2.json omp/prompt.omp.json
	zsh -n zshrc
	zsh -n zprofile
