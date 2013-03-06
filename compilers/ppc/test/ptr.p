type 
  tree = pointer to node;
  node = record left, right: tree end;

proc build(n: integer): tree;
  var t: tree;
begin
  if n <= 1 then
    return nil
  else
    new(t);
    t^.left := build(n-2);
    t^.right := build(n-1);
    return t
  end
end;

proc print(t:tree);
begin
  if t = nil then
    print_char('.')
  else
    print_char('(');
    print(t^.left);
    print(t^.right);
    print_char(')')
  end
end;

proc display(t: tree);
  var buf: array 20 of char;

  proc indent(i: integer);
    var j: integer;
  begin
    j := 0;
    while j <= i do print_char(' '); print_char(buf[j]); j := j+1 end
  end;

  proc disp(i: integer; t: tree);
  begin
    if t = nil then
      print_char('$');
      newline()
    else
      print_char('+'); print_char('-');
      buf[i] := '|';
      disp(i+1, t^.right);
      indent(i-1);
      print_char(' '); print_char(' '); print_char('\');
      newline();
      buf[i] := ' ';
      indent(i); print_char(' ');
      disp(i+1, t^.left)
    end
  end;

begin
  print_char('-'); disp(0, t)
end;

proc count(t:tree): integer;
begin
  if t = nil then
    return 1
  else
    return count(t^.left) + count(t^.right)
  end
end;

var p: tree;

begin 
  p := build(7);
  print(p); newline();
  (* newline(); display(p); newline(); *)
  print_string("Count = "); print_num(count(p)); newline()
end.

(*<<
(((.(..))((..)(.(..))))(((..)(.(..)))((.(..))((..)(.(..))))))
Count = 21
>>*)
