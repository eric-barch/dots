include makefiles/pkgs.mk
include makefiles/stow.mk

setup:
	$(MAKE) pkgs_all
	$(MAKE) link
