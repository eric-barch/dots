include makefiles/pkgs.mk
include makefiles/link.mk

# Check XDG_CONFIG_HOME and set if not defined
XDG_CONFIG_HOME ?= $(HOME)/.config

export XDG_CONFIG_HOME

setup:
	$(MAKE) pkgs
	$(MAKE) link
