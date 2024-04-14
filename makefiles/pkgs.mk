ARCH := $(shell uname -p)
ifeq ($(ARCH),i386)
	BREW_PREFIX := /usr/local/
	BREW_BIN := /usr/local/bin/brew
endif
ifeq ($(ARCH),arm)
	BREW_PREFIX := /opt/homebrew
	BREW_BIN := /opt/homebrew/bin/brew
endif

.PHONY: pkgs_all
pkgs_all: pkgs_core pkgs_apps pkgs_fzf

$(BREW_BIN):
	[ -f $(BREW_BIN) ] || \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

.PHONY: pkgs_core
pkgs_core: $(BREW_BIN)
	$(MAKE) pkgs_antidote
	$(BREW_BIN) bundle --file=homebrew/Brewfile-core

.PHONY: pkgs_apps
pkgs_apps: $(BREW_BIN)
	$(BREW_BIN) bundle --file=homebrew/Brewfile-apps

.PHONY: pkgs_fzf
pkgs_fzf: $(BREW_BIN)
	# Brew-specific extra steps
	[ -f $(HOME)/.fzf.zsh ] || ($(BREW_PREFIX)/opt/fzf/install; rm ~/.fzf.bash)
