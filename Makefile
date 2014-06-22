
CC = gcc 
CFLAGS = -g 

OBJs = parse.tab.o symtab.o attr.o lex.yy.o 

EXAMPLEOBJ = multcount_parse.tab.o symtab.o attr.o lex.yy.o

default: parser

multcount: ${EXAMPLEOBJ} #example about multcount
	${CC} ${CFLAGS} ${EXAMPLEOBJ} -o multcount

parser: ${OBJs}
	${CC} ${CFLAGS} ${OBJs} -o parser

lex.yy.c: scan.l parse.tab.h multcount_parse.tab.h attr.h
	flex -i scan.l

parse.tab.c: parse.y attr.h symtab.h
	bison -dv parse.y

multcount_parse.tab.c: multcount_parse.y multcount_attr.h symtab.h
	bison -dv multcount_parse.y -o multcount_parse.tab.c

parse.tab.h: parse.tab.c

multcount_parse.tab.h: multcount_parse.tab.c

clean:
	rm -f parser lex.yy.c *.o parse.tab.[ch] multcount_parse.tab.[ch] parse.output

depend:
	makedepend -I. *.c

# DO NOT DELETE THIS LINE -- make depend depends on it.
