# Determine architecture and set STOW_BIN accordingly
ARCH := $(shell uname -p)
ifeq ($(ARCH),i386)
	STOW_BIN := /usr/local/bin/stow
endif
ifeq ($(ARCH),arm)
	STOW_BIN := /opt/homebrew/bin/stow
endif

# Export environment variables if not already defined
XDG_CONFIG_HOME ?= $(HOME)/.config
export XDG_CONFIG_HOME

BIN_HOME ?= $(HOME)/.local/bin
export BIN_HOME

# List directories excluding specific folders
DIRS := $(notdir $(patsubst %/,%,$(wildcard */)))
PACKAGES := $(filter-out bin .git makefiles, $(DIRS))

.PHONY: link
link: link-bin link-configs

.PHONY: link-bin
link-bin:
	# Create directory in BIN_HOME and symlink the 'bin' directory
	mkdir -p $(BIN_HOME)
	$(STOW_BIN) -t $(BIN_HOME) bin

.PHONY: link-configs
link-configs:
	# Create and symlink directories for configurations
	$(foreach pkg,$(PACKAGES),\
		mkdir -p $(XDG_CONFIG_HOME)/$(pkg) && \
		$(STOW_BIN) -t $(XDG_CONFIG_HOME)/$(pkg) $(pkg);\
	)
