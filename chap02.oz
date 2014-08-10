declare
proc {Max X Y ?Z}
   if X>=Y then Z=X else Z=Y end
end

declare C
{Max 1 2 C}
{Browse C}

local P Q in
   proc {Q X} {Browse start(X)} end
   proc {P X} {Q X} end
   local Q in
      proc {Q X} {Browse dyn(X)} end
      {P hello}
   end
end

local X Y Z in
   f(X b) = f(a Y)
   f(Z a) = Z
   {Browse [X Y Z]}
end

declare X Y Z in
a(X c(Z) Z) = a(b(Y) Y d(X))
{Browse X#Y#Z}

declare L1 L2 L3 Head Tail in
L1 = Head|Tail
Head = 1
Tail = 2|nil

L2 = [1 2]
{Browse L1==L2}

L3='|'(1:1 2:'|'(2 nil))
{Browse L1==L3}

declare L1 L2 X in
L1=[X]
L2=[X]
{Browse L1==L2}

declare L1 L2 X in
L1=[1 a]
L2=[X b]
{Browse L1==L2}

% ex
declare MulByN N in
N=3
proc {MulByN X ?Y}
   Y=N*X
end

declare A = 10  B

{MulByN A B}
{Browse B}

% 一度 Oz を終了させる
declare A = 10  B

local MulByN in
   local N in
      N = 3
      proc {MulByN X ?Y}
         Y=N*X
      end
   end
   {MulByN A B}
   {Browse B}
end

local MulByN N in
   local N in
      N = 3
      proc {MulByN X ?Y}
         Y=N*X
      end
   end
   N=10
   {MulByN A B}
   {Browse B}
end

% ex. 3
declare
fun {Iftest N}
   if N==1 then
      10
   end
end

{Browse {Iftest 1}}
{Browse {Iftest 2}}

declare
proc {IftestProc N ?R}
   if N==1 then
      R=10
   end
end

declare R
{IftestProc 2 R}
{Browse R}

% ex. 4

declare
fun {IfWithCase P C A}
   case P
   of true then {C}
   else {A}
   end
end

{Browse {IfWithCase
         1==1
         fun {$} 10 end
         fun {$} 5 end
        }} 

{Browse {IfWithCase
         1==2
         fun {$} 10 end
         fun {$} 5 end
        }} 

% https://github.com/Altech/ctmcp-answers/blob/master/Section02/exer04.oz

% ex. 5

declare
proc {Test X}
   case X
   of a|Z then {Browse 'case'(1)}
   [] f(a) then {Browse 'case'(2)}
   [] Y|Z andthen Y==Z then {Browse 'case'(3)}
   [] Y|Z then {Browse 'case'(4)}
   [] f(Y) then {Browse 'case'(5)}
   else {Browse 'case'(6)} end
end

{Test [b c a]}
{Test f(b(3))}
{Test f(a)}
{Test f(a(3))}
{Test f(d)}
{Test [a b c]}
{Test [c a b]}
{Test a|a}
{Test '|'(a b c)}

{Test b|b}
