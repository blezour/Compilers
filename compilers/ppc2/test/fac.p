(* fac.p *)

proc fac(n: integer): integer;
begin
  if n = 0 then
    return 1
  else
    return n * fac(n-1)
  end
end;

var f: integer;

begin
  f := fac(10);
  print_num(f);
  newline()
end.
        
(*<<
3628800
>>*)
