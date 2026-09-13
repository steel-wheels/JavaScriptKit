jsrun	= ~/local/bin/jsrun

all: tool 
	$(jsrun) hello.js

tool: dummy
	@if [ ! -f $(jsrun) ] ; then \
		echo "[Error] No jsrun command" >&2 ; \
	fi

dummy:


