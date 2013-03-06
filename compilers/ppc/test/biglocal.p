proc foo(var a: array 10000 of integer);
begin a[5000] := 3 end;

var b: array  10000 of integer;
begin foo(b) end.
