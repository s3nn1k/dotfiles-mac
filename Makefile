.PHONY: lint
lint:
	for script in scripts/*.sh bin/*.sh bin/wt; do bash -n "$$script" || exit 1; done
	zsh -n zshrc
	zsh -n zprofile
