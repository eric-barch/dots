include makefiles/pkgs.mk
include makefiles/stow.mk

# Check XDG_CONFIG_HOME and set if not defined
XDG_CONFIG_HOME ?= $(HOME)/.config

export XDG_CONFIG_HOME

setup:
	$(MAKE) pkgs_all
	$(MAKE) link
