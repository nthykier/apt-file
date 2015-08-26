TEST_PRG=../apt-file
export TEST_DIR=$(CURDIR)

test:
	set -e ; for a in cache/*fooarch ; do gzip -c < $$a > $$a.gz ; done
	PATH=$(CURDIR)/bin:$$PATH ./runtests $(TEST_PRG) -a fooarch

clean:
	rm -f cache/*.gz
