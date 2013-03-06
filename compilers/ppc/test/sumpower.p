(* sumpower.p *)

proc sum(a, b: integer; proc f(x: integer): integer): integer;
  var i, s: integer;
begin
  i := a; s := 0;
  while i <= b do
    s := s + f(i);
    i := i + 1
  end;
  return s
end;

proc sum_powers(a, b, n: integer): integer;
  proc pow(x: integer): integer;
    var j, p: integer;
  begin
    j := 0; p := 1;
    while j < n do
      p := p * x;
      j := j + 1
    end;
    return p
  end;
begin
  return sum(a, b, pow)
end;

begin
  print_num(sum_powers(1, 10, 3));
  newline()
end.

(*<<
3025
>>*)
