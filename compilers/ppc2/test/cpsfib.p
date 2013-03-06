(* cpsfib.p *)

(* This program computes fibonacci numbers using the usual doubly
   recursive algorithm.  However, the algorithm has been transformed
   into continuation passing style.  A good test for procedural
   parameters! *)

(* fib -- fibonacci numbers *)
proc fib(n: integer): integer;

  (* fib1 -- continuation transformer for fib *)
  proc fib1(n: integer; proc k(r: integer): integer) : integer;
    proc k1(r1: integer): integer;
      proc k2(r2: integer): integer; begin return k(r1 + r2) end;
    begin return fib1(n-2, k2) end;
  begin
    if n <= 1 then 
      return k(1) 
    else 
      return fib1(n-1, k1)
    end
  end;

  (* id -- identity continuation *)
  proc id(r: integer): integer; begin return r end;

begin
  return fib1(n, id)
end;

begin
  print_num(fib(6)); newline()
end.

(*<<
13
>>*)
