AS_ARM = /usr/bin/arm-linux-gnu-as
LD_ARM = /usr/bin/arm-linux-gnu-ld
CFLAGS = -march=armv2a -mno-thumb-interwork -Wall -O1
LD_FLAGS = -Bstatic -fix-v4bx

all : add

bt : test_bt.o
	${LD_ARM} ${LD_FLAGS} -T sections.lds -o test_bt test_bt.o

test_bt.o : test_bt.s
	${AS_ARM} -c test_bt.s -o test_bt.o

add : test_add.o
	${LD_ARM} ${LD_FLAGS} -T sections.lds -o test_add test_add.o

test_add.o : test_add.s
	${AS_ARM} -c test_add.s -o test_add.o

clean :
	rm -f test_add *.o
	rm -f test_bt *.o
