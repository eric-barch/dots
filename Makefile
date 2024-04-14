include makefiles/pkgs.mk
include makefiles/stow.mk

# Check and set XDG_CONFIG_HOME if not already defined
XDG_CONFIG_HOME ?= $(HOME)/.config

export XDG_CONFIG_HOME

setup:
	$(MAKE) pkgs_all
	$(MAKE) link