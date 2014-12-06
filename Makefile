# Makefile
CC=gcc
EXECUTABLES= algo_peintre algo_peintre_perf
OBJS= ${SRCS:.adb=.o}
ALIS= ${SRCS:.adb=.ali}

all:
	gnatmake $(EXECUTABLES)

clean:
	gnatclean $(EXECUTABLES)

.PHONY: all clean
