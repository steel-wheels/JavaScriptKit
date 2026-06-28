#
# Makefile
#

include ../Makefile.inc

srcfiles	= TextColor.ts \
		  Console.ts \
		  math.ts
extdecls	= types/URL.d.ts \
		  types/EnvVariables.d.ts \
		  types/FileHandle.d.ts \
		  types/Process.d.ts \
		  types/isUndefined.d.ts
dstfiles	= $(srcfiles:.ts=.js)
srcdecls	= $(srcfiles:.ts=.d.ts)
dstlib  	= Library.js
dstdecl		= types/Library.d.ts

all:	$(dstlib) $(dstdecl)

clean:
	rm -f $(dstfiles) $(dstlib)

$(dstlib): $(dstfiles)
	cat $(dstfiles) > $@

$(dstdecl): dummy
	(cd types ; cat $(srcdecls)) > $@
	cat $(extdecls) >> $@

dummy:

#srcs		=  math.ts
#dsts		=  $(srcs:.ts=.js)
#bltdecls	=  types/log.d.ts \
#tsdecls		=  $(addprefix types/, $(srcs:.ts=.d.ts))
#
#bltdecl	= ./types/BuiltinLibrary.d.ts
#dstdecl	= ./types/Library.d.ts
#
#
#
#
#all: $(bltdecl) $(dstlib) $(dstdecl)
#
#$(dstlib): $(dsts)
#	cat $(dsts) > $@
#
#$(bltdecl): $(bltdecls)
#	cat $(bltdecls) > $@
#
#$(dstdecl): $(bltdecl) $(tsdecls)
#	cat $(bltdecl) $(tsdecls) > $@
#
#clean:
#	rm -f $(bltdecl) $(dstdecl)
#
