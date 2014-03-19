all:
	cabal install -fdevelopment && ./.cabal-sandbox/bin/colador

autotest:
	runghc -no-user-package-db -package-db=.cabal-sandbox/x86_64-linux-ghc-7.6.3-packages.conf.d -isrc src/TestRunner.hs

test:
	runghc -no-user-package-db -package-db=.cabal-sandbox/x86_64-linux-ghc-7.6.3-packages.conf.d -isrc src/Test.hs