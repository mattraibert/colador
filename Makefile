EXECUTABLE=$(BINDIR)/colador
DEPS=Soostone/groundhog-utils dbp/snap-testing
TESTMAIN=src/Test/Main.hs
INSTALLFLAGS=-j -fdevelopment

EXEC=cabal exec --
RUN=$(EXEC) runghc -isrc
BINDIR=.cabal-sandbox/bin
BUILDDIR=dist
SOURCES=$(shell find src -type f -iname '*.hs')
DEPDIR=deps

.PHONY: all install clean superclean test init deps sandbox tags

all: init install test tags run

install: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCES)
	cabal install $(INSTALLFLAGS)

test:
	$(RUN) $(TESTMAIN)

run: $(EXECUTABLE)
	$(EXECUTABLE)

clean:
	rm -rf $(BUILDDIR) $(EXECUTABLE)

superclean: clean
	rm -rf $(DEPDIR) .cabal-sandbox/ cabal.sandbox.config TAGS

init: deps sandbox


deps: $(patsubst %, $(DEPDIR)/%.d, $(DEPS))

$(DEPDIR)/%.d: sandbox
	git clone git@github.com:$*.git $@
	cabal sandbox add-source $@


sandbox: cabal.sandbox.config

cabal.sandbox.config:
	cabal sandbox init


tags: TAGS

TAGS: $(SOURCES)
	$(EXEC) haskdogs -e