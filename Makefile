CC = gcc
CFLAGS = -std=c89
FLEX = lex
YACC = yacc

.l.c:
	$(FLEX) -o $@ $<
	mv $*.c $*.lex.c

.y.c:
	$(YACC) --file-prefix=$* -d $<
	mv $*.tab.c $*.yacc.c
	mv $*.tab.h $*.yacc.h
.c.o:
	$(CC) -c -o $@ $<

iimp: iimp.yacc.o iimp.lex.o
	$(CC) -o $@ $^

clean:
	rm -f *.o *.c iimp.yacc.h
