declare
fun {Gen L H}
   {Delay 1000}
   if L>H then nil else L|{Gen L+1 H} end
end
Xs = {Gen 1 10}
Ys = {Map Xs fun {$ X} X*X end}
{Browse Ys}

declare
fun {Gen L H}
   {Delay 1000}
   if L>H then nil else L|{Gen L+1 H} end
end
thread Xs = {Gen 1 10} end
thread Ys = {Map Xs fun {$ X} X*X end} end
{Browse Ys}

declare X Y
thread X=1 end
thread Y=2 end
thread X=Y end

declare X Y
local X1 Y1 S1 S2 S3 in
   thread
      try X1=1 S1=ok catch _ then S1=error end
   end
   thread
      try Y1=2 S2=ok catch _ then S2=error end
   end
   thread
      try X1=Y1 S3=ok catch _ then S3=error end
   end
   if S1==error orelse S2==error orelse S3==error then
      X=1
      Y=1
   else X=X1 Y=Y1 end
   {Browse S1}
   {Browse S2}
   {Browse S3}
end
{Browse X}
{Browse Y}

% 4.2

declare
thread
   proc {Count N} if N>0 then {Count N-1} end end
in
   {Count 1000000}
   {Browse done}
end
{Browse main}

declare X in
X = thread 10*10 end + 100 * 100
{Browse X}

declare X1 X2 Y1 Y2 in
thread {Browse X1} end
thread {Browse Y1} end
thread X1=all|roads|X2 end
thread Y1=all|roams|Y2 end
thread X2=lead|to|rome|_ end
thread Y2=lead|to|rhodes|_ end

declare X0 X1 X2 X3 in
thread
   Y0 Y1 Y2 Y3 in
   {Browse [Y0 Y1 Y2 Y3]}
   Y0=X0+1
   Y1=X1+Y0
   Y2=X2+Y1
   Y3=X3+Y2
   {Browse complated}
end
{Browse [X0 X1 X2 X3]}

X0=0
X1=1
X2=2
X3=3

declare L in
thread {ForAll L Browse} end

declare L1 L2 in
thread L=1|L1 end
thread L1=2|3|L2 end
thread L2=4|nil end

declare
fun {PMap Xs F}
   case Xs of nil then nil
   [] X|Xr then thread {F X} end|{PMap Xr F} end
end

declare F Xs Ys Zs
{Browse thread {PMap Xs F} end}

Xs=1|2|Ys
fun {F X} X*X end

Ys=3|Zs
Zs=nil

% declare F Xs Ys Zs
% {Browse {PMap Xs F}}

% Xs=1|2|Ys
% fun {F X} X*X end

% Ys=3|Zs
% Zs=nil

declare
fun {Fib X}
   {Delay 1000}
   if X=<2 then 1
   else thread {Fib X-1} end + {Fib X-2} end
end

{Browse {Fib 26}}

{Browse {Thread.this}}
{Browse {Thread.state {Thread.this}}}

% 4.3 ストリーム

declare
fun {Generate N Limit}
   if N<Limit then
      N| {Generate N+1 Limit}
   else nil end
end

fun {Sum Xs A}
   case Xs
   of X|Xr then {Sum Xr A+X}
   [] nil then A
   end
end

local Xs S in
   thread Xs = {Generate 0 150000} end
   thread S = {Sum Xs 0} end
   {Browse S}
end

local Xs S in
   thread Xs = {Generate 0 150000} end
   thread S = {FoldL Xs fun {$ X Y} X+Y end 0} end
   {Browse S}
end

local Xs S1 S2 S3  in
   thread Xs = {Generate 0 150000} end
   thread S1 = {Sum Xs 0} end
   thread S2 = {Sum Xs 0} end
   thread S3 = {Sum Xs 0} end
   {Browse S1}
   {Browse S2}
   {Browse S3}
end


declare
fun {IsOdd X} X mod 2 \= 0 end

local Xs Ys S in
   thread Xs = {Generate 0 150000} end
   thread Ys = {Filter Xs IsOdd} end
   thread S = {Sum Ys 0} end
   {Browse S}
end

declare
fun {Sieve Xs}
   case Xs
   of nil then nil
   [] X|Xr then Ys in
      thread Ys={Filter Xr fun {$ Y} Y mod X \= 0 end} end
      X|{Sieve Ys}
   end
end

local Xs Ys in
   thread Xs={Generate 2 100000} end
   thread Ys={Sieve Xs} end
   {Browse Ys}
end

declare
fun {Sieve Xs M}
   case Xs
   of nil then nil
   [] X|Xr then Ys in
      if X=< M then
         thread Ys={Filter Xr fun {$ Y} Y mod X \= 0 end} end
      else Ys=Xr end
      X|{Sieve Ys M}
   end
end

local Xs Ys in
   thread Xs={Generate 2 100000} end
   thread Ys={Sieve Xs 316} end
   {Browse Ys}
end
% 4.3.3

declare
proc {DGenerate N Xs}
   case Xs of X|Xr then
      X=N
      {DGenerate N+1 Xr}
   end
end

fun {DSum ?Xs A Limit}
   if Limit > 0 then
      X|Xr=Xs
   in
      {DSum Xr A+X Limit-1}
   else A end
end

local Xs S in
   thread {DGenerate 0 Xs} end
   thread S={DSum Xs 0 150000} end
   {Browse S}
end
   
%4.4.4
declare
proc {Buffer N ?Xs Ys}
   fun {Startup N ?Xs}
      if N==0 then Xs
      else Xr in Xs=_|Xr {Startup N-1 Xr} end
   end

   proc {AskLoop Ys ?Xs ?End}
      case Ys of Y|Yr then Xr End2 in
         Xs=Y|Xr
         End=_|End2
         {AskLoop Yr Xr End2}
      end
   end
   End={Startup N Xs}
in
   {AskLoop Ys Xs End}
end

local Xs Ys S in
   thread {DGenerate 0 Xs} end
   thread {Buffer 4 Xs Ys} end
   thread S={DSum Ys 0 150000} end
   {Browse Xs} {Browse Ys}
   {Browse S}
end

declare
fun {DSum ?Xs A Limit}
   {Delay 1000}
   if Limit > 0 then
      X|Xr=Xs
   in
      {DSum Xr A+X Limit-1}
   else A end
end
local Xs Ys S in
   thread {DGenerate 0 Xs} end
   thread {Buffer 4 Xs Ys} end
   thread S={DSum Ys 0 150000} end
   {Browse Xs} {Browse Ys}
   {Browse S}
end

declare
fun {DSum ?Xs A Limit}
   if Limit > 0 then
      X|Xr=Xs
   in
      {DSum Xr A+X Limit-1}
   else A end
end

%4.3.4

% proc {StreamObject S1 X1 ?T1}
%    case S1
%    of M|S2 then N X2 T2 in
%       T1=N|T2
%       {StreamObject S2 X2 T2}
%    [] nil then T1=nil end
% end

% declare S0 X0 T0 in
% thread
%    {StreamObject S0 X0 T0}
% end

% 4.3.5
declare
fun {NotGate Xs}
   case Xs of X|Xr then (1-X)|{NotGate Xr} end
end

local
   fun {NotLoop Xs}
      case Xs of X|Xr then (1-X)|{NotLoop Xr} end
   end
in
   fun {NotG Xs}
      thread {NotLoop Xs} end
   end
end

fun {GateMaker F}
   fun {$ Xs Ys}
      fun {GateLoop Xs Ys}
         case Xs#Ys of (X|Xr)#(Y|Yr) then
            {F X Y}| {GateLoop Xr Yr}
         end
      end
   in
      thread {GateLoop Xs Ys} end
   end
end

AndG={GateMaker fun {$ X Y} X*Y end}
OrG={GateMaker fun {$ X Y} X+Y-X*Y end}
NandG={GateMaker fun {$ X Y} 1-X*Y end}
NorG={GateMaker fun {$ X Y} 1-X-Y+X*Y end}
XorG={GateMaker fun {$ X Y} X+Y-2*X*Y end}

declare
proc {FullAdder X Y Z ?C ?S}
   K L M
in
   K={AndG X Y}
   L={AndG Y Z}
   M={AndG X Z}
   C={OrG K {OrG L M}}
   S={XorG Z {XorG X Y}}
end

declare
X=1|1|1|_
Y=0|1|0|_
Z=1|1|1|_ C S in
{FullAdder X Y Z C S}
{Browse inp(X Y Z)#sum(C S)}

%4.3.5.2

declare
fun {DelayG Xs}
   0|Xs
end

fun {Latch C DI}
   DO X Y Z F
in
   F={DelayG DO}
   X={AndG F C}
   Z={NotG C}
   Y={AndG Z DI}
   DO={OrG X Y}
   DO
end

declare
C= 1|1|0|0|1|_
DI=0|1|0|1|0|_
O in
O={Latch C DI}
{Browse inp(C DI)#out(O)}

% 4.4

% 4.5
declare
fun lazy {F1 X} 1+X*(3+X*(3+X)) end
fun lazy {F2 X} Y=X*X in Y*Y end
fun lazy {F3 X} (X+1)*(X+1) end
A={F1 10}
B={F2 20}
C={F3 30}
D=A+B
{Browse A#B#C#D}

% C は未定義のまま

% 4.5.1
declare Y
{ByNeed proc {$ A} A=111*111 end Y}
{Browse Y}


declare Y
{ByNeed proc {$ A} A=111*111 end Y}
Z=Y+1
{Browse Y}

declare X Y Z
thread X={ByNeed fun {$} 3 end} end
thread Y={ByNeed fun {$} 4 end} end
thread Z=X+Y end
{Browse Z}

declare X Z
thread X={ByNeed fun {$} {Browse x} 3 end} end
thread X=2 end
thread Z=X+4 end
{Browse Z}

declare X Y Z
thread X={ByNeed fun {$} {Browse x} 3 end} end
thread X=Y end
thread if X==Y then Z=10 end end
{Browse Z}

declare
fun lazy {Generate N} N| {Generate N+1} end
L={Generate 0}
{Browse L}
{Browse L.2.2.1}

declare
fun {Generate N}
   {ByNeed fun {$} N| {Generate N+1} end}
end
L={Generate 0}
{Browse L}
{Browse L.2.2.1}

% 4.5.2

declare X
thread X={fun lazy {$} 11*11 end} end
thread {Wait X} end
{Browse X}

% mozart 2 では表示されない (2015/01/18)
% mozart 2 は引数を直列に計算しているようにみえる...
local
   Z
   fun lazy {F1 X} X+Z end
   fun lazy {F2 Y} Z=1 Y+Z end
in
   {Browse {F1 1} + {F2 2}}
end

local
   Z
   fun lazy {F1 X} {Browse x} _=X+Z {Browse y} X+Z end
   fun lazy {F2 Y} Z=1 Y+Z end
in
   {Browse {F1 1} + {F2 2}}
end

% mozart 2 で表示される (2015/01/18)
local
   Z
   fun lazy {F1 X} X+Z end
   fun {F2 Y} Z=1 Y+Z end
in
   {Browse {F1 1} + {F2 2}}
end

local
   Z
   fun {F1 X} thread X+Z end end 
   fun {F2 Y} thread Z=1 Y+Z end end
in
   {Browse {F1 1} + {F2 2}}
end

local
   Z
   fun lazy {F1 X} X+Z end
   fun lazy {F2 Y} Z=1 Y+Z end
in
   {Browse {F2 2} + {F1 1}}
end

% 4.5.3
declare
fun lazy {Generate N}
   N|{Generate N+1}
end
fun {Sum Xs A Limit}
   if Limit>0 then
      case Xs of X|Xr then
         {Sum Xr A+X Limit-1}
      end
   else A end
end
local Xs S in
   Xs={Generate 0}
   S={Sum Xs 0 150000}
   {Browse S}
end
   
local Xs S1 S2 S3 in
   Xs={Generate 0}
   thread S1={Sum Xs 0 150000} end
   thread S2={Sum Xs 0 100000} end
   thread S3={Sum Xs 0 50000} end
   {Browse S1}
   {Browse S2}
   {Browse S3}
end
   
% 4.5.4
fun {Buffer1 In N}
   End={List.drop In N}
   fun lazy {Loop In End}
      case In of I|In2 then
         I|{Loop In2 End.2}
      end
   end
in
   {Loop In End}
end

declare
fun {Buffer2 In N}
   End=thread {List.drop In N} end
   fun lazy {Loop In End}
      case In of I|In2 then
         I|{Loop In2 thread End.2 end}
      end
   end
in
   {Loop In End}
end

declare
fun lazy {Ints N}
   {Delay 1000}
   N| {Ints N+1}
end

declare
In={Ints 1}
Out={Buffer2 In 5}
{Browse Out}
{Browse Out.1}
{Browse Out.2.2.2.2.2.2.2.2.2.2}

% 4.5.6
% ozc -c File.oz
declare [File]={Module.link ['File.ozf']}
fun {ReadListLazy FN}
   {File.readOpen FN}
   fun lazy {ReadNext}
      L T I in
      {File.readBlock I L T}
      if I == 0 then T=nil {File.readClose}
      else T={ReadNext} end
      L
   end
in
   {ReadNext}
end

declare
L1={ReadListLazy "chap04.oz"}
{Browse L1}
{Wait L1}

% 4.5.6
declare
fun lazy {Times N H}
   case H of X|H2 then N*X|{Times N H2} end
end

fun lazy {Merge Xs Ys}
   case Xs#Ys of (X|Xr)#(Y|Yr) then
      if X<Y then X|{Merge Xr Ys}
      elseif X>Y then Y|{Merge Xs Yr}
      else X|{Merge Xr Yr}
      end
   end
end

H=1|{Merge {Times 2 H}
           {Merge {Times 3 H}
                  {Times 5 H}}}
{Browse H}

proc {Touch N H}
   if N>0 then {Touch N-1 H.2} else skip end
end
{Touch 20 H}

% 4.5.7

declare
fun lazy {LAppend As Bs}
   case As
   of nil then Bs
   [] A|Ar then A| {LAppend Ar Bs}
   end
end

L={LAppend "foo" "bar"}
{Browse L}
{Touch 4 L}

declare
fun lazy {MakeLazy Ls}
   case Ls
   of X|Lr then X| {MakeLazy Lr}
   else nil end
end
L={LAppend "foo" {MakeLazy "bar"}}
{Browse L}
{Touch 4 L}

declare
fun lazy {LMap Xs F}
   case Xs
   of nil then nil
   [] X|Xr then {F X}|{LMap Xr F}
   end
end

declare
L={LMap [1 2 3] fun {$ X} X*2 end}
{Browse L}
{Touch 2 L}

declare
fun {LFrom I J}
   fun lazy {LFromLoop I}
      if I>J then nil else I|{LFromLoop I+1} end
   end
   fun lazy {LFromInf I} I| {LFromInf I+1} end
in
   if J==inf then {LFromInf I} else {LFromLoop I} end
end

declare
fun {LFlatten Xs}
   fun lazy {LFlattenD Xs E}
      case Xs
      of nil then E
      [] X|Xr then
         {LFlattenD X {LFlattenD Xr E}}
      [] X then X|E
      end
   end
in
   {LFlattenD Xs nil}
end

L={LFlatten [1 2 [3 4] 5]}
{Browse L}
{Touch 3 L}

declare
fun {LReverse S}
   fun lazy {Rev S R}
      case S
      of nil then R
      [] X|S2 then {Rev S2 X|R} end
   end
in {Rev S nil} end

L={LReverse [a b c]}
{Browse L}
{Touch 1 L}

declare
fun lazy {LFilter L F}
   case L
   of nil then nil
   [] X|L2 then
      if {F X} then X|{LFilter L2 F} else {LFilter L2 F} end
   end
end

L={LFilter [1 2 3 4 5] fun {$ X} X\=3 end}
{Browse L}
{Touch 3 L}

% 4.5.8

% 4.5.8.1
declare
fun {NewQueue} q(0 nil 0 nil) end

fun {Check Q}
   case Q of q(LenF F LenR R) then
      if LenF >=LenR then Q
      else q(LenF+LenR {LAppend F {fun lazy {$} {Reverse R} end}} 0 nil)
      end
   end
end

fun {Insert Q X}
   case Q of q(LenF F LenR R) then
      {Check q(LenF F LenR+1 X|R)}
   end
end

fun {Delete Q X}
   case Q of q(LenF F LenR R) then F1 in
      F=X|F1 {Check q(LenF-1 F1 LenR R)}
   end
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


% 4.5.8.2

declare
fun lazy {LAppRev F R B}
   case F#R
   of nil#[Y] then Y|B
   [] (X|F2)#(Y|R2) then X|{LAppRev F2 R2 Y|B}
   end
end

declare
fun {Check Q}
   case Q of q(LenF F LenR R) then
      if LenF>=LenR then Q
      else q(LenF+LenR {LAppend F {LAppRev F R nil}} 0 nil)
      end
   end
end

% 問題 20

% 4.5.9

declare
fun {From I J}
   fun {FromLoop I}
      if I>J then nil else I|{FromLoop I+1} end
   end
in
   {FromLoop I}
end
Z={Map {From 1 10} fun {$ X} X#X end}
{Browse Z}

declare
Z={LMap {LFrom 1 10} fun {$ X} X#X end}
{Browse Z}
{Touch 5 Z}

declare
Z={LFlatten
   {LMap {LFrom 1 10} fun {$ X}
                         {LMap {LFrom 1 X} fun {$ Y}
                                              X#Y
                                           end}
  end}}
{Browse Z}
{Touch 5 Z}

declare
fun {FMap L F}
   {LFlatten {LMap L F}}
end
Z={FMap {LFrom 1 10} fun {$ X}
                        {LMap {LFrom 1 X} fun {$ Y}
                                             X#Y
                        end}
  end}
{Browse Z}
{Touch 5 Z}

declare
Z={LFilter {FMap {LFrom 1 10} fun {$ X}
                 {LMap {LFrom 1 10} fun {$ Y}
                       X#Y
                       end}
                              end}
   fun {$ X#Y} X+Y=<10 end}
{Browse Z}
{Touch 20 Z}

declare
Z={FMap {LFrom 1 10} fun {$ X}
                        {LMap {LFrom 1 10-X} fun {$ Y}
                                             X#Y
                        end}
  end}
{Browse Z}
{Touch 20 Z}

% 4.6
