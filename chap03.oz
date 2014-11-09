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
{Browse {MergeSort [3 5 0 9 8 1]}}

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

declare Q1 Q2 Q3 Q4 Q5 Q6 Q7 in
Q1={NewQueue}
Q2={Insert Q1 peter}
Q3={Insert Q2 paul}
local X in Q4={Delete Q3 X} {Browse X} end
Q5={Insert Q4 mary}
local X in Q6={Delete Q5 X} {Browse X} end
local X in Q7={Delete Q6 X} {Browse X} end

declare Q1 Q2 Q3 Q4 Q5 Q6 Q7 in
Q1={NewQueue}
Q2={Insert Q1 peter}
Q3={Insert Q2 paul}
local X in Q4={Delete Q3 X} {Browse X} end
local X in Q5={Delete Q4 X} {Browse X} end
local X in Q6={Delete Q5 X} {Browse X} end
Q7={Insert Q6 mary}

% https://github.com/draftcode/ctmcp-answers/blob/master/Section3/prob14.markdown

% 最悪時では動かない?
declare Q1 Q2 Q3 Q4 Q5 Q6 in
Q1={NewQueue}
Q2={Insert Q1 peter}
Q3={Insert Q2 paul}
Q4={Insert Q2 mary}
local X in Q5={Delete Q3 X} {Browse X} end
local X in Q6={Delete Q4 X} {Browse X} end

% http://www.kmonos.net/pub/Presen/PFDS.pdf

declare
proc {ForkD D ?E ?F}
   D1#nil = D
   E1#E0=E {Append D1 E0 E1}
   F1#F0=F {Append D1 F0 F1}
in skip end
proc {ForkQ Q ?Q1 ?Q2}
   q(N S E) = Q
   q(N S1 E1) = Q1
   q(N S2 E2) = Q2
in
   {ForkD S#E S1#E1 S2#E2}
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
      [] Yp#Vp#Tp then Yp#Vp#tree(Y V Tp T2)
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

declare
fun {COP Y}
   Y=='<' orelse Y=='>' orelse Y=='=<' orelse
   Y=='>=' orelse Y=='--' orelse Y=='!='
end
fun {EOP Y} Y=='+' orelse Y=='-' end
fun {TOP Y} Y=='*' orelse Y=='/' end
fun {Fact S1 Sn}
   T|S2=S1 in
   if {IsInt T} orelse {IsIdent T} then
      S2=Sn
      T
   else E S2 S3 in
      S1='('|S2
      E={Expr S2 S3}
      S3=')'|Sn
      E
   end
end
fun {Id S1 Sn} X in S1=X|Sn true={IsIdent X} X end
fun {IsIdent X} {IsAtom X} end
fun {Sequence NonTerm Sep S1 Sn}
   fun {SequenceLoop Prefix S2 Sn}
      case S2 of T|S3 andthen {Sep T} then Next S4 in
         Next={NonTerm S3 S4}
         {SequenceLoop T(Prefix Next) S4 Sn}
      else
         Sn=S2 Prefix
      end
   end
   First S2
in
   First={NonTerm S1 S2}
   {SequenceLoop First S2 Sn}
end
fun {Comp S1 Sn} {Sequence Expr COP S1 Sn} end
fun {Expr S1 Sn} {Sequence Term EOP S1 Sn} end
fun {Term S1 Sn} {Sequence Fact TOP S1 Sn} end


declare
fun {Prog S1 Sn}
   Y Z S2 S3 S4 S5
in
   S1=program|S2
   Y={Id S2 S3}
   S3=';'|S4
   Z={Stat S4 S5}
   S5='end'|Sn
   prog(Y Z)
end
fun {Stat S1 Sn}
   T|S2=S1 in
   case T
   of begin then
      {Sequence Stat fun {$ X} X==';' end S2 'end'|Sn}
   [] 'if' then C X1 X2 S3 S4 S5 S6 in
      C={Comp S2 S3}
      S3='then'|S4
      X1={Stat S4 S5}
      S5='else'|S6
      X2={Stat S6 Sn}
      'if'(C X1 X2)
   [] 'while' then C X S3 S4 in
      C={Comp S2 S3}
      S3='do'|S4
      X={Stat S4 Sn}
      while(C X)
   [] read then I in
      I={Id S2 Sn}
      read(I)
   [] write then E in
      E={Expr S2 Sn}
      write(E)
   elseif {IsIdent T} then E S3 in
      S2=':='|S3
      E={Expr S3 Sn}
      assign(T E)
   else
      S1=Sn
      raise error(S1) end
   end
end

declare A Sn in
A={Prog
   [program foo ';'
    while a '+' 3 '<' b 'do' b ':=' b '+' 1 'end']
   Sn}
{Browse A}

declare A Sn in
A={Comp
   [a '+' 3 '<' b]
   Sn}
{Browse A}



% 3.6
declare
proc {QuadraticEquation A B C ?RealSol ?X1 ?X2}
   D = B*B-4.0*A*C
in
   if D>0.0 then
      RealSol=true
      X1=(~B+{Sqrt D})/(2.0*A)
      X2=(~B-{Sqrt D})/(2.0*A)
   else
      RealSol=false
      X1=~B/(2.0*A)
      X2={Sqrt ~D}/(2.0*A)
   end
end

declare RS X1 X2 in
{QuadraticEquation 1.0 3.0 2.0 RS X1 X2}
{Browse RS#X1#X2}

declare RS X1 X2 in
{QuadraticEquation 1.0 ~3.0 2.0 RS X1 X2}
{Browse RS#X1#X2}

declare
fun {SumList L}
   case L
   of nil then 0
   [] X|L1 then X+{SumList L1}
   end
end

declare
fun {FoldR L F U}
   case L
   of nil then U
   [] X|L1 then {F X {FoldR L1 F U}}
   end
end

declare
fun {SumList L}
   {FoldR L fun {$ X Y} X + Y end 0}
end

{Browse {SumList [1 2 3]}}

declare
fun {ProductList L}
   {FoldR L fun {$ X Y} X*Y end 1}
end

{Browse {ProductList [1 2 3 4]}}

declare
fun {Some L}
   {FoldR L fun {$ X Y} X orelse Y end false}
end

{Browse {Some nil}}
{Browse {Some [false]}}
{Browse {Some [false true false]}}

declare
fun {GenericMergeSort F Xs}
   fun {Merge Xs Ys}
      case Xs # Ys
      of nil # Ys then Ys
      [] Xs # nil then Xs
      [] (X|Xr) # (Y|Yr) then
         if {F X Y} then X| {Merge Xr Ys}
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
in
   {MergeSort Xs}
end

declare
fun {MergeSort Xs}
   {GenericMergeSort fun {$ A B} A < B end Xs}
end

{Browse {MergeSort [ 3 4 1 5 9 2]}}

% mozart2 だと Number.'<' ではなく Value.'<' だった
declare
fun {MergeSort Xs}
   {GenericMergeSort Value.'<' Xs}
end

{Browse {MergeSort [ 3 4 1 5 9 2]}}

%3.6.2

declare
fun {FoldL L F U}
   case L
   of nil then U
   [] X|L2 then
      {FoldL L2 F {F U X}}
   end
end

{Browse {FoldL [1 2 3] Number.'+' 0}}

declare
fun {FoldR L F U}
   fun {Loop L U}
      case L
      of nil then U
      [] X|L2 then
         {Loop L2 {F X U}}
      end
   end
in
   {Loop {Reverse L} U}
end

{Browse {FoldR [1 2 3] Number.'+' 0}}

declare
L=for I in 1..100 collect:C do
     if I mod 2 \= 0 andthen I mod 3 \= 0 then {C I} end
  end

{Browse L}

declare
L=for I in 1..100 collect:C do
     if I mod 2 \= 0 andthen I mod 3 \= 0 then
        for J in 2..10 do
           if I mod J == 0 then {C I#J} end
        end
     end
  end

{Browse L}

% 3.6.4

declare
fun {Map Xs F}
   case Xs
   of nil then nil
   [] X|Xr then {F X} | {Map Xr F}
   end
end

declare
fun {Map Xs F}
   {FoldR Xs fun {$ I A} {F I}|A end nil}
end

{Browse {Map [1 2 3] fun {$ I} I*I end}}

declare
fun {Map Xs F}
   {Reverse {FoldL Xs fun {$ A I} {F I}|A end nil}}
end

{Browse {Map [1 2 3] fun {$ I} I*I end}}

declare
fun {Filter Xs F}
   case Xs
   of nil then nil
   [] X|Xr andthen {F X} then X| {Filter Xr F}
   [] X|Xr then {Filter Xr F}
   end
end

{Browse {Filter [1 2 3 4] fun {$ A} A <3 end}}

declare
fun {Filter Xs F}
   {FoldR Xs fun {$ I A} if {F I} then I|A else A end end nil}
end

{Browse {Filter [1 2 3 4] fun {$ A} A <3 end}}

%3.6.4.2

declare
proc {VisitNodes Tree P}
   case Tree of tree(sons:Sons ...) then
      {P Tree}
      for T in Sons do {VisitNodes T P} end
   end
end

declare
proc {VisitLinks Tree P}
   case Tree of tree(sons:Sons ...) then
      for T in Sons do {P Tree T}  {VisitLinks T P} end
   end
end

declare
local
   fun {FoldTreeR Sons TF LF U}
      case Sons
      of nil then U
      [] S|Sons2 then
         {LF {FoldTree S TF LF U} {FoldTreeR Sons2 TF LF U}}
      end
   end
in
   fun {FoldTree Tree TF LF U}
      case Tree of tree(node:N sons:Sons ...) then
         {TF N {FoldTreeR Sons TF LF U}}
      end
   end
end

declare
T=tree(node:1
       sons:[tree(node:2 sons:nil)
             tree(node:3 sons:[tree(node:4 sons:nil)])])
{Browse {FoldTree T Number.'+' Number.'+' 0}}

% 3.7

declare
fun {NewStack} nil end
fun {Push S E} E|S end
fun {Pop S E} case S of X|S1 then E=X S1 end end
fun {IsEmpty S} S==nil end

declare S1 S2 S3 S4 S5 E2 E1 in
S1={NewStack}
S2={Push S1 1}
S3={Push S2 2}
{Browse S3}
S4={Pop S3 E2}
{Browse E2}
S5={Pop S4 E1}
{Browse E1}

declare
fun {NewStack} stackEmpty end
fun {Push S E} stack(E S) end
fun {Pop S E} case S of stack(X S1) then E=X S1 end end
fun {IsEmpty S} S==stackEmpty end

declare S1 S2 S3 S4 S5 E2 E1 in
S1={NewStack}
S2={Push S1 1}
S3={Push S2 2}
{Browse S3}
S4={Pop S3 E2}
{Browse E2}
S5={Pop S4 E1}
{Browse E1}

declare
fun {NewDictionary} nil end
fun {Put Ds Key Value}
   case Ds
   of nil then [Key#Value]
   [] (K#_)|Dr andthen K==Key then
      (Key#Value)|Dr
   [] (K#V)|Dr andthen K>Key then
      (Key#Value)| (K#V) |Dr
   [] (K#V)|Dr andthen K<Key then      
      (K#V) | {Put Dr Key Value}
   end
end
fun {CondGet Ds Key Default}
   case Ds
   of nil then Default
   [] (K#V)|_ andthen K==Key then
      V
   [] (K#_)|_ andthen K>Key then
      Default
   [] (K#_)|Dr andthen K<Key then      
      {CondGet Dr Key Default}
   end
end
fun {Domain Ds}
   {Map Ds fun {$ K#_} K end}
end

declare D1 D2 D3 in
D1={Put {NewDictionary} 10 a}
D2={Put D1 5 b}
D3={Put D2 15 c}
{Browse D3}
{Browse {Domain D3}}
{Browse {CondGet D3 10 unk}}
{Browse {CondGet D3 1 unk}}

declare
fun {NewDictionary} leaf end
fun {Put Ds Key Value}
   case Ds
   of leaf then tree(Key Value leaf leaf)
   [] tree(K _ T1 T2) andthen K==Key then tree(Key Value T1 T2)
   [] tree(K V T1 T2) andthen K>Key then tree(K V {Put T1 Key Value } T2)
   [] tree(K V T1 T2) andthen K<Key then tree(K V T1 {Put T2 Key Value})
   end
end
fun {CondGet Ds Key Default}
   case Ds
   of leaf then Default
   [] tree(K V T1 T2) then
      if K>Key then {CondGet T1 Key Default}
      elseif K<Key then {CondGet T2 Key Default}
      else V end
   end
end
fun {Domain Ds}
   proc {DomainD Ds ?S1 Sn}
      case Ds
      of leaf then
         S1=Sn
      [] tree(K _ L R) then S2 S3 in
         {DomainD L S1 S2}
         S2=K|S3
         {DomainD R S3 Sn}
      end
   end D
in
   {DomainD Ds D nil} D
end

declare D1 D2 D3 D4 in
D1={Put {NewDictionary} 10 a}
D2={Put D1 5 b}
D3={Put D2 15 c}
D4={Put D3 10 d}
{Browse D3}
{Browse {Domain D3}}
{Browse {CondGet D4 10 unk}}
{Browse {CondGet D4 1 unk}}

%3.7.3

declare
fun {WordChar C}
   (&a=<C andthen C=<&z) orelse
   (&A=<C andthen C=<&Z) orelse (&0=<C andthen C=<&9)
end
fun {WordToAtom PW}
   {StringToAtom {Reverse PW}}
end
fun {IncWord D W}
   {Put D W {CondGet D W 0}+1}
end
fun {CharsToWords PW Cs}
   case Cs
   of nil andthen PW==nil then
      nil
   [] nil then
      [{WordToAtom PW}]
   [] C|Cr andthen {WordChar C} then
      {CharsToWords {Char.toLower C}|PW Cr}
   [] _|Cr andthen PW==nil then
      {CharsToWords nil Cr}
   [] _|Cr then
      {WordToAtom PW}|{CharsToWords nil Cr}
   end
end
fun {CountWords D Ws}
   case Ws
   of W|Wr then {CountWords {IncWord D W} Wr}
   [] nil then D
   end
end
fun {WordFreq Cs}
   {CountWords {NewDictionary} {CharsToWords nil Cs}}
end
      

declare
T="Oh my darling, oh my darling, oh my darling, Clementine.
She is lost and gone forever, oh my darling, Clementine"
{Browse {WordFreq T}}
%{Browse {CharsToWords nil T}}
%{Browse {WordToAtom "abc"}}

