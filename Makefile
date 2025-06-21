SRC = zua.lua
INSTALL_DIR = /usr/local/bin/
INSTALL_TARGET = $(INSTALL_DIR)$(notdir zua)

install:
	cp $(SRC) $(INSTALL_TARGET)
	chmod +x $(INSTALL_TARGET)

.PHONY: install
