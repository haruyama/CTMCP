% 1
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer1.mkd

local B in
   thread B=true end
   thread B=false end
   if B then {Browse yes} end
end

local B in
   thread B=true end
%   thread B=false end
   if B then {Browse yes} end
end

% 2
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer2.mkd

% 3
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer3.oz

declare
fun {Fib X}
   if X =< 2 then 1
   else {Fib X-1} + {Fib X-2} end
end
fun {ConcurrentFib X}
   if X =< 2 then 1
   else thread {ConcurrentFib X-1} end + {ConcurrentFib X-2} end
end
fun {ElapsedTime P Size}
   Start={Time.time} Fin Result
in
   Result = {P Size}
   Fin = {Time.time}
   Fin-Start
end

%{Browse {ElapsedTime Fib 30}}
%{Browse {ElapsedTime ConcurrentFib 30}}

% 4

declare A B C D in
thread D=C+1 end
thread C=B+1 end
thread A=1 end
thread B=A+1 end
{Browse D}

declare A B C D in
A=1
B=A+1
C=B+1
D=C+1
{Browse D}

% 5
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer5.mkd

% 6
% 4.3.1
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

declare
fun {Skip Xs}
   if {IsDet Xs} then
      case Xs of _|Xr then {Skip Xr}
      [] nil then nil end
   else Xs end
end

local Xs S in
   thread Xs = {Generate 0 150000} end
   thread S = {Sum {Skip Xs} 0} end
   {Browse S}
end

% 7
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer7.oz

declare
% proc {DGenerate N ?Xs}
%    NewXs
%    fun{F2}
%       {DGenerate N+1 NewXs}
%       NewXs
%    end
% in
%    Xs=N#F2
% end
fun {DGenerate N}
   N # fun {$}
          {DGenerate N+1}
       end
end
fun {DSum Xs ?A Limit}
   if Limit>0 then
      X#F2=Xs
   in
      {DSum {F2} A+X Limit-1}
   else
      A
   end
end
local Xs S in
   % {DGenerate 0 Xs}
   Xs={DGenerate 0}
   S={DSum Xs 0 3}
   {Browse S}
end

% 8
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer8.mkd
declare
fun {Filter In F}
    case In
    of X|In2 then
        if {F X} then X|{Filter In2 F} 
        else {Filter In2 F} end
    else
        nil
    end
end

{Browse {Filter [5 1 2 4 0] fun {$ X} X>2 end}}
{Show 'Hello World'}

declare A
{Show {Filter [5 1 A 4 0] fun {$ X} X>2 end}}
{Browse {Filter [5 1 A 4 0] fun {$ X} X>2 end}}

declare A Out
thread Out={Filter [5 1 A 4 0] fun {$ X} X>2 end} end
{Show Out}
{Browse Out}

declare Out A C
thread Out={Filter [5 1 A 4 0] fun {$ X} X>2 end} end
{Delay 1000}
{Show Out}
{Browse Out}

declare Out A C
thread Out={Filter [5 1 A 4 0] fun {$ X} X>2 end} end
thread A=6 end
{Delay 1000}
{Show Out}
{Browse Out}

% 9
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer9.oz

declare
local
   fun {NotLoop Xs}
      case Xs of X|Xr then (1-X)|{NotLoop Xr} end
   end
in
   fun {NotG Xs}
      thread {NotLoop Xs} end
   end
end
fun {GenerateGate F}
   fun{$ Xs Ys}
      fun {FLoop Xs Ys}
         case Xs#Ys of (X|Xr)#(Y|Yr) then {F X Y}|{FLoop Xr Yr} end
      end
   in
      thread {FLoop Xs Ys} end
   end
end
AndG={GenerateGate fun {$ X Y} X*Y end}
OrG ={GenerateGate fun{$ X Y} X+Y-X*Y end}
XOrG ={GenerateGate fun{$ X Y} X+Y-2*X*Y end}
declare
proc {FullAdder X Y Z ?C ?S}
   K L M
in
   K={AndG X Y}
   L={AndG Y Z}
   M={AndG Z X}
   C={OrG {OrG K L} M}
   S={XOrG {XOrG X Y} Z}
end
declare
Z0=0|0|0|_
X0=1|1|0|_ Y0=0|1|0|_ C0 S0
X1=0|0|1|_ Y1=1|1|1|_ C1 S1
X2=0|0|0|_ Y2=0|0|0|_ C2 S2
in
{FullAdder X0 Y0 Z0 C0 S0}
{FullAdder X1 Y1 C0 C1 S1}
{FullAdder X2 Y2 C1 C2 S2}
{Browse input}
{Browse X0#Y0}
{Browse X1#Y1}
{Browse X2#Y2}
{Browse output}
{Browse S0}
{Browse S1}
{Browse S0}

% 10
declare
fun lazy {Three} {Delay 1000} 3 end
{Browse {Three}+0}
{Browse {Three}+0}
{Browse {Three}+0}

% 11
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer11.oz

declare
fun lazy {MakeX} {Browse x} {Delay 3000} 1 end
fun lazy {MakeY} {Browse y} {Delay 6000} 2 end
fun lazy {MakeZ} {Browse z} {Delay 9000} 3 end
X={MakeX}
Y={MakeY}
Z={MakeZ}
{Browse (X+Y)+Z}
{Browse thread X+Y end +Z}

declare
Ls=[X Y Z]
thread X={MakeX} end
thread Y={MakeY} end
thread Z={MakeZ} end
{Browse {FoldL Ls fun{$ X Y} thread X+Y end end 0}}

% 10
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer10.mkd

% 11

% 2015/02 の mozart2 の実装では期待通りに動かない模様
declare
fun lazy {MakeX} {Browse x} {Delay 3000} 1 end
fun lazy {MakeY} {Browse y} {Delay 6000} 2 end
fun lazy {MakeZ} {Browse z} {Delay 9000} 3 end
X={MakeX}
Y={MakeY}
Z={MakeZ}
{Browse (X+Y)+Z}
%{Browse thread X+Y end +Z}
%{Browse X + thread Y + Z end}
%{Browse {FoldL [X Y Z] fun {$ X Y} thread X+Y end end 0}}

% 12
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer12.mkd

% 13
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer13.mkd

% 14
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer14.mkd

% 15
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer15.oz

% 16
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer16.oz

% 17
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer17.oz

declare
fun lazy {LFilter Xs F}
   case Xs
   of nil then nil
   [] X|Xr then if {F X} then X|{LFilter Xr F} else {LFilter Xr F} end
   end
end
fun lazy {Generate N}
   N|{Generate N+1}
end
fun {Sieve Xs N}
   if N == 0 then nil
   else
      case Xs of X|Xr then Ys in
         Ys = {LFilter Xr fun {$ Y} Y mod X \= 0 end}
         X|{Sieve Ys N-1}
      end
   end
end
fun {GetPrimes N}
   {Sieve {Generate 2} N}
end
% Tools
declare
proc {Touch N H}
   if N>0 then {Touch N-1 H.2} else skip end
end
fun lazy {Times N H}
   case H of X|H2 then N*X|{Times N H2} else nil end
end
fun lazy {Merge Xs Ys}
   case Xs#Ys of (X|Xr)#(Y|Yr) then
      if X<Y then X|{Merge Xr Ys}
      elseif X>Y then Y|{Merge Xs Yr}
      else X|{Merge Xr Yr}
      end
   end
end
fun {MergeN Hs}
   case Hs
   of H1|H2|nil then {Merge H1 H2}
   [] H|Hr then {Merge H {MergeN Hr}}
   end
end
% Main
declare
fun {Hamming N K}
   Primes = {GetPrimes K}
   H = 1|{MergeN {Map Primes fun{$ Prime} {Times Prime H} end}}
in
   {Touch N H}
   H
end
{Browse {Hamming 30 3}}

% 18
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer18.oz

declare
proc {TryFinally S1 S2}
   B Y
in
   try {S1} B=false catch X then B=true Y=X end
   {S2}
   if B then raise Y end end
end
local U=1 V=2 in
   {TryFinally
    proc{$}
       thread
          {TryFinally proc{$} U=V end proc{$} {Browse bing} end}
       end
    end
    proc{$} {Browse bong} end
   }
end

% 手元ではすべて bong bing
% bing bong もありえるはず

% 19
% https://github.com/Altech/ctmcp-answers/blob/master/Section04/exer19.mkd

% 20
% http://www.kmonos.net/pub/Presen/PFDS.pdf


