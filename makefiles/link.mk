ARCH := $(shell uname -p)
ifeq ($(ARCH),i386)
	STOW_BIN := /usr/local/bin/stow
endif
ifeq ($(ARCH),arm)
	STOW_BIN := /opt/homebrew/bin/stow
endif

# Set XDG_CONFIG_HOME if not already defined
XDG_CONFIG_HOME ?= $(HOME)/.config
export XDG_CONFIG_HOME

# List directories to copy into XDG_CONFIG_HOME
DIRS := $(notdir $(patsubst %/,%,$(wildcard */)))
PACKAGES := $(filter-out .git makefiles, $(DIRS))

.PHONY: link
link:
	# Create corresponding directories in XDG_CONFIG_HOME
	$(foreach pkg,$(PACKAGES),\
		mkdir -p $(XDG_CONFIG_HOME)/$(pkg);\
	)

	# Symlink directories in pwd to corresponding in XDG_CONFIG_HOME
	$(foreach pkg,$(PACKAGES),\
		$(STOW_BIN) -t $(XDG_CONFIG_HOME)/$(pkg) $(pkg);\
	)
