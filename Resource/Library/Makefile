#
# Makefile
#

srcs	=  Env.ts
dsts	=  $(srcs:.ts=.js)
decls	=  types/log.d.ts \
	   types/isUndefined.d.ts \
	   types/EnvCore.d.ts \
	   types/FileHandle.d.ts \
	   types/FileInterface.d.ts

dstlib  = Library.js
dstdecl	= ./types/Library.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2024 --lib "es2024" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty


%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(dstdecl) $(dstlib)

$(dstlib): $(dsts)
	cat $(dsts) > $@

$(dstdecl): $(decls)
	cat $(decls) > $(dstdecl)

clean:
	rm -f $(dstdecl)

#	(cd types && rm -f $(decls))

