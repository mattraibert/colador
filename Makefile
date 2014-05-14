EXECUTABLE=$(BINDIR)/colador
DEPS=mattraibert/snap-testing \
	snapframework/snap-core snapframework/heist snapframework/snap-server \
	snapframework/snap-loader-static snapframework/snap \
	mattraibert/snap-loader-dynamic mattraibert/snaplet-persistent
TESTMAIN=src/Test/Main.hs
INSTALLFLAGS=-j -fdevelopment
MOODEVEL=-c devel.cfg
MOOTEST=-c test.cfg

EXEC=cabal exec --
RUN=$(EXEC) runghc -isrc
BINDIR=.cabal-sandbox/bin
BUILDDIR=dist
SOURCES=$(shell find src -type f -iname '*.hs')
DEPDIR=deps
SHELL=/bin/bash

.PHONY: all install clean superclean test init deps sandbox tags confirm \
	dbup dbtest dbnew dbrevert

all: init install test tags

install: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCES)
	cabal install $(INSTALLFLAGS)

test:
	$(RUN) $(TESTMAIN)

run: $(EXECUTABLE)
	$(EXECUTABLE)

clean:
	rm -rf $(BUILDDIR) $(EXECUTABLE)

superclean: confirm clean
	rm -rf $(DEPDIR) .cabal-sandbox/ cabal.sandbox.config TAGS

confirm:
	@read -r -p "Are you sure? [y/N] " CONTINUE; \
	[[ ! $$CONTINUE =~ ^[Yy]$$ ]] && exit 1; echo "Continuing...";

init: sandbox deps

deps: $(patsubst %, $(DEPDIR)/%.d, $(DEPS)) $(DEPDIR)/digestive-functors

$(DEPDIR)/digestive-functors:
	git clone git@github.com:mattraibert/digestive-functors.git $@
	cabal sandbox add-source $(DEPDIR)/digestive-functors/digestive-functors-snap
	cabal sandbox add-source $(DEPDIR)/digestive-functors/digestive-functors-heist

$(DEPDIR)/%.d:
	git clone git@github.com:$*.git $@
	cabal sandbox add-source $@


sandbox: cabal.sandbox.config

cabal.sandbox.config:
	cabal sandbox init


tags: TAGS

TAGS: $(SOURCES)
	$(EXEC) haskdogs -e


dbconsole:
	PGPASSWORD=123 psql colador_devel -U colador -h localhost

dbup:
	moo upgrade $(MOODEVEL)
	moo upgrade $(MOOTEST)

dbtest:
	moo test $(MOODEVEL) $(MIGRATION)
	moo test $(MOOTEST) $(MIGRATION)

dbnew:
	moo new $(MOODEVEL) $(MIGRATION)

dbrevert:
	moo revert $(MOODEVEL) $(MIGRATION)
	moo revert $(MOOTEST) $(MIGRATION)
