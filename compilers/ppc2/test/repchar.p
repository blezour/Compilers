proc repchar(c: char; n: integer);
  var i: integer;
begin
  if n > 0 then
    print_char(c);
    repchar(c, n-1)
  end
end;

begin
  repchar('A', 3);
  repchar('B', 5);
  newline()
end.

(*<<
AAABBBBB
>>*)
