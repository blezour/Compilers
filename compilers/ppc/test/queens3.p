(* N queens with bitmap arrays *)

const N = 8;

var 
  choice: array N of integer;
  rank: array N of boolean;
  diagup, diagdown: array 2 * N - 1 of boolean;

proc queens(k: integer);
  var y, j, q: integer; ok: boolean;
begin
  if k = N then
    print()
  else
    y := 0;
    while y < N do
      if rank[y] and diagup[k+y] and diagdown[k-y+N-1] then
	rank[y] := false; diagup[k+y] := false; diagdown[k-y+N-1] := false;
	choice[k] := y; queens(k+1);
	rank[y] := true; diagup[k+y] := true; diagdown[k-y+N-1] := true;
      end;
      y := y+1
    end
  end
end;

proc print();
  var x: integer;
begin
  x := 0;
  while x < N do
    print_num(choice[x]+1);
    x := x+1
  end;
  newline()
end;

proc init();
  var i: integer;
begin
  i := 0; 
  while i < N do 
    rank[i] := true; 
    i := i+1 
  end;
  i := 0; 
  while i < 2*N-1 do 
    diagup[i] := true; diagdown[i] := true ;
    i := i+1
  end
end;

begin
  init();
  queens(0)
end.

(*<<
15863724
16837425
17468253
17582463
24683175
25713864
25741863
26174835
26831475
27368514
27581463
28613574
31758246
35281746
35286471
35714286
35841726
36258174
36271485
36275184
36418572
36428571
36814752
36815724
36824175
37285146
37286415
38471625
41582736
41586372
42586137
42736815
42736851
42751863
42857136
42861357
46152837
46827135
46831752
47185263
47382516
47526138
47531682
48136275
48157263
48531726
51468273
51842736
51863724
52468317
52473861
52617483
52814736
53168247
53172864
53847162
57138642
57142863
57248136
57263148
57263184
57413862
58413627
58417263
61528374
62713584
62714853
63175824
63184275
63185247
63571428
63581427
63724815
63728514
63741825
64158273
64285713
64713528
64718253
68241753
71386425
72418536
72631485
73168524
73825164
74258136
74286135
75316824
82417536
82531746
83162574
84136275
>>*)
