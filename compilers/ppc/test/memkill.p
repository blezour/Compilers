proc f(): integer;
  var x, y: integer;
begin
  x := 3;
  y := x + 1;
  g();
  return x + 1
end;

proc g(); begin end;

begin
  print_num(f()); newline()
end.

(*<<
4
>>*)
