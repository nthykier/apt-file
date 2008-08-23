TEST_PRG=../apt-file
TEST_SOURCE=./sources.list
TEST_CACHE=./cache

test:
	set -e ; for a in cache/*fooarch ; do gzip -c < $$a > $$a.gz ; done
	./runtests $(TEST_PRG) -s $(TEST_SOURCE) -c $(TEST_CACHE) -a fooarch

clean:
	rm -f cache/*.gz
