CC = gcc
CFLAGS = -std=c89
FFLAG=-lfl
FLEX = lex
YACC = yacc

.l.c:
	$(FLEX) -o $@ $<

.y.c:
	$(YACC) --file-prefix=$* -d $<
	mv $*.tab.c $*.c
	mv $*.tab.h $*.h
.c.o:
	$(CC) -c -o $@ $<

inter_imp: inter_imp.c
	$(CC) inter_imp.c $(FFLAGS)

inter_c3a: inter_c3a.c
	$(CC) inter_c3a.c $(FFLAGS)

clean:
	rm -f *.o *.c
