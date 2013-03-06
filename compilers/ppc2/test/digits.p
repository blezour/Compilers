proc search(k, n: integer; proc avail(x: integer): boolean);
  var d, n1: integer;
  proc avail1(x: integer): boolean;
  begin
    if x <> d then 
      return avail(x)
    else
      return false
    end
  end;
begin
  if k = 9 then
    print_num(n); newline()
  else
    d := 1;
    while d < 10 do
      n1 := 10 * n + d;
      if (n1 mod (k+1) = 0) and avail(d) then
        search(k+1, n1, avail1)
      end;
      d := d+1
    end
  end
end;

proc avail0(x: integer): boolean;
begin
  return true
end;

begin
  search(0, 0, avail0)
end.

(*<<
381654729
>>*)
