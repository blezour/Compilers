(* fib.p *)

(* fib -- fibonacci numbers *)
proc fib(n: integer): integer;
begin
  if n <= 1 then 
    return 1 
  else 
    return fib(n-1) + fib(n-2)
  end
end;

begin
  print_num(fib(6)); newline()
end.

(*<<
13
>>*)
