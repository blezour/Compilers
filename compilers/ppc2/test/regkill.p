var x: integer;

proc p();
var y, z: integer;
begin
  y := 1;
  z := y + 1;
  z := 3;
  z := y + 1;
  x := z
end;

begin
  p();
  print_num(x);
  newline()
end.

(*<<
2
>>*)
