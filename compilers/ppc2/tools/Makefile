# tools/Makefile

all : nodexp risc86

nodexp : print.cmo nclex.cmo ncparse.cmo ncmain.cmo
	ocamlc -o $@ $^

nclex.ml : nclex.mll
	ocamllex nclex.mll

ncparse.mli ncparse.ml : ncparse.mly
	ocamlyacc -v ncparse.mly

risc86 : print.cmo r86lex.cmo r86ops.cmo r86parse.cmo r86main.cmo
	ocamlc -o $@ $^

r86lex.ml : r86lex.mll
	ocamllex $<

r86parse.mli r86parse.ml : r86parse.mly
	ocamlyacc -v $<

%.cmi: %.mli
	ocamlc -c $<

%.cmo: %.ml
	ocamlc -c $<

MLGEN = nclex.ml ncparse.mli ncparse.ml r86lex.ml r86parse.mli r86parse.ml

ML = $(MLGEN) ncmain.ml r86main.ml r86ops.ml print.mli print.ml

clean : force
	rm -f nodexp risc86 *.cmo *.cmi *.output $(MLGEN)

depend: $(ML) force
	(sed '/^###/q' Makefile; echo; ocamldep $(ML)) >new
	mv new Makefile

force:

###

nclex.cmo: ncparse.cmi
nclex.cmx: ncparse.cmx
ncparse.cmi:
ncparse.cmo: ncparse.cmi
ncparse.cmx: ncparse.cmi
r86lex.cmo: r86parse.cmi
r86lex.cmx: r86parse.cmx
r86parse.cmi:
r86parse.cmo: r86ops.cmo print.cmi r86parse.cmi
r86parse.cmx: r86ops.cmx print.cmx r86parse.cmi
ncmain.cmo: ncparse.cmi nclex.cmo
ncmain.cmx: ncparse.cmx nclex.cmx
r86main.cmo: r86parse.cmi r86lex.cmo print.cmi
r86main.cmx: r86parse.cmx r86lex.cmx print.cmx
r86ops.cmo: print.cmi
r86ops.cmx: print.cmx
print.cmi:
print.cmo: print.cmi
print.cmx: print.cmi
