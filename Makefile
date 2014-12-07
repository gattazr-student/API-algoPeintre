# Makefile
EXECUTABLES= algo_peintre algo_peintre_perf

all:
	gnatmake $(EXECUTABLES)

clean:
	gnatclean $(EXECUTABLES)

.PHONY: all clean
