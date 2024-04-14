.PHONY: pkgs_all
pkgs_all:
	$(MAKE) pkgs_core
	$(MAKE) pkgs_apps

.PHONY: pkgs_core
	pkgs_core:
		$(MAKE) pkgs_antidote
		$(MAKE) pkgs_core

.PHONY: pkgs_apps
	pkgs_apps:
		$(MAKE) pkgs_apps
