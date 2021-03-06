# local compiler stuff
LCC = clang
LCXX = clang++

# local stuff
C_FLAGS = `llvm-config --cflags` -Wall -Iincludes/ -g
LLVM_FLAGS = `llvm-config --libs --cflags --ldflags core analysis executionengine jit interpreter native`
LLVM_VERSION = $(shell llvm-config --version | grep ^llvm-version | sed 's/^.* //g')

ifeq "$(LLVM_VERSION)" "3.5"
	LLVM_FLAGS += -lz -lncurses
endif

TRAVIS_FLAGS = -ldl -ltinfo -pthread
SOURCES = src/*.c

BUILD_COMMAND =

ifeq ($(CC),gcc)
	BUILD_COMMAND = g++ *.o ${LLVM_FLAGS} -o j4
else
	BUILD_COMMAND = ${CC}++ *.o ${LLVM_FLAGS} -o j4
endif

all: ${SOURCES}
	${LCC} ${C_FLAGS} ${SOURCES} -c ${SOURCES}
	${LCXX} *.o ${LLVM_FLAGS} -o j4 
	-rm *.o

travis: ${SOURCES}
	${CC} ${C_FLAGS} ${SOURCES} -c ${SOURCES}
	${BUILD_COMMAND} ${TRAVIS_FLAGS}
	-rm *.o

clean:
	-rm *.o

.PHONY: clean
