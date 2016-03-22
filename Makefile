#
# apt-file - APT package searching utility -- command-line interface
# Makefile
#

#DESTDIR=debian/apt-file

INSTALL=install

BINDIR=$(DESTDIR)/usr/bin
ETCDIR=$(DESTDIR)/etc/apt/apt.conf.d
MANDIR=$(DESTDIR)/usr/share/man/man1
COMPDIR=$(DESTDIR)/etc/bash_completion.d

all: man

install:
	$(INSTALL) -d -m 755 $(MANDIR)
	$(INSTALL) -m 644 apt-file.1 $(MANDIR)
#	$(INSTALL) -m 644 rapt-file.1 $(MANDIR)
	$(INSTALL) -d -m 755 $(BINDIR)
	$(INSTALL) -m 755 apt-file $(BINDIR)
	$(INSTALL) -d -m 755 $(ETCDIR)
	$(INSTALL) -m 644 50apt-file.conf $(ETCDIR)
#	$(INSTALL) -d -m 755 $(COMPDIR)
#	$(INSTALL) -m 644 apt-file.bash_completion $(COMPDIR)/apt-file

uninstall:
	rm -f $(BINDIR)/apt-file
	rm -f $(ETCDIR)/50apt-file.conf
	rm -f $(MANDIR)/apt-file.1
#	rm -f $(MANDIR)/rapt-file.1

man:
	pod2man apt-file.pod > apt-file.1
#	$(DOCBOOK2MAN) rapt-file.1.sgml

test:
	prove
	$(MAKE) -C tests-apt-file test

clean:
	rm -f *~ manpage.* apt-file.1 rapt-file.1 apt-file.fr.1
	$(MAKE) -C tests-apt-file clean
