# Use the FILE_BINARY=yes argument when running make in order to compile 
# projection.c so that it stores the output in a binary file.
# If the argument is not used, the projection algorithm will store the
# output in a text file in pgm format.
# Use the VOXEL_MODEL_RAW=yes argument when running make in order to 
# compile inputgeneration.c so that the output file doesn't include a 
# header.
# Both argument can be used at the same time.

ifeq ($(FILE_BINARY),yes)
	BINARY = -DBINARY
else
	BINARY =
endif

ifeq ($(VOXEL_MODEL_RAW),yes)
	VX_MODEL = -DRAW
else
	VX_MODEL =
endif


CFLAGS=-Wall -Wpedantic -std=c99 -fopenmp -I./source/

all: inputgeneration projector

inputgeneration: inputgeneration.c ./bin/voxel.o ./source/voxel.h
	gcc ${CFLAGS} $(VX_MODEL) inputgeneration.c ./bin/voxel.o -lm -o inputgeneration

./bin/voxel.o: ./source/voxel.c ./source/voxel.h bin
	gcc ${CFLAGS} -c ./source/voxel.c -o ./bin/voxel.o

projector: projector.c ./bin/projection.o ./source/projection.h
	gcc ${CFLAGS} $(BINARY) projector.c ./bin/projection.o -lm -o projector

./bin/projection.o: ./source/projection.h ./source/projection.c bin
	gcc ${CFLAGS} -I./source/ -c ./source/projection.c -o ./bin/projection.o

bin:
	-mkdir ./bin

.PHONY:	clean

clean:
	-rm projector inputgeneration ./bin/*.o
