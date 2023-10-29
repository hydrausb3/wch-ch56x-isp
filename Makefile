# SPDX-License-Identifier: GPL-2.0-only
VERSION = 0.3.0

# Install paths
PREFIX = /usr/local

# Flags
CPPFLAGS = -DVERSION=\"$(VERSION)\"

ifeq ($(OS), Windows_NT)
CFLAGS = -Wall -O2 `pkg-config --cflags libusb-1.0` $(INCLUDES)
LDFLAGS = -L/mingw64/lib -I/mingw64/include/libusb-1.0 -lusb-1.0
else
CFLAGS = -Wall -O2 `pkg-config --cflags libusb-1.0` $(INCLUDES)
LDFLAGS = `pkg-config --libs libusb-1.0`
endif

SRC = wch-ch56x-isp.c ./cargs/src/cargs.c
HDR = ./cargs/include/cargs.h devices.h
OBJ = $(SRC:.c=.o)
BIN = wch-ch56x-isp
DISTFILES = $(SRC) $(HDR) Makefile

INCLUDES = \
  -I"./cargs/include"

all: $(BIN)

$(OBJ): ./cargs/include/cargs.h devices.h

$(BIN): $(OBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f $(BIN) $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/$(BIN)

uninstall:
	rm -vf $(DESTDIR)$(PREFIX)/bin/$(BIN)

dist:
	mkdir -p $(BIN)-$(VERSION)
	cp $(DISTFILES) $(BIN)-$(VERSION)
	tar -cf $(BIN)-$(VERSION).tar $(BIN)-$(VERSION)
	gzip $(BIN)-$(VERSION).tar
	rm -rf $(BIN)-$(VERSION)

clean:
	rm -f $(OBJ) $(BIN)

.PHONY: all install uninstall dist clean
