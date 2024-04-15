include makefiles/pkgs.mk
include makefiles/link.mk

# Initialize git submodules
submodules:
	git submodule update --init

# Install packages and symlink to XDG_CONFIG_HOME
setup: submodules
	$(MAKE) pkgs
	$(MAKE) link
