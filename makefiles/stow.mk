ARCH := $(shell uname -p)
ifeq ($(ARCH),i386)
	STOW_BIN := /usr/local/bin/stow
endif
ifeq ($(ARCH),arm)
	STOW_BIN := /opt/homebrew/bin/stow
endif

.PHONY: link
link:
	$(STOW_BIN) stow
	$(STOW_BIN) zsh
	$(STOW_BIN) tmux
	$(STOW_BIN) alacritty
	$(STOW_BIN) git
	$(STOW_BIN) starship
	$(STOW_BIN) nvim
