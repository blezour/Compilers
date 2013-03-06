proc f(x: integer): integer; begin return 2*x end;
begin print_num(f(f(3))); newline() end.

(*<<
12
>>*)
