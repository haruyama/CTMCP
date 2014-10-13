declare
fun {Sqrt X}
   Guess= 1.0
in
   {SqrtIter Guess X}
end
fun {SqrtIter Guess X}
   if {GoodEnough Guess X} then Guess
   else
      {SqrtIter {Improve Guess X} X}
   end
end
fun {Improve Guess X}
   (Guess + X/Guess) / 2.0
end
fun {GoodEnough Guess X}
   {Abs X-Guess*Guess}/X < 0.00001
end
fun {Abs X} if X < 0.0 then ~X else X end end

{Browse {Sqrt 3.0}}

declare
local
   fun {Improve Guess X}
      (Guess + X/Guess) / 2.0
   end
   fun {GoodEnough Guess X}
      {Abs X-Guess*Guess}/X < 0.00001
   end
   fun {SqrtIter Guess X}
      if {GoodEnough Guess X} then Guess
      else
         {SqrtIter {Improve Guess X} X}
      end
   end
in
   fun {Sqrt2 X}
      Guess=1.0
   in
      {SqrtIter Guess X}
   end
end

{Browse {Sqrt2 3.0}}

declare
fun {Sqrt3 X}
   fun {SqrtIter Guess X}
      fun {Improve Guess X}
         (Guess + X/Guess) / 2.0
      end
      fun {GoodEnough Guess X}
         {Abs X-Guess*Guess}/X < 0.00001
      end
   in
      if {GoodEnough Guess X} then Guess
      else
         {SqrtIter {Improve Guess X} X}
      end
   end
   Guess=1.0
in
   {SqrtIter Guess X}
end

{Browse {Sqrt3 5.0}}

declare
fun {Sqrt4 X}
   fun {SqrtIter Guess}
      fun {Improve}
         (Guess + X/Guess) / 2.0
      end
      fun {GoodEnough}
         {Abs X-Guess*Guess}/X < 0.00001
      end
   in
      if {GoodEnough} then Guess
      else
         {SqrtIter {Improve}}
      end
   end
   Guess=1.0
in
   {SqrtIter Guess}
end

{Browse {Sqrt4 5.0}}

declare
fun {Sqrt5 X}
   fun {Improve Guess}
      (Guess + X/Guess) / 2.0
   end
   fun {GoodEnough Guess}
      {Abs X-Guess*Guess}/X < 0.00001
   end
   fun {SqrtIter Guess}
      if {GoodEnough Guess} then Guess
      else
         {SqrtIter {Improve Guess}}
      end
   end
   Guess=1.0
in
   {SqrtIter Guess}
end

{Browse {Sqrt5 5.0}}

declare
fun {Iterate S IsDone Transform}
   if {IsDone S} then S
   else S1 in
      S1 = {Transform S}
      {Iterate S1 IsDone Transform}
   end
end
fun {Sqrt6 X}
   {Iterate
    1.0
    fun {$ G} {Abs X-G*G}/X < 0.00001 end
    fun {$ G} {G + X/G} / 2.0 end}
end


{Browse {Sqrt5 6.0}}

declare
fun {Fact N}
   if N ==0 then 1
   elseif N>0 then N* {Fact N-1}
   else raise domainError end
   end
end

{Browse {Fact 10}}

declare
fun {Fact2 N}
   fun {FactIter N A}
      if N==0 then A
      elseif N>0 then {FactIter N-1 A*N}
      else raise domainError end
      end
   end
in
   {FactIter N 1}
end

{Browse {Fact2 9}}

%3.4
declare
fun {Length Ls}
   case Ls
   of nil then 0
   [] _|Lr then 1+{Length Lr}
   end
end
{Browse {Length [a b c]}}

declare
fun {Append Ls Ms}
   case Ls
   of nil then Ms
   [] X|Lr then X|{Append Lr Ms}
   end
end

{Browse {Append [a b c] [d e f]}}

declare
fun {Nth Xs N}
   if N==1 then Xs.1
   elseif N>1 then {Nth Xs.2 N-1}
   end
end

{Browse {Nth [a b c d] 2}}
{Browse {Nth [a b c d] 5}}

declare
fun {SumList Xs}
   case Xs
   of nil then 0
   [] X|Xr then X+{SumList Xr}
   end
end

{Browse {SumList [1 2 3]}}

{Browse {SumList 1|foo}}

declare
fun {Reverse Xs}
   case Xs
   of nil then nil
   [] X|Xr then
      {Append {Reverse Xr} [X]}
   end
end

{Browse {Reverse [1 2 3 4]}}

declare
local
   fun {IterLength I Ys}
      case Ys
      of nil then I
      [] _|Yr then {IterLength I+1 Yr}
      end
   end
in
   fun {Length2 Xs}
      {IterLength 0 Xs}
   end
end

{Browse {Length2 [1 2 3 4]}}

declare
local
   fun {IterReverse Rs Ys}
      case Ys
      of nil then Rs
      [] Y|Yr then {IterReverse Y|Rs Yr}
      end
   end
in
   fun {Reverse2 Xs}
      {IterReverse nil Xs}
   end
end

{Browse {Reverse2 [1 2 3 4]}}

declare
fun {LengthL Xs}
   case Xs
   of nil then 0
   [] X|Xr andthen {IsList X} then
      {LengthL X} + {LengthL Xr}
   [] X|Xr then
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
fun {LengthL2 Xs}
   case Xs
   of nil then 0
   [] X|Xr then
      {LengthL2 X} + {LengthL2 Xr}
   else 1 end
end

declare
X=[[1 2] 4 nil  [[5] 10]]
{Browse {LengthL2 X}}
{Browse {LengthL2 [X X]}}

{Browse {LengthL2 foo}}
{Browse {LengthL foo}}

%3.4.2.7

declare
fun {Merge Xs Ys}
   case Xs # Ys
   of nil # Ys then Ys
   [] Xs # nil then Xs
   [] (X|Xr) # (Y|Yr) then
      if X < Y then X| {Merge Xr Ys}
      else Y| {Merge Xs Yr}
      end
   end
end
proc {Split Xs ?Ys ?Zs}
   case Xs
   of nil then Ys=nil Zs=nil
   [] [X] then Ys=[X] Zs=nil
   [] X1|X2|Xr then Yr Zr in
      Ys=X1|Yr
      Zs=X2|Zr
      {Split Xr Yr Zr}
   end
end
fun {MergeSort Xs}
   case Xs
   of nil then nil
   [] [X] then [X]
   else Ys Zs in
      {Split Xs Ys Zs}
      {Merge {MergeSort Ys} {MergeSort Zs}}
   end
end

{Browse {MergeSort [3 5 0 9 3 2 1 7 4]}}

%3.4.3

declare
proc {ExprCode E C1 ?Cn S1 ?Sn}
   case E
   of plus(A B) then C2 C3 S2 S3 in
      C2 = plus|C1
      S2=S1+1
      {ExprCode B C2 C3 S2 S3}
      {ExprCode A C3 Cn S3 Sn}
   [] I then
      Cn=push(I)|C1
      Sn=S1+1
   end
end

declare Code Size in
{ExprCode plus(plus(a 3) b) nil Code 0 Size}
{Browse Size#Code}

declare
fun {MergeSort2 Xs}
   fun {MergeSortAcc L1 N}
      if N==0 then
         nil # L1
      elseif N==1 then
         [L1.1] # L1.2
      elseif N>1 then
         NL=N div 2
         NR=N-NL
         Ys # L2 = {MergeSortAcc L1 NL}
         Zs # L3 = {MergeSortAcc L2 NR}
      in
         {Merge Ys Zs} # L3
      end
   end
in
   {MergeSortAcc Xs {Length Xs}}.1
end

{Browse {MergeSort2 [8 3 5 1 4 9]}}
{Browse {MergeSort2 [3 5 0 9 3 2 1 7 4]}}


%3.4.4

declare
fun {AppendD D1 D2}
   S1#E1=D1
   S2#E2=D2
in
   E1=S2
   S1#E2
end

local X Y in {Browse {AppendD (1|2|3|X)#X (4|5|Y)#Y}} end

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

{Browse {Flatten [1 [2 3] 4 [5]]}}
{Browse {Flatten [[a b] [[c] [d]] nil [e [f]]]}}

declare
fun {Flatten2 Xs}
   proc {FlattenD Xs ?Ds}
      case Xs
      of nil then Y in Ds=Y#Y
      [] X|Xr andthen {IsList X} then Y1 Y2 Y4 in
         Ds=Y1#Y4
         {FlattenD X Y1#Y2}
         {FlattenD Xr Y2#Y4}
      [] X|Xr then Y1 Y2 in
         Ds=(X|Y1)#Y2
         {FlattenD Xr Y1#Y2}
      end
   end Ys
in {FlattenD Xs Ys#nil} Ys end

{Browse {Flatten2 [1 [2 3] 4 [5]]}}
{Browse {Flatten2 [[a b] [[c] [d]] nil [e [f]]]}}

declare
fun {Flatten3 Xs}
   proc {FlattenD Xs ?S E}
      case Xs
      of nil then S = E
      [] X|Xr andthen {IsList X} then Y2 in
         {FlattenD X S Y2}
         {FlattenD Xr Y2 E}
      [] X|Xr then Y1 in
         S=X|Y1
         {FlattenD Xr Y1 E}
      end
   end Ys
in {FlattenD Xs Ys nil} Ys end

{Browse {Flatten3 [1 [2 3] 4 [5]]}}
{Browse {Flatten3 [[a b] [[c] [d]] nil [e [f]]]}}

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
   end Ys
in {FlattenD Xs nil} end

{Browse {Flatten4 [1 [2 3] 4 [5]]}}
{Browse {Flatten4 [[a b] [[c] [d]] nil [e [f]]]}}

declare
fun {ReverseDL Xs}
   proc {ReverseD Xs ?Y1 Y}
      case Xs
      of nil then Y1 = Y
      [] X|Xr then {ReverseD Xr Y1 X|Y}
      end
   end Y1
in {ReverseD Xs Y1 nil} Y1 end

{Browse {ReverseDL [1 2 4 5]}}

%3.4.5

declare
fun {NewQueue} q(nil nil) end
fun {Check Q}
   case Q of q(nil R) then q({Reverse R} nil) else Q end
end
fun {Insert Q X}
   case Q of q(F R) then {Check q(F X|R)} end
end
fun {Delete Q X}
   case Q of q(F R) then F1 in F=X|F1 {Check q(F1 R)} end
end
fun {IsEmpty Q}
   case Q of q(F R) then F==nil end
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

%3.4.6
declare
fun {Lookup X T}
   case T
   of leaf then notfound
   [] tree(Y V T1 T2) then
      if X<Y then {Lookup X T1}
      elseif X>Y then {Lookup X T2}
      else found(V) end
   end
end

declare
fun {Lookup X T}
   case T
   of leaf then notfound
   [] tree(Y V _ _) andthen X==Y then found(V)
   [] tree(Y _ T1 _) andthen X<Y then {Lookup X T1}
   [] tree(Y _ _ T2) andthen X>Y then {Lookup X T2}
   end
end

declare
fun {Insert X V T}
   case T
   of leaf then tree(X V leaf leaf)
   [] tree(Y _ T1 T2) andthen X==Y then tree(Y V T1 T2)
   [] tree(Y W T1 T2) andthen X<Y then tree(Y W {Insert X V T1} T2)
   [] tree(Y W T1 T2) andthen X>Y then tree(Y W T1 {Insert X V T2})
   end
end

declare
fun {Delete X T}
   case T
   of leaf then leaf
   [] tree(Y _ T1 T2) andthen X==Y then
      case {RemoveSmallest T2}
      of none then T1
      [] Yp#Vp#Tp then tree(Yp Vp T1 Tp)
      end
   [] tree(Y W T1 T2) andthen X<Y then tree(Y W {Delete X T1} T2)
   [] tree(Y W T1 T2) andthen X>Y then tree(Y W T1 {Delete X T2})
   end
end
fun {RemoveSmallest T}
   case T
   of leaf then none
   [] tree(Y V T1 T2) then
      case {RemoveSmallest T1}
      of none then Y#V#T2
      [] Yp#Vp#Tp then Yp#Vp#tree(X V Tp T2)
      end
   end
end

local T={NewCell leaf} in
   T := {Insert 1 hoge @T}
   T := {Insert 0 nya @T}
   T := {Insert 2 kuke @T}
   {Browse @T}
   T := {Delete 1 @T}
   {Browse @T}
   {Browse {Lookup 0 @T}}
   {Browse {Lookup ~1 @T}}
end

declare
proc {DFSAccLoop2 T ?S1 Sn}
   case T
   of leaf then S1=Sn
   [] tree(Key Val L R) then S2 S3 in
      S1=Key#Val|S2
      {DFSAccLoop2 L S2 S3}
      {DFSAccLoop2 R S3 Sn}
   end
end
fun {DFSAcc2 T} {DFSAccLoop2 T $ nil} end

local T={NewCell leaf} in
   T := {Insert 2 kuke @T}
   T := {Insert 1 hoge @T}
   T := {Insert 3 kuke @T}
   T := {Insert 0 nya @T}
   T := {Insert 4 nya @T}
   {Browse {DFSAcc2 @T}}
end

declare
fun {BFSAcc T}
   fun {NewQueue} X in q(0 X X) end
   fun {Insert Q X}
      case Q of q(N S E) then E1 in E=X|E1 q(N+1 S E1) end
   end
   fun {Delete Q X}
      case Q of q(N S E) then S1 in S=X|S1 q(N-1 S1 E) end
   end
   fun {IsEmpty Q}
      case Q of q(N _ _) then N==0 end
   end
   fun {TreeInsert Q T}
      if T\=leaf then {Insert Q T} else Q end
   end
   proc {BFSQueue Q1 ?S1 Sn}
      if {IsEmpty Q1} then S1=Sn
      else X Q2 Key Val L R S2 in
         Q2={Delete Q1 X}
         tree(Key Val L R)=X
         S1=Key#Val|S2
         {BFSQueue {TreeInsert {TreeInsert Q2 L} R} S2 Sn}
      end
   end
in
   {BFSQueue {TreeInsert {NewQueue} T} $ nil}
end


local T={NewCell leaf} in
   T := {Insert 2 kuke @T}
   T := {Insert 1 hoge @T}
   T := {Insert 4 kuke @T}
   T := {Insert 3 kuke @T}
   T := {Insert 0 nya @T}   
   {Browse {BFSAcc @T}}
end

declare
proc {DFS T}
   fun {TreeInsert S T}
      if T\=leaf then T|S else S end
   end
   proc {DFSStack S1}
      case S1
      of nil then skip
      [] X|S2 then
         tree(Key Val L R) = X
      in
         {Browse Key#Val}
         {DFSStack {TreeInsert {TreeInsert S2 R} L}}
      end
   end
in
   {DFSStack {TreeInsert nil T}}
end

local T={NewCell leaf} in
   T := {Insert 2 kuke @T}
   T := {Insert 1 hoge @T}
   T := {Insert 4 kuke @T}
   T := {Insert 3 kuke @T}
   T := {Insert 0 nya @T}   
   {DFS @T}
end

%3.4.7

%3.4.8

      
