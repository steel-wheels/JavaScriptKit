#
# Makefile
#

include ../Makefile.inc

srcfiles	= TextColor.ts \
		  Console.ts \
		  ThreadFunc.ts \
		  ProcessFunc.ts \
		  math.ts
initfiles	= SetupLibrary.ts
extdecls	= types/URL.d.ts \
		  types/EnvVariables.d.ts \
		  types/FileHandle.d.ts \
		  types/Process.d.ts \
		  types/Thread.d.ts \
		  types/isUndefined.d.ts
dstfiles	= $(srcfiles:.ts=.js)
dstinits	= $(initfiles:.ts=.js)
srcdecls	= $(srcfiles:.ts=.d.ts)
dstlib  	= Library.js
dstdecl		= types/Library.d.ts

all:	$(dstlib) $(dstdecl) $(dstinits)

clean:
	rm -f $(dstfiles) $(dstlib)

$(dstlib): $(dstfiles)
	cat $(dstfiles) > $@

$(dstdecl): dummy
	cat $(extdecls) > $@
	(cd types ; cat $(srcdecls)) >> $@

dummy:

