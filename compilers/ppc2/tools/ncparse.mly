/* ncparse.mly */

%token <string>		WORD CHAR OPEN
%token			LPAREN RPAREN CLOSE EOF COMMA SPACE ATSIGN

%type <unit> 		text
%start 			text

%nonassoc		LOW
%nonassoc		COMMA SPACE ATSIGN
%nonassoc		HIGH

%{
type frag = 
  Frag of string | Join of string * frag list | Snoc of frag * string

let rec out_frag =
  function
      Frag s -> print_string s
    | Join (fmt, args) -> 
	let j = ref 0 in
	for i = 0 to String.length fmt - 1 do
	  if fmt.[i] <> '@' then 
    	    print_char fmt.[i]
	  else begin
	    out_frag (List.nth args !j);
	    incr j
	  end
	done
    | Snoc (f, s) ->
	out_frag f; print_string s

let out s = print_string s
%}

%%

text :
    prog EOF			{ () } ;

prog :
    /* empty */			{ () }
  | prog WORD			{ out $2 }
  | prog SPACE			{ out " " }
  | prog CLOSE			{ out ">" }
  | prog LPAREN			{ out "(" }
  | prog RPAREN			{ out ")" }
  | prog COMMA			{ out "," }
  | prog ATSIGN			{ out "@" }
  | prog CHAR			{ out $2 }
  | prog node			{ out_frag $2 } ;

node :
    OPEN bal1 args CLOSE	{ Join ("(Node (@@, @))", [Frag $1; $2; $3]) }

bal1 :
    bal %prec HIGH		{ $1 } ;

args :
    /* empty */			{ Frag "[]" }
  | COMMA blank arglist		{ Join ("[@]", [$3]) }
  | COMMA blank ATSIGN bal	{ $4 } ;

arglist :
    bal %prec HIGH		{ $1 }
  | arglist COMMA bal %prec HIGH  { Join ("@; @", [$1; $3]) } ;

bal :
    /* empty */ %prec LOW	{ Frag "" }
  | bal WORD			{ Snoc ($1, $2) }
  | bal SPACE			{ Snoc ($1, " ") }
  | bal LPAREN bal RPAREN	{ Join ("@(@)", [$1; $3]) }
  | bal COMMA			{ Snoc ($1, ",") }
  | bal ATSIGN			{ Snoc ($1, "@") }
  | bal CHAR			{ Snoc ($1, $2) }
  | bal node			{ Join ("@@", [$1; $2]) } ;

blank :
    /* empty */ %prec LOW	{ () }
  | SPACE			{ () } ;
