proc choose(n, k: integer): integer;
begin
  if n = 0 then
    if k = 0 then
      return 1
    else
      return 0
    end
  else
    return choose(n-1, k-1) + choose(n-1, k)
  end
end;

begin
  print_num(choose(6,4));
  newline()
end.

(*<<
15
>>*)
