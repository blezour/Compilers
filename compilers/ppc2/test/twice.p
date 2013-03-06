(* twice.p *)

type int = integer;

proc square(x: int): int; begin return x * x end;

proc twice(proc f(y: int): int; x: int): int;
begin return f(f(x)) end;

proc ap_to_sq(proc ff(proc f(x: int): int; x: int): int; x: int): int;
begin return ff(square, x) end;

begin
  print_num(ap_to_sq(twice, 3));
  newline()
end.

(*<<
81
>>*)
