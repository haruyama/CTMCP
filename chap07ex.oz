% 1

declare
fun {New2 Class}
   TInit = {NewName}
in
   {New
    class $ from Class
       meth !TInit skip end
    end
    TInit}
end

declare
class Counter
   attr val
   meth init(Value)
      val:=Value
   end
   meth browse
      {Browse @val}
   end
   meth inc(Value)
      val:=@val+Value
   end
end


declare
C={New2 Counter}
{C init(0)}
{C browse}

% 5
declare
class Server
   meth init skip end
   meth calc(X Y)
      Y=X*X+2.0*X+2.0
   end
end

declare
class Server
   meth init skip end
   meth calc(X Y)
      Y=X*X+2.0*X+2.0
   end
end
class Client
   attr server
   meth init(S)
      server:=S
   end
   meth calc(X Y)
      {@server calc(X Y)}
   end
end

declare
S={NewActive Server init}
C={NewActive Client init(S)}
{Browse {C calc(2.0 $)}}

% 6
% a. 短絡なし
declare
fun {Josephus3 N K}
   A={NewArray 1 N true}
   Last
   S={NewCell N}
   fun {Kill X}
      if X mod K == 0 then
         true
      else
         false
      end
   end
   Count={NewCell 0}
in
   for J in 0..N break:X do
      for I in 1..N do
         if A.I then
            Count:=@Count+1
            if @S==1 then
               Last=I
               {X}
            end
            if {Kill @Count} then
               S:=@S-1
               A.I:=false
            end
         end
      end
   end
   Last
end
      
declare
{Browse {Josephus3 40 3}}
{Browse {Josephus3 10 3}}

% b. 短絡あり
declare
fun {Josephus4 N K}
   Pred={NewArray 1 N 0}
   Succ={NewArray 1 N 0}
   fun {Iter I C S}
      if S==1 then I
      else
         if C mod K == 0 then
            Succ.(Pred.I) := Succ.I
            Pred.(Succ.I) := Pred.I
            {Iter Succ.I C+1 S-1}
         else
            {Iter Succ.I C+1 S}
         end
      end
   end
in
   for I in 2..N do Pred.I:=I-1 end
   Pred.1:=N
   for I in 1..(N-1) do Succ.I:=I+1 end
   Succ.N:=1
   {Iter 1 1 N}
end

declare
{Browse {Josephus4 40 3}}
{Browse {Josephus4 10 3}}
