#
# apt-file - APT package searching utility -- command-line interface
# Makefile
#

#DESTDIR=debian/apt-file

INSTALL=install
DOCBOOK2MAN=docbook2man

BINDIR=$(DESTDIR)/usr/bin
ETCDIR=$(DESTDIR)/etc/apt
MANDIR=$(DESTDIR)/usr/share/man/man1
COMPDIR=$(DESTDIR)/etc/bash_completion.d

all:

install:
	$(INSTALL) -d -m 755 $(MANDIR)
	$(INSTALL) -m 644 apt-file.1 $(MANDIR)
	$(INSTALL) -d -m 755 $(BINDIR)
	$(INSTALL) -m 755 apt-file $(BINDIR)
	$(INSTALL) -d -m 755 $(ETCDIR)
	$(INSTALL) -m 644 apt-file.conf $(ETCDIR)
	$(INSTALL) -d -m 755 $(COMPDIR)
	$(INSTALL) -m 644 apt-file.bash_completion $(COMPDIR)/apt-file

uninstall:
	rm -f $(BINDIR)/apt-file
	rm -f $(ETCDIR)/apt-file.conf
	rm -f $(MANDIR)/apt-file.1

man:
	$(DOCBOOK2MAN) apt-file.1.sgml

clean:
	rm -f *~ manpage.*
