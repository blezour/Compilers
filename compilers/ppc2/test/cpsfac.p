(* cpsfac.p *)

proc fac(n: integer; proc k(r: integer): integer): integer;
  proc k1(r: integer): integer;
    var r1: integer;
  begin
    r1 := n * r;
    print_num(n); print_string(" * "); print_num(r);
    print_string(" = "); print_num(r1); newline();
    return k(r1) 
  end;
begin 
  if n = 0 then return k(1) else return fac(n-1, k1) end
end;

proc id(r: integer): integer;
begin 
  return r 
end;

begin 
  print_num(fac(10, id));
  newline()
end.

(*<<
1 * 1 = 1
2 * 1 = 2
3 * 2 = 6
4 * 6 = 24
5 * 24 = 120
6 * 120 = 720
7 * 720 = 5040
8 * 5040 = 40320
9 * 40320 = 362880
10 * 362880 = 3628800
3628800
>>*)
