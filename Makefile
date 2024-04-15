include makefiles/pkgs.mk
include makefiles/link.mk

# Check XDG_CONFIG_HOME and set if not defined
XDG_CONFIG_HOME ?= $(HOME)/.config

export XDG_CONFIG_HOME

# Initialize git submodules
submodules:
	git submodule update --init

# Install packages and symlink to XDG_CONFIG_HOME
setup: submodules
	$(MAKE) pkgs
	$(MAKE) link
