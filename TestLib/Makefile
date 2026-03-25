#
#
#

tsc	= npx tsc
tsc_opt	= -t ES2018 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty

src	= test.ts
dst	= $(src:.ts=.js)

%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: lib $(dst)

clean:
	rm -f $(dst) types/Library.d.ts

lib: types/Library.d.ts

types/Library.d.ts: ../Resource/Library/types/Library.d.ts 
	(cd ../Resource/Library/ && make)
	cp $< $@

