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
