(* Pascal's triangle *)

const n = 10;

proc pascal2();
  var i, j: integer;
  var a: array n of array n+1 of integer;
begin
  i := 0;
  while i < n do
    a[i][0] := 1; j := 1;
    print_num(a[i][0]);
    while j <= i do
      a[i][j] := a[i-1][j-1] + a[i-1][j];
      print_char(' '); print_num(a[i][j]);
      j := j+1
    end;
    a[i][i+1] := 0;
    newline();
    i := i+1
  end
end;

begin
  pascal2()
end.

(*<<
1
1 1
1 2 1
1 3 3 1
1 4 6 4 1
1 5 10 10 5 1
1 6 15 20 15 6 1
1 7 21 35 35 21 7 1
1 8 28 56 70 56 28 8 1
1 9 36 84 126 126 84 36 9 1
>>*)
