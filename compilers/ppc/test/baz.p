(* baz.p *)

var x: integer;

proc baz(u: integer): integer;
begin
  x := u;
  return x
end;
  
begin
  print_num(baz(37)); newline();
  print_num(x); newline()
end.

(*<<
37
37
>>*)
