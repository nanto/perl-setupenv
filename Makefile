GIT = git

all:

deps:

git-submodules:
	$(GIT) submodule update --init

## ------ Build ------

lib/perl58perlbrewdeps.pm: Makefile
	echo 'BEGIN {' > $@
	echo '$$INC{"Module/Pluggable.pm"} = 1;' >> $@
	echo '$$INC{"Module/Pluggable/Object.pm"} = 1;' >> $@
	echo '$$INC{"Devel/InnerPackage.pm"} = 1;' >> $@
	echo '}' >> $@
	cat lib/IPC/Cmd.pm >> $@
	curl http://cpansearch.perl.org/src/SIMONW/Module-Pluggable-4.7/lib/Module/Pluggable.pm >> $@
	curl http://cpansearch.perl.org/src/SIMONW/Module-Pluggable-4.7/lib/Module/Pluggable/Object.pm >> $@
	curl http://cpansearch.perl.org/src/SIMONW/Module-Pluggable-4.7/lib/Devel/InnerPackage.pm >> $@

## ------ Tests ------

PROVE = prove

test: test-deps test-startproxy test-main test-stopproxy

test-deps: git-submodules deps test-proxy-deps

test-proxy-deps:
	perl bin/pmbp.pl \
	    --root-dir-name t_deps/modules/perl-anyevent-httpserver \
	    --install-modules-by-list \
	    --write-libs-txt t_deps/modules/perl-anyevent-httpserver/config/perl/libs.txt

test-startproxy:
	PERL5LIB="`cat t_deps/modules/perl-anyevent-httpserver/config/perl/libs.txt`" sh t_deps/bin/proxy.sh &

test-stopproxy:
	-kill `cat t_deps/proxy.pid`
	-rm t_deps/proxy.pid

test-main:
ifeq "$(TARGET)" ""
	http_proxy=http://localhost:16613 $(PROVE) --verbose t/*/*.t
endif
ifeq "$(TARGET)" "normal"
	http_proxy=http://localhost:16613 $(PROVE) -j1 --verbose t/pmbp/*.t
endif
ifeq "$(TARGET)" "install-1"
	http_proxy=http://localhost:16613 $(PROVE) -j1 --verbose t/pmbp-install-1/*.t
endif
ifeq "$(TARGET)" "update"
	http_proxy=http://localhost:16613 $(PROVE) -j1 --verbose t/pmbp-update/*.t
endif
ifeq "$(TARGET)" "lists"
	http_proxy=http://localhost:16613 $(PROVE) -j1 --verbose t/pmbp-lists/*.t
endif
ifeq "$(TARGET)" "env"
	http_proxy=http://localhost:16613 $(PROVE) -j1 --verbose t/pmbp-env/*.t
endif
ifeq "$(TARGET)" "scan"
	http_proxy=http://localhost:16613 $(PROVE) -j1 --verbose t/pmbp-scan/*.t
endif
ifeq "$(TARGET)" "perl"
	http_proxy=http://localhost:16613 $(PROVE) --verbose t/pmbp-perl/*.t
endif
ifeq "$(TARGET)" "imagemagick"
	http_proxy=http://localhost:16613 $(PROVE) --verbose t/pmbp-imagemagick/*.t
endif
ifeq "$(TARGET)" "apache"
	http_proxy=http://localhost:16613 $(PROVE) --verbose t/pmbp-apache/*.t
endif
ifeq "$(TARGET)" "modperl"
	http_proxy=http://localhost:16613 $(PROVE) --verbose t/pmbp-modperl/*.t
endif
ifeq "$(TARGET)" "mecab"
	http_proxy=http://localhost:16613 $(PROVE) --verbose t/pmbp-mecab/*.t
endif
ifeq "$(TARGET)" "rrdtool"
	http_proxy=http://localhost:16613 $(PROVE) --verbose t/pmbp-rrdtool/*.t
endif
ifeq "$(TARGET)" "svn"
	http_proxy=http://localhost:16613 $(PROVE) --verbose t/pmbp-svn/*.t
endif
