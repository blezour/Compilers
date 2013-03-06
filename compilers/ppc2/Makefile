# lab2/Makefile
# $Id: Makefile 39 2005-05-03 15:11:44Z mike $

all: ppc pas0.o tools/risc86

PPC = print.cmo source.cmo util.cmo mach.cmo keiko.cmo dict.cmo \
	tree.cmo lexer.cmo parser.cmo check.cmo risc86.cmo \
	regs.cmo simp.cmo share.cmo jumpopt.cmo tran.cmo kgen.cmo \
	main.cmo

ppc: $(PPC)
	ocamlc -g -o $@ $^

parser.ml parser.mli: parser.mly
	ocamlyacc -v parser.mly

lexer.ml: lexer.mll
	ocamllex lexer.mll

%.ml: %.mlp tools/nodexp
	tools/nodexp $< >$@

%.cmi: %.mli
	ocamlc -c -g $<

%.cmo: %.ml
	ocamlc -c -g $<

tools/nodexp tools/risc86: tools

tools: force
	$(MAKE) -C tools all

CC = gcc

TESTSRC := $(wildcard test/*.p)
OPT = -O2

# These two run out of registers with CSE
test-queens: OPT = -O
test-queens2: OPT = -O

test : $(TESTSRC:test/%.p=test-%)

test-%: force
	@echo "*** Test $*.p"
	./ppc $(OPT) test/$*.p >a.ss
	tools/risc86 <a.ss >a.s
	gcc a.s pas0.o -o a.out
	-./a.out >a.test 2>&1
	sed -n -e '1,/^(\*<</d' -e '/^>>\*)/q' -e p test/$*.p | diff - a.test
	@echo "*** Passed"; echo

force:

MLGEN = parser.mli parser.ml lexer.ml keiko.ml kgen.ml tran.ml simp.ml \
	share.ml jumpopt.ml

ML = $(MLGEN) check.ml check.mli dict.ml dict.mli \
	lexer.mli mach.ml mach.mli main.ml keiko.mli \
	print.ml print.mli source.ml source.mli kgen.mli tree.ml \
	tree.mli util.ml tran.mli risc86.mli risc86.ml \
	simp.mli share.mli regs.mli regs.ml jumpopt.mli

clean:
	rm -f *.cmi *.cmo *.o *.output
	rm -f $(MLGEN)
	rm -f ppc a.out a.s a.ss a.test
	$(MAKE) -C tools $@

depend: $(ML) force
	(sed '/^###/q' Makefile; echo; ocamldep $(ML)) >new
	mv new Makefile

###

parser.cmi: tree.cmi keiko.cmi dict.cmi
parser.cmo: tree.cmi source.cmi keiko.cmi dict.cmi parser.cmi
parser.cmx: tree.cmx source.cmx keiko.cmx dict.cmx parser.cmi
lexer.cmo: util.cmo source.cmi print.cmi parser.cmi keiko.cmi dict.cmi \
    lexer.cmi
lexer.cmx: util.cmx source.cmx print.cmx parser.cmx keiko.cmx dict.cmx \
    lexer.cmi
keiko.cmo: source.cmi print.cmi keiko.cmi
keiko.cmx: source.cmx print.cmx keiko.cmi
kgen.cmo: tree.cmi tran.cmi simp.cmi share.cmi risc86.cmi regs.cmi print.cmi \
    mach.cmi lexer.cmi keiko.cmi jumpopt.cmi dict.cmi kgen.cmi
kgen.cmx: tree.cmx tran.cmx simp.cmx share.cmx risc86.cmx regs.cmx print.cmx \
    mach.cmx lexer.cmx keiko.cmx jumpopt.cmx dict.cmx kgen.cmi
tran.cmo: source.cmi risc86.cmi regs.cmi print.cmi keiko.cmi tran.cmi
tran.cmx: source.cmx risc86.cmx regs.cmx print.cmx keiko.cmx tran.cmi
simp.cmo: util.cmo keiko.cmi simp.cmi
simp.cmx: util.cmx keiko.cmx simp.cmi
share.cmo: regs.cmi print.cmi mach.cmi keiko.cmi share.cmi
share.cmx: regs.cmx print.cmx mach.cmx keiko.cmx share.cmi
jumpopt.cmo: util.cmo keiko.cmi jumpopt.cmi
jumpopt.cmx: util.cmx keiko.cmx jumpopt.cmi
check.cmo: tree.cmi source.cmi print.cmi mach.cmi lexer.cmi keiko.cmi \
    dict.cmi check.cmi
check.cmx: tree.cmx source.cmx print.cmx mach.cmx lexer.cmx keiko.cmx \
    dict.cmx check.cmi
check.cmi: tree.cmi
dict.cmo: print.cmi mach.cmi keiko.cmi dict.cmi
dict.cmx: print.cmx mach.cmx keiko.cmx dict.cmi
dict.cmi: print.cmi mach.cmi keiko.cmi
lexer.cmi: parser.cmi keiko.cmi dict.cmi
mach.cmo: mach.cmi
mach.cmx: mach.cmi
mach.cmi:
main.cmo: source.cmi print.cmi parser.cmi mach.cmi lexer.cmi kgen.cmi \
    check.cmi
main.cmx: source.cmx print.cmx parser.cmx mach.cmx lexer.cmx kgen.cmx \
    check.cmx
keiko.cmi: print.cmi
print.cmo: print.cmi
print.cmx: print.cmi
print.cmi:
source.cmo: print.cmi source.cmi
source.cmx: print.cmx source.cmi
source.cmi: print.cmi
kgen.cmi: tree.cmi
tree.cmo: source.cmi print.cmi keiko.cmi dict.cmi tree.cmi
tree.cmx: source.cmx print.cmx keiko.cmx dict.cmx tree.cmi
tree.cmi: keiko.cmi dict.cmi
util.cmo:
util.cmx:
tran.cmi: keiko.cmi
risc86.cmi: print.cmi keiko.cmi
risc86.cmo: print.cmi keiko.cmi risc86.cmi
risc86.cmx: print.cmx keiko.cmx risc86.cmi
simp.cmi: keiko.cmi
share.cmi: keiko.cmi
regs.cmi: risc86.cmi
regs.cmo: risc86.cmi regs.cmi
regs.cmx: risc86.cmx regs.cmi
jumpopt.cmi: keiko.cmi
