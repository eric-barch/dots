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
pkgs_all: pkgs_core pkgs_apps

$(BREW_BIN):
	[ -f $(BREW_BIN) ] || \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

.PHONY: pkgs_core
pkgs_core: $(BREW_BIN)
	$(MAKE) pkgs_antidote
	$(BREW_BIN) bundle --file=homebrew/Brewfile-core

ANTIDOTE := $(XDG_CONFIG_HOME)/antidote
.PHONY: pkgs_antidote
pkgs_antidote: $(ANTIDOTE)
$(ANTIDOTE): 
	git clone --depth=1 https://github.com/mattmc3/antidote.git $(XDG_CONFIG_HOME)/antidote

.PHONY: pkgs_apps
pkgs_apps: $(BREW_BIN)
	$(BREW_BIN) bundle --file=homebrew/Brewfile-apps
