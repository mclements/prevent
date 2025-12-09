

ini:
	lazbuild Prevent.lpr
	@echo Warning: default Prevent.ini assumes Linux
	cp Prevent.ini lib/x86_64-linux/
