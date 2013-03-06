# lab1/Makefile

all: calc

CALC = print.cmo lexer.cmo parser.cmo memory.cmo eval.cmo main.cmo
calc: $(CALC)
	ocamlc -o calc $(CALC)

parser.mli parser.ml: parser.mly
	ocamlyacc parser.mly

lexer.ml: lexer.mll
	ocamllex lexer.mll

clean:
	rm -f calc parser.mli parser.ml lexer.ml *.cma *.cmo *.cmi 

ML = eval.ml eval.mli lexer.mli lexer.ml main.ml memory.ml memory.mli \
	parser.mli parser.ml tree.mli print.mli print.ml

depend : $(ML) force
	(sed '/^###/q' Makefile; echo; ocamldep $(INCLUDE) $(ML)) >new
	mv new Makefile

%.cmi : %.mli
	ocamlc -c $(INCLUDE) $<

%.cmo : %.ml
	ocamlc -c $(INCLUDE) $<

force:

###

eval.cmo: tree.cmi eval.cmi
eval.cmx: tree.cmi eval.cmi
eval.cmi: tree.cmi
lexer.cmi: parser.cmi
lexer.cmo: parser.cmi lexer.cmi
lexer.cmx: parser.cmx lexer.cmi
main.cmo: print.cmi parser.cmi lexer.cmi eval.cmi
main.cmx: print.cmx parser.cmx lexer.cmx eval.cmx
memory.cmo: memory.cmi
memory.cmx: memory.cmi
memory.cmi:
parser.cmi: tree.cmi
parser.cmo: tree.cmi parser.cmi
parser.cmx: tree.cmi parser.cmi
tree.cmi:
print.cmi:
print.cmo: print.cmi
print.cmx: print.cmi
