#
# Makefile
#

boot	= Boot.ts

srcs	=  Console.ts
types	=  types/FraeCore.d.ts

dsts	=  $(srcs:.ts=.js)
decls	=  $(srcs:.ts=.d.ts)

dstlib  = Library.js
dstdecl	= ./types/Library.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2024 --lib "es2024" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty


%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: lib boot

lib: $(dstlib)

boot: $(boot:.ts=.js)

$(dstlib): $(dsts)
	cat $(dsts) > $@

clean:
	rm -f $(dsts) $(boot:.ts=.js)
	(cd types && rm -f $(decls))

