#
#
#

lib_dir = ../../Resource/Library

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

types/Library.d.ts: $(lib_dir)/types/Library.d.ts 
	(cd $(lib_dir) && make)
	cp $< $@

