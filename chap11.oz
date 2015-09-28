declare
X=the_novel(text:"text" author:"hoge" year:1803)
{Browse {Connection.offerUnlimited X}}


declare
X2={Connection.take 'oz-ticket://127.0.1.1:9000/h4396220#0'}
{Browse X2}

declare
proc {Offer X FN}
   {Pickle.save {Connection.offerUnlimited X} FN}
end
fun {Take FNURL}
   {Connection.take {Pickle.load FNURL}}
end

%11.3.4

declare Xs Sum in
{Offer Xs tickfile}
fun {Sum Xs A}
   case Xs of X|Xr then {Sum Xr A+X} [] nil then A end
end
{Browse {Sum Xs 0}}

declare Xs Generate in
Xs={Take tickfile}
fun {Generate N Limit}
   if N<Limit then N|{Generate N+1 Limit} else nil end
end
Xs={Generate 0 150000}

declare S P in
{NewPort S P}
{Offer P tickfile}
for X in S do {Browse X} end

P={Take tickfile}
{Send P hello}
{Send P 'keep in touch'}

% 11.4

declare
fun {CorrectSimpleLock}
   Token={NewCell unit}
   proc {Lock P}
      Old New in
      {Exchange Token Old New}
      {Wait Old}
      try {P} finally New=unit end
   end
in
   'lock'('lock':Lock)
end

declare
class Coder
   attr seed
   meth init(S) seed:=S end
   meth get(X)
      X=@seed
      seed:=(@seed*1234+4449) mod 33667
   end
end
C={New Coder init(100)}
{Offer C tickfile}
   

% 11.5

declare
fun {NewStat Class Init}
   P Obj={New Class Init} in
   thread S in
      {NewPort S P}
      for M#X in S do
         try {Obj M} X=normal
         catch E then X=exception(E) end
      end
   end
   proc {$ M}
      X in
      {Send P M#X}
      case X of normal then skip
      [] exception(E) then raise E end end
   end
end

declare
C={NewStat Coder init(100)}
{Offer C tickfile}
C2={Take tickfile}
local A in
   {C2 get(A)} {Browse A}
end

%for I in 1..100000 do {C2 get(_)} end
%{Browse done}

% 11.6.3

declare
class ComputeServer
   meth init skip end
   meth run(P) {P} end
end
C={NewStat ComputeServer init}
fun {Fibo N}
   if N<2 then 1 else {Fibo N-1}+{Fibo N-2} end
end
local F in
   {C run(proc {$} F={Fibo 30} end)} {Browse F}
end
local F in
   F={Fibo 30} {Browse F}
end

   
declare S P in
{NewPort S P}
{Offer proc {$ M} {Send P M} end tickfile}
for X in S do {Browse X} end

declare Browse2 in
Browse2={Take tickfile}
{Browse2 message}

declare T F in
functor F
import OS
define
   T={OS.time}
end

declare
class ComputeServer
   meth init skip end
   meth run(F) {Module.apply [F] _} end
end
