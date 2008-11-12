TEST_PRG=../apt-file
TEST_SOURCE=./sources.list
TEST_CACHE=./cache
TEST_CONFIG=../apt-file.conf

test:
	set -e ; for a in cache/*fooarch ; do gzip -c < $$a > $$a.gz ; done
	./runtests APT_FILE_CONFIG=$(TEST_CONFIG) $(TEST_PRG) -s $(TEST_SOURCE) -c $(TEST_CACHE) -a fooarch

clean:
	rm -f cache/*.gz
