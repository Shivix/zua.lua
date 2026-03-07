SRC = zua.lua
INSTALL_DIR = /usr/local/bin/
INSTALL_TARGET = $(INSTALL_DIR)$(notdir zua.lua)

FISH_COMPLETION_DIR = $(HOME)/.config/fish/completions/

install:
	cp $(SRC) $(INSTALL_TARGET)
	chmod +x $(INSTALL_TARGET)
	
install-completion:
	install -m 644 completion.fish "$(FISH_COMPLETION_DIR)lus.fish"

.PHONY: install install-completion
