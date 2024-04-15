ARCH := $(shell uname -p)
ifeq ($(ARCH),i386)
	STOW_BIN := /usr/local/bin/stow
endif
ifeq ($(ARCH),arm)
	STOW_BIN := /opt/homebrew/bin/stow
endif

PACKAGES := stow zsh tmux alacritty git starship nvim

.PHONY: link
link:
	# Create directories in XDG_CONFIG_HOME for each package
	$(foreach pkg,$(PACKAGES),\
		mkdir -p $(XDG_CONFIG_HOME)/$(pkg);\
	)

	# Stow each package into its respective directory
	$(foreach pkg,\
		$(PACKAGES),$(STOW_BIN) -t $(XDG_CONFIG_HOME)/$(pkg) $(pkg);\
	)
