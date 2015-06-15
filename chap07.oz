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
C={New Counter init(0)}
{C inc(6)}{C inc(6)}
{C browse}

local X in {C inc(X)} X=5 end
{C browse}

declare S in
local X in thread {C inc(X)} S=unit end X=5 end
{Wait S}{C browse}

declare
class OneApt
   attr streetName
   meth init(X) @streetName=X end
end
Apt1={New OneApt init(drottninggatan)}
Apt2={New OneApt init(rueNeuve)}
%{Browse Apt1}
%{Browse Apt2}

declare
class YorkApt
   attr
      streetName:york
      streetNumber:100
      wallColor:_
      floorSurface:wood
   meth init skip end
end
Apt3={New YorkApt init}
Apt4={New YorkApt init}

declare
L=linux
class RedHat attr ostype:L end
class SuSE attr ostype:L end
class Debian attr ostype:L end

declare
class Inspector
   meth get(A ?X)
      X=@A
   end
   meth set(A X)
      A:=X
   end
   meth init skip end
end

declare B C
B={NewCell 0}
I={New Inspector init}
{I set(B 1)}
{I get(B C)}
{Browse C}
{Browse {I get(B $)}}

declare
fun {StrangeClass}
   class A meth foo(X) X=a end end
   class B meth foo(X) X=b end end
   class C from A B end
in C end
{Browse {StrangeClass}}
% Unresolved conflicts in class definition

% declare
% class A meth foo(?X) X=1 end end
% class B meth foo(?X) X=2 end end
% class C from A B
%    meth init skip end
% end
% C1={New C init}
% {Browse {C1 foo($)}}

declare
class Account
   attr balance:0
   meth transfer(Amt)
      balance:=@balance+Amt
   end
   meth getBal(Bal)
      Bal=@balance
   end
   meth batchTransfer(AmtList)
      for A in AmtList do {self transfer(A)} end
   end
end

% 7.3.4

declare
local
   class ForwardMixin
      attr Forward:none
      meth setForward(F) Forward:=F end
      meth otherwise(M)
         if @Forward==none then raise undefinedMethod end
         else {@Forward M} end
      end
   end
in
   fun {NewF Class Init}
      {New class $ from Class ForwardMixin end Init}
   end
end
class C1
   meth init skip end
   meth cube(A B) B=A*A*A end
end
class C2
   meth init skip end
   meth square(A B) B=A*A end
end
Obj1={NewF C1 init}
Obj2={NewF C2 init}
{Obj2 setForward(Obj1)}
{Browse {Obj2 cube(10 $)}}
% {Browse {Obj1 square(10 $)}} undefinedMethod

declare
local
   SetSelf={NewName}
   class DelegateMixin
      attr this Delegate:none
      meth !SetSelf(S) this:=S end
      meth set(A X) A:=X end
      meth get(A ?X) X=@A end
      meth setDelegate(D) Delegate:=D end
      meth Del(M S) SS in
         SS=@this this:=S
         try {self M} finally this:=SS end
      end
      meth call(M) SS in
         SS=@this this:=self
         try {self M} finally this:=SS end
      end
      meth otherwise(M)
         if @Delegate==none then
            raise undefinedMethod end
         else
            {@Delegate Del(M @this)}
         end
      end
   end
in
   fun {NewD Class Init}
      Obj={New class $ from Class DelegateMixin end Init}
   in
      {Obj SetSelf(Obj)}
      Obj
   end
end

declare
class C1NonDel
   attr i:0
   meth init skip end
   meth inc(I) i:=@i+I end
   meth browse {self inc(10)} {Browse c1#@i} end
   meth c {self browse} end
end
class C2NonDel from C1NonDel
   attr i:0
   meth init skip end
   meth browse {self inc(100)} {Browse c2#@i} end
end

C={New C2NonDel init}
{C browse}

declare
class C1
   attr i:0
   meth init skip end
   meth inc(I)
      {@this set(i {@this get(i $)}+I)}
   end
   meth browse
      {@this inc(10)}
      {Browse c1#{@this get(i $)}}
   end
   meth c {self browse} end
end
Obj1={NewD C1 init}
class C2
   attr i:0
   meth init skip end
   meth browse
      {@this inc(100)}
      {Browse c2#{@this get(i $)}}
   end
   meth c {self browse} end
end
Obj2={NewD C2 init}
{Obj2 setDelegate(Obj1)}

{Obj2 browse}
{Obj1 browse}
{Obj1 call(c)}
{Obj2 call(c)}

declare
class C2b
   attr i:0
   meth init skip end
end
ObjX={NewD C2b init}
{ObjX setDelegate(Obj2)}

{ObjX browse}
{ObjX call(c)}

{ObjX setDelegate(Obj1)}
{ObjX browse}
{ObjX call(c)}

% 7.3.5

declare
fun {TraceNew Class Init}
   Obj={New Class Init}
   proc {TracedObj M}
      {Browse entering({Label M})}
      {Obj M}
      {Browse exiting({Label M})}
   end
in TracedObj end

declare
fun {TranceNew2 Class Init}
   Obj={New Class Init}
   TInit={NewName}
   class Tracer
      meth !TInit skip end
      meth otherwise(M)
         {Browse entering({Label M})}
         {Obj M}
         {Browse exiting({Label M})}
      end
   end
in  {New Tracer TInit} end



declare
class Counter from ObjectSupport.reflect
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
C1={New Counter init(0)}
C2={New Counter init(0)}
{C1 inc(10)}
local X in {C1 toChunk(X)} {C2 fromChunk(X)} end
{C1 browse}
{C2 browse}
