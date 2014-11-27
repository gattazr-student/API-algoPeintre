# Makefile
CC=gcc-4.6
EXECUTABLE= algo_peintre
SRCS= algo_peintre.adb off_file.adb off_struct.adb ps_file.adb tri_packet.adb
OBJS= ${SRCS:.adb=.o}
ALIS= ${SRCS:.adb=.ali}

all: $(EXECUTABLE)

algo_peintre: $(OBJS) $(ALIS)
	gnatbind -x algo_peintre.ali
	gnatlink algo_peintre.ali

%.o: %.adb
	$(CC) -c $<

%.ali: %.adb
	$(CC) -c $<

clean:
	rm -vf $(OBJS) $(ALIS)

mrproper: clean
	rm -vf $(EXECUTABLE)

.PHONY: all clean mrproper
