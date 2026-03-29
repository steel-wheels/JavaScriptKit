#
# Makefile
#

srcs		=  math.ts
dsts		=  $(srcs:.ts=.js)
bltdecls	=  types/log.d.ts \
		   types/URL.d.ts \
		   types/Environment.d.ts \
		   types/FileHandle.d.ts \
		   types/FileInterface.d.ts \
		   types/Process.d.ts \
		   types/isUndefined.d.ts
tsdecls		=  $(addprefix types/, $(srcs:.ts=.d.ts))

dstlib  = Library.js
bltdecl	= ./types/BuiltinLibrary.d.ts
dstdecl	= ./types/Library.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2024 --lib "es2024" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty


%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(bltdecl) $(dstlib) $(dstdecl)

$(dstlib): $(dsts)
	cat $(dsts) > $@

$(bltdecl): $(bltdecls)
	cat $(bltdecls) > $@

$(dstdecl): $(bltdecl) $(tsdecls)
	cat $(bltdecl) $(tsdecls) > $@

clean:
	rm -f $(bltdecl) $(dstdecl)

