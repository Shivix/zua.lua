SRC = zua.lua
INSTALL_DIR = /usr/local/bin/
INSTALL_TARGET = $(INSTALL_DIR)$(notdir zua)

install:
	cp $(SRC) $(INSTALL_TARGET)
	chmod +x $(INSTALL_TARGET)
	install -m 644 zua.fish /usr/share/fish/completions/zua.fish

.PHONY: install
