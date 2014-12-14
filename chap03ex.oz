% 3
% a < b とは問題文にないのでそのチェックが必要

declare
fun {BinarySearch F A B}
   if {Abs A-B} < 0.0001 then A
   else M in
      M = (A+B)/2.0
      if {F M} > 0.0 then {BinarySearch F A M}
      elseif {F M} == 0. then M
      else {BinarySearch F M B}
      end
   end
end

{Browse {BinarySearch fun{$ X} X*X - 2.0 end 0.0 2.0}}

% 4

declare
fun {Fact N}
   fun {FactIter N A}
      if N==1 then A
      else {FactIter N-1 N*A} end
   end
in
   {FactIter N 1}
end

{Browse {Fact 10}}

%5

declare
fun {SumList Xs}
   fun {SumListIter Ys A}
      case Ys
      of nil then A
      [] Y|Yr then {SumListIter Yr A+Y} end
   end
in
   {SumListIter Xs 0}
end

{Browse {SumList [1 2 3 4 5]}}

% 6
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer6.oz

% 7
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer7.oz

% 8
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer8.oz

declare
fun {Append Xs Ys}
   fun {ReverseAppendIter Xs Ys}
      case Xs
      of nil then Ys
      [] X|Xr then {ReverseAppendIter Xr X|Ys} end
   end
   fun {Reverse Xs}
      fun {ReverseIter Xs A}
         case Xs
         of nil then A
         [] X|Xr then {ReverseIter Xr X|A} end
      end
   in
      {ReverseIter Xs nil}
   end
in
   {ReverseAppendIter {Reverse Xs} Ys}
end

{Browse {Append [1 2 3] [4 5]}}

% 9

declare
fun {Append Xs Ys}
   case Xs
   of nil then Ys
   else Xs.1 | {Append Xs.2 Ys}
   end
end

{Browse {Append [1 2 3] [4 5]}}

% 10


declare
fun {LengthL Xs}
   case Xs
   of nil then 0
   [] X|Xr andthen {IsList X} then
      {LengthL X} + {LengthL Xr}
   [] _|Xr then
      1 + {LengthL Xr}
   end
end
fun {IsCons X} case X of _|_ then true else false end end
fun {IsList X} X==nil orelse {IsCons X} end

declare
X=[[1 2] 4 nil  [[5] 10]]
{Browse {LengthL X}}
{Browse {LengthL [X X]}}

declare
{Browse {IsList [1 2]}}
{Browse {IsList 1}}

declare
fun {IsList X} X\=(_|_) end

declare
{Browse {IsList [1 2]}}
{Browse {IsList 1}}

declare
X=[[1 2] 4 nil  [[5] 10]]
{Browse {LengthL X}}
{Browse {LengthL [X X]}}

% case文は構造が同等であればよいが、内包チェックにおいては未定義値との比較はブロックの要因

% 11
declare
fun {AppendD D1 D2}
   S1#E1=D1
   S2#E2=D2
in
   E1=S2
   S1#E2
end

local X Y in {Browse {AppendD (1|2|3|X)#X (4|5|Y)#Y}} end

local X Y Z U W in
   Z = (1|2|3|X)#X
   U = {AppendD Z (4|5|Y)#Y}
   {Browse U}
   {Browse Z}
   {Browse {AppendD U (6|7|W)#W}}

% E1=S2 ではない
   {Browse {AppendD Z (6|7|W)#W}}
end

% 12
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer12.oz

declare
fun {Flatten Xs}
   case Xs
   of nil then nil
   [] X|Xr andthen {IsList X} then
      {Append {Flatten X} {Flatten Xr}}
   [] X|Xr then
      X| {Flatten Xr}
   end
end
fun {Append Ls Ms}
   case Ls
   of nil then Ms
   [] X|Lr then X|{Append Lr Ms}
   end
end
fun {IsCons X} case X of _|_ then true else false end end
fun {IsList X} X==nil orelse {IsCons X} end

% Append: Ls の長さに比例する時間
% IsList: 一定時間

declare
fun {Flatten4 Xs}
   fun {FlattenD Xs E}
      case Xs
      of nil then E
      [] X|Xr andthen {IsList X} then 
         {FlattenD X {FlattenD Xr E}}
      [] X|Xr then
         X| {FlattenD Xr E}
      end
   end
in {FlattenD Xs nil} end

{Browse {Flatten4 [1 [2 3] 4 [5]]}}
{Browse {Flatten4 [[a b] [[c] [d]] nil [e [f]]]}}

% 13
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer13.oz

declare AddMat SubMat MulMat TransMat

local
   % 行列の項目毎の演算
   fun {FMat X Y F}
      case X of X1|X1r then
         case Y of Y1|Y1r then
            {FList X1 Y1 F}|{FMat X1r Y1r F}
         end
      [] nil then nil end
   end
   % 行列の列毎の演算
   fun {FList Xs Ys F}
      case Xs of X|Xr then
         case Ys of Y|Yr then
            {F X Y}|{FList Xr Yr F}
         end
      [] nil then nil end
   end
in
   fun {AddMat X Y}
      {FMat X Y fun{$ X Y} X+Y end}
   end
   fun {SubMat X Y}
      {FMat X Y fun{$ X Y} X-Y end}
   end
end

fun {TransMat Mat} % 効率微妙？
   fun {TransMatIter Mat ?S}
      case Mat of X|Xr then
         {TransMatIter Xr {TransLine X S}}
      [] nil then S end
   end
   fun {TransLine Xs S}
      case Xs of X|Xr then
         case S of Sa|Sr then
            (X|Sa)|{TransLine Xr Sr} end
      [] nil then nil end
   end
   fun {PreProcess Xs}
      case Xs of _|Xr then nil|{PreProcess Xr} else nil end
   end
   fun {AfterProcess Xs}
      case Xs of X|Xr then {Reverse X}|{AfterProcess Xr} [] nil then nil end
   end
in
   {AfterProcess {TransMatIter Mat {PreProcess Mat.1}}}
end

fun {MulMat X Y}
   fun {MulMatIter AM BM}
      case AM of A|Ar then
         {MulMatLine A BM}|{MulMatIter Ar BM}
      [] nil then nil end
   end
   fun {MulMatLine A BM}
      case BM of B|Br then
         {MultSumList A B 0}|{MulMatLine A Br}
      [] nil then nil end
   end
   fun {MultSumList A B ?S}
      case A of X|Xr then
         case B of Y|Yr then
            {MultSumList Xr Yr (X*Y)+S} end
      [] nil then S end
   end
   A = X
   B = {TransMat Y}
in
   {MulMatIter A B}
end

declare
X=[[1 2 3] [2 1 2]]
Y=[[3 2 3] [3 1 1]]
Z=[[1 2] [1 1] [1 2]]
U=[[2 1 1] [3 1 0]]
{Browse {AddMat X Y}}
{Browse {TransMat X}}
{Browse {MulMat Z U}}
      
% 14
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer14.oz

declare
fun {NewQueue} X in q(0 X X) end
fun {Insert Q X}
   case Q of q(N S E) then E1 in E=X|E1 q(N+1 S E1) end
end
fun {Delete Q X}
   case Q of q(N S E) then S1 in S=X|S1 q(N-1 S1 E) end
end
fun {IsEmpty Q}
   case Q of q(N S E) then N==0 end
end

local Q={NewCell {NewQueue}} X Y in
   Q := {Insert @Q 1}
   Q := {Insert @Q 2}
   {Browse @Q}
   Q := {Delete @Q X}
   {Browse X}
   Q := {Delete @Q Y}
   {Browse Y}
end

local Q={NewCell {NewQueue}} X in
   Q := {Delete @Q X}
   {Browse X}
   {Browse @Q}
end

local Q={NewCell {NewQueue}} X in
   Q := {Delete @Q X}
   {Browse X}
   {Browse @Q}
   Q := {Insert @Q 1}
   {Browse @Q}   
end

declare
fun {IsEmpty q(_ S E)} S == E end

local Q={NewCell {NewQueue}} in
   {Browse {IsEmpty @Q}}
   Q := {Insert @Q 1}
   {Browse {IsEmpty @Q}}
end

local Q={NewCell {NewQueue}} X in
   {Browse {IsEmpty @Q}}
   Q := {Insert @Q X}
   {Browse @Q}
   {Browse {IsEmpty @Q}} %ブロック
end

% 15
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer15.oz

declare
fun {QuickSort Ls}
   fun {QuickSortIter Ls E}
      case Ls
      of nil then E
      [] Pivot|Lr then Ys Zs in
         {Devide Lr Pivot Ys Zs}
         {QuickSortIter Ys Pivot|{QuickSortIter Zs E}}
      end
   end
   proc {Devide Ls P ?Ys ?Zs}
      case Ls
      of nil then Ys=nil Zs=nil
      [] L|Lr then
         if L < P then Ys = L|{Devide Lr P $ Zs}
         else Zs=L|{Devide Lr P Ys $}
         end
      end
   end
in
   {QuickSortIter Ls nil}
end

{Browse {QuickSort [3 2 1 4 5 6 0 1]}}

% 16

% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer16.oz

declare
fun {Convolute Xs Ys}
   proc {ConvoluteIter Xs Ys ?Zs}
      case Xs
      of nil then Zs = nil
      [] X|Xr then
         case Ys of Y|Yr then Rs in
            Zs=X#Y|Rs
            {ConvoluteIter Xr Yr Rs}
         end
      end
   end
in
%   {ConvoluteIter Xs {Reverse Ys} $}
   {ConvoluteIter Xs {Reverse Ys}}   
end

declare
{Browse {Convolute [2 4 6] [1 3 5]}}

% https://haskelladdict.wordpress.com/tag/danvy/

declare
fun {Convolute Xs Ys}
   proc {ConvoluteIter Xs ?Zs ?Ws}
      case Xs
      of nil then Zs = nil Ws = Ys
      [] X|Xr then B Zr in
         Zs = X#B|Zr
         {ConvoluteIter Xr Zr B|Ws}
      end
   end
in 
   {ConvoluteIter Xs $ _}
end

declare
{Browse {Convolute [2 4 6] [1 3 5]}}

