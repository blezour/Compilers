(* varparam.p *)

proc one(var x: integer);
  proc two(); begin x := 37 end;
begin
  two()
end;

var y: integer;

begin
  one(y);
  print_num(y);
  newline()
end.

(*<<
37
>>*)
