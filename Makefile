# Detect running user
ifeq ($(shell id -u), 0)
    PREFIX ?= /usr/local
else
    PREFIX ?= $(HOME)/.local
endif

BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1

.PHONY: all install update uninstall

all:
	@echo "Nothing to compile. Use 'make install', 'make update', or 'make uninstall'."

install:
	@echo "Installing to $(PREFIX)..."
	mkdir -p $(BINDIR)
	mkdir -p $(MANDIR)
	cp sanbox $(BINDIR)/sanbox
	chmod +x $(BINDIR)/sanbox
	cp sanbox.1 $(MANDIR)/sanbox.1
	chmod 644 $(MANDIR)/sanbox.1
	@echo "Updating manual database (mandb)..."
	-mandb -q 2>/dev/null || true
	@echo "Installation complete!"

update: install

uninstall:
	@echo "Uninstalling from $(PREFIX)..."
	rm -f $(BINDIR)/sanbox
	rm -f $(MANDIR)/sanbox.1
	@echo "Updating manual database (mandb)..."
	-mandb -q 2>/dev/null || true
	@echo "Uninstallation complete!"
