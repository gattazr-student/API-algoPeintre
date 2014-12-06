# Makefile
CC=gcc-4.6
EXECUTABLES= algo_peintre algo_peintre_perf algo_peintre_mem
OBJS= ${SRCS:.adb=.o}
ALIS= ${SRCS:.adb=.ali}

all:
	gnatmake $(EXECUTABLES)

clean:
	gnatclean $(EXECUTABLES)

.PHONY: all clean
