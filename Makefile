SRC = zua.lua
PREFIX ?= /usr/local
INSTALL_TARGET = $(PREFIX)/bin/zua

install:
	cp $(SRC) $(INSTALL_TARGET)
	chmod +x $(INSTALL_TARGET)

install-completion:
	install -m 644 zua.fish $(HOME)/.config/fish/completions/zua.fish

.PHONY: install install-completion
