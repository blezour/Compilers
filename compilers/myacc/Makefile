# myacc/Makefile

all: myacc yyparse.cmo yacc.mli yacc.ml

COMMON = yyparse.cmo growvect.cmo vector.cmo print.cmo error.cmo util.cmo \
	table.cmo grammar.cmo lr0.cmo report.cmo lalr.cmo \
	conflict.cmo compile.cmo output.cmo

bootyacc: $(COMMON) bootlexer.cmo bootyacc.cmo bootmain.cmo
	ocamlc $(MLFLAGS) -o $@ str.cma $^

myacc: $(COMMON) lexer.cmo yacc.cmo main.cmo
	ocamlc $(MLFLAGS) -o $@ str.cma $^

bootlexer.ml bootmain.ml: boot%: %
	sed -e 's/Yacc/Bootyacc/g' -e 's/Lexer/Bootlexer/' $< >$@

%.cmo: %.ml
	ocamlc $(MLFLAGS) -c -o $@ $<

%.cmi: %.mli
	ocamlc $(MLFLAGS) -c -o $@ $<

%.ml: %.mll
	ocamllex -o $@ $<

%.mli %.ml: %.mly
	$(MAKE) bootyacc
	./bootyacc $<

update: force
	cp yacc.mli bootyacc.mli
	cp yacc.ml bootyacc.ml

clean: force
	rm -f myacc bootyacc
	rm -f *.cmi *.cmo
	rm -f lexer.ml yacc.ml yacc.mli
	rm -f bootmain.ml bootlexer.ml

force:

###

compile.cmo   : compile.cmi table.cmi util.cmi
compile.cmi   : grammar.cmi lr0.cmi
conflict.cmo  : conflict.cmi error.cmi print.cmi util.cmi
conflict.cmi  : grammar.cmi lr0.cmi
error.cmo     : error.cmi
error.cmi     : print.cmi
grammar.cmo   : error.cmi grammar.cmi growvect.cmi
grammar.cmi   : print.cmi table.cmi vector.cmi
growvect.cmo  : growvect.cmi
lalr.cmo      : grammar.cmi lalr.cmi lr0.cmi print.cmi report.cmi
lexer.cmo     : error.cmi grammar.cmi output.cmi print.cmi yacc.cmi
lr0.cmo       : growvect.cmi lr0.cmi util.cmi
lr0.cmi       : grammar.cmi print.cmi table.cmi vector.cmi
main.cmo      : compile.cmi conflict.cmi error.cmi grammar.cmi lalr.cmi \
		lexer.cmo lr0.cmi output.cmi print.cmi report.cmi table.cmi \
		util.cmi yacc.cmi
output.cmo    : compile.cmi error.cmi grammar.cmi growvect.cmi lr0.cmi \
		output.cmi print.cmi table.cmi yyparse.cmi
output.cmi    : lr0.cmi
print.cmo     : print.cmi
report.cmi    : lr0.cmi
report.cmo    : error.cmi grammar.cmi print.cmi report.cmi util.cmi
table.cmo     : table.cmi util.cmi
table.cmi     : growvect.cmi
util.cmo      : print.cmi util.cmi
yacc.cmo      : error.cmi print.cmi yacc.cmi
yacc.cmi      : grammar.cmi
yyparse.cmo   : yyparse.cmi
vector.cmo    : vector.cmi

bootlexer.cmo : error.cmi grammar.cmi output.cmi print.cmi bootyacc.cmi
bootyacc.cmi  : grammar.cmi
bootyacc.cmo  : bootyacc.cmi
bootmain.cmo  : lr0.cmi
