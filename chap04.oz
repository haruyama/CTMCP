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
X=1|0|0|_
Y=0|1|0|_
O in
O={Latch X Y}
{Browse inp(X Y)#out(O)}
