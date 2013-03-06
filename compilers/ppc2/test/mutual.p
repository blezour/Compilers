(* mutual.p *)

proc flip(i: integer): integer;
  var r: integer;
begin
  if i = 0 then 
    r := 1
  else 
    r := 2 * flop(i-1)
  end;
  print_string("flip("); print_num(i); 
  print_string(") = "); print_num(r);
  newline();
  return r
end;

proc flop(i: integer): integer;
  var r: integer;
begin
  if i = 0 then 
    r := 1
  else 
    r := flip(i-1) + k
  end;
  print_string("flop("); print_num(i); 
  print_string(") = "); print_num(r);
  newline();
  return r
end;

const k = 5;

begin
  print_num(flip(5));
  newline()
end.

(*<<
flop(0) = 1
flip(1) = 2
flop(2) = 7
flip(3) = 14
flop(4) = 19
flip(5) = 38
38
>>*)
