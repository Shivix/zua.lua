SRC = zua.lua
PREFIX ?= /usr/local
INSTALL_DIR = $(PREFIX)/bin
INSTALL_TARGET = $(INSTALL_DIR)/zua

install:
	mkdir -p "$(DESTDIR)$(INSTALL_DIR)"
	cp $(SRC) $(DESTDIR)$(INSTALL_TARGET)
	chmod +x $(DESTDIR)$(INSTALL_TARGET)

install-completion:
	install -m 644 zua.fish $(HOME)/.config/fish/completions/zua.fish

.PHONY: install install-completion
