# Makefile
CC=gcc-4.6
EXECUTABLE= algo_peintre
SRCS= algo_peintre.adb machine_seq.adb off_file.adb off_struct.adb ps_file.adb tri_packet.adb
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

# gestion des dépendances
ps_file.o: machine_seq.o
algo_peintre.o: off_file.o
algo_peintre.o machine_seq.o off_file.o ps_file.o tri_packet.o: off_struct.o
algo_peintre.o: ps_file.o
algo_peintre.o: tri_packet.o

# recopie des dépendances précédentes avec les .ali au lieu des .o
ps_file.ali: machine_seq.ali
algo_peintre.ali: off_file.ali
algo_peintre.ali machine_seq.ali off_file.ali ps_file.ali tri_packet.ali: off_struct.ali
algo_peintre.ali: ps_file.ali
algo_peintre.ali: tri_packet.ali
