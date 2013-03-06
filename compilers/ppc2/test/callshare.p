var x, y: integer;

proc f(n: integer): integer;
begin x := x + n; return x end;

begin
  x := 2;
  y := f(3) + 1;
  y := f(3) + 1;
  print_num(x); newline()
end.

(*<<
8
>>*)
