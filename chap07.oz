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

declare
fun {StrangeClass}
   class A meth foo(X) X=a end end
   class B meth foo(X) X=b end end
   class C from A B
      meth foo(X)
         A,foo(X)
      end
   end
in C end
{Browse {StrangeClass}}

% declare
% class A meth foo(?X) X=1 end end
% class B meth foo(?X) X=2 end end
% class C from A B
%    meth init skip end
% end
% C1={New C init}
% {Browse {C1 foo($)}}

% 7.3.2

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

declare
class AccountLog
   meth init skip end
   meth addentry(Msg)
      {Browse Msg}
   end
end
LogObj = {New AccountLog init}

declare
class LoggedAccount from Account
   meth transfer(Amt)
      {LogObj addentry(transfer(Amt))}
      Account,transfer(Amt)
   end
end

declare
LogAct={New LoggedAccount transfer(100)}
{LogAct batchTransfer([10 200 3000])}

% 7.3.3



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

{Browse {Obj2 square(10 $)}}
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
Acc = {TraceNew Account transfer(100)}
{Acc transfer(200)}
{Browse {Acc getBal($)}}
{Acc batchTransfer([10 200 3000])}

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

% 7.4

declare
class Account
   attr balance:0
   meth init skip end
   meth transfer(Amt)
      balance:=@balance+Amt
   end
   meth getBalance(Bal)
      Bal=@balance
   end
   meth batchTransfer(AmtList)
      for A in AmtList do {self transfer(A)} end
   end
end

class VerboseAccount from Account
   meth verboseTransfer(Amt)
      {self transfer(Amt)}
      {Browse 'Balance:'#@balance}
   end
end

class AccountWithFee from VerboseAccount
   attr fee:5
   meth transfer(Amt)
      VerboseAccount,transfer(Amt-@fee)
   end
end

declare B B2
A={New AccountWithFee init}
%A={New VerboseAccount init}
{A getBalance(B)}
{Browse B}
{A transfer(10)}
{A getBalance(B2)}
{Browse B2}

% 7.4.2

declare
class ListClass
   meth isNil(_) raise undefinedMethod end end
   meth append(_ _) raise undefinedMethod end end
   meth display raise undefinedMethod end end
end

class NilClass from ListClass
   meth init skip end
   meth isNil(B) B=true end
   meth append(T U) U=T end
   meth display {Browse nil} end
end

class ConsClass from ListClass
   attr head tail
   meth init(H T) head:=H tail:=T end
   meth isNil(B) B=false end
   meth append(T U)
      U2={@tail append(T $)}
   in
      U={New ConsClass init(@head U2)}
   end
   meth display {Browse @head} {@tail display} end
end

declare
L1={New ConsClass
    init(1 {New ConsClass
            init(2 {New NilClass init})})}
L2={New ConsClass init(3 {New NilClass init})}
L3={L1 append(L2 $)}
{L3 display}

% 7.4.3

declare
class GenericSort
   meth init skip end
   meth qsort(Xs Ys)
      case Xs
      of nil then Ys=nil
      [] P|Xr then S L in
         {self partition(Xr P S L)}
         {Append {self qsort(S $)}
          P|{self qsort(L $)} Ys }
      end
   end
   meth partition(Xs P Ss Ls)
      case Xs
      of nil then Ss=nil Ls=nil
      [] X|Xr then Sr Lr in
         if {self less(X P $)} then
            Ss=X|Sr Ls=Lr
         else
            Ss=Sr Ls=X|Lr
         end
         {self partition(Xr P Sr Lr)}
      end
   end
end

declare
class IntegerSort from GenericSort
   meth less(X Y B)
      B=(X<Y)
   end
end

class RationalSort from GenericSort
   meth less(X Y B)
      '/'(P Q)=X
      '/'(R S)=Y
   in B=(P*S<Q*R) end
end

declare
ISort={New IntegerSort init}
RSort={New RationalSort init}
{Browse {ISort qsort([1 2 5 3 4] $)}}
{Browse {RSort qsort(['/'(23 3) '/'(34 11) '/'(47 17)] $)}}

declare
fun {MakeSort Less}
   class $
      meth init skip end
      meth qsort(Xs Ys)
         case Xs
         of nil then Ys=nil
         [] P|Xr then S L in
            {self partition(Xr P S L)}
            {Append {self qsort(S $)}
             P|{self qsort(L $)} Ys }
         end
      end
      meth partition(Xs P Ss Ls)
         case Xs
         of nil then Ss=nil Ls=nil
         [] X|Xr then Sr Lr in
            if {Less X P} then   %...
               Ss=X|Sr Ls=Lr
            else
               Ss=Sr Ls=X|Lr
            end
            {self partition(Xr P Sr Lr)}
         end
      end
   end
end

declare
IntegerSort={MakeSort fun {$ X Y} X<Y end}
RationalSort={MakeSort fun {$ X Y}
                          '/'(P Q) = X
                          '/'(R S) = Y
                          in P*S<Q*R end}

declare
ISort={New IntegerSort init}
RSort={New RationalSort init}
{Browse {ISort qsort([1 2 5 3 4] $)}}
{Browse {RSort qsort(['/'(23 3) '/'(34 11) '/'(47 17)] $)}}

% 7.4.4

declare
class Figure
   meth otherwise(M)
      raise undefinedMethod end
   end
end

declare
class Line from Figure
   attr canvas x1 y1 x2 y2
   meth init(Can X1 Y1 X2 Y2)
      canvas:=Can
      x1:=X1 y1:=Y1
      x2:=X2 y2:=Y2
   end
   meth move(X Y)
      x1:=@x1+X y1:=@y1+Y
      x2:=@x2+X y2:=@y2+Y
   end
   meth display
      {@canvas create(line @x1 @y1 @x2 @y2)}
   end
end

declare
class Circle from Figure
   attr canvas x y r
   meth init(Can X Y R)
      canvas:=Can
      x:=X y:=Y r:=R
   end
   meth move(X Y)
      x:=@x+X y:=@y+Y
   end
   meth display
      {@canvas create(oval @x-@r @y-@r @x+@r @y+@r)}
   end
end

declare
class LinkedList
   attr elem next
   meth init(elem:E<=null next:N<=null)
      elem:=E next:=N
   end
   meth add(E)
      next:={New LinkedList init(elem:E next:@next)}
   end
   meth forall(M)
      if @elem\=null then {@elem M} end
      if @next\=null then {@next forall(M)} end
   end
end

declare
class CompositeFigure from Figure LinkedList
   meth init
      LinkedList,init
   end
   meth move(X Y)
      {self forall(move(X Y))}
   end
   meth display
      {self forall(display)}
   end
end

declare [QTk]={Module.link ['x-oz://system/wp/QTk.ozf']}
W=250 H=150 Can
Wind={QTk.build td(title:"Simple graphics package"
                   canvas(width:W height:H bg:white
                          handle:Can))}
{Wind show}

declare
F1={New CompositeFigure init}
{F1 add({New Line init(Can 50 50 150 50)})}
{F1 add({New Line init(Can 150 50 100 125)})}
{F1 add({New Line init(Can 100 125 50 50)})}
{F1 add({New Circle init(Can 100 75 20)})}
{F1 display}

for I in 1..10 do {F1 move(3 ~2)} {F1 display} end


declare
class CompositeFigure from Figure
   attr figlist
   meth init
      figlist:={New LinkedList init}
   end
   meth add(F)
      {@figlist add(F)}
   end
   meth move(X Y)
      {@figlist forall(move(X Y))}
   end
   meth display
      {@figlist forall(display)}
   end
end

declare [QTk]={Module.link ['x-oz://system/wp/QTk.ozf']}
W=250 H=150 Can
Wind={QTk.build td(title:"Simple graphics package"
                   canvas(width:W height:H bg:white
                          handle:Can))}
{Wind show}

declare
F1={New CompositeFigure init}
{F1 add({New Line init(Can 50 50 150 50)})}
{F1 add({New Line init(Can 150 50 100 125)})}
{F1 add({New Line init(Can 100 125 50 50)})}
{F1 add({New Circle init(Can 100 75 20)})}
{F1 display}

for I in 1..10 do {F1 move(3 ~2)} {F1 display} end

% 7.4.7
declare
class Leaf
   meth init skip end
end

declare
class Composite
   attr children
   meth init
      children:=nil
   end
   meth add(E)
      children:=E|@children
   end
   meth otherwise(M)
      for N in @children do {N M} end
   end
end

declare
N0={New Composite init}
L1={New Leaf init} {N0 add(L1)}
L2={New Leaf init} {N0 add(L2)}
N3={New Composite init} {N0 add(N3)}
L4={New Leaf init} {N0 add(L4)}
L5={New Leaf init} {N3 add(L5)}
L6={New Leaf init} {N3 add(L6)}
L7={New Leaf init} {N3 add(L7)}

declare
class Composite
   attr children valid
   meth init(Valid)
      children:=nil
      @valid=Valid
   end
   meth add(E)
      if {Not {@valid E}} then raise invalidNode end end
      children:=E|@children
   end
   meth otherwise(M)
      for N in @children do {N M} end
   end
end

% 7.5

% 7.5.2

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
class Batcher
   meth nil skip end
   meth '|'(M Ms) {self M} {self Ms} end
end

declare
C={New class $ from Counter Batcher end init(0)}
{C [inc(2) browse inc(3) inc(4)]}
{C browse}

% 7.6

% 7.6.2
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

% 7.6.3

declare Wrap UnWrap
proc {NewWrapper ?Wrap ?UnWrap}
   Key={NewName} in
   fun {Wrap X}
      {Chunk.new w(Key:X)}
   end
   fun {UnWrap W}
      try W.Key catch _ then raise error(unwrap(W)) end end
   end
end
{NewWrapper Wrap UnWrap}

declare Counter
local
   Attrs = [val]
   MethodTable=m(browse:MyBrowse init:Init inc:Inc)
   proc {Init M S Self}
      init(Value)=M
   in
      (S.val):=Value
   end
   proc {Inc M S Self}
      X
      inc(Value)=M
   in
      X=@(S.val) (S.val) := X+Value
   end
   proc {MyBrowse M S Self}
      browse=M
      {Browse @(S.val)}
   end
in
   Counter = {Wrap c(methods:MethodTable attrs:Attrs)}
end

declare
fun {MyNew WClass InitialMethod}
   State Obj Class={UnWrap WClass}
in
   State={MakeRecord s Class.attrs}
   {Record.forAll State proc {$ A} {NewCell _ A} end}
   proc {Obj M}
      {Class.methods.{Label M} M State Obj}
   end
   {Obj InitialMethod}
   Obj
end

declare
C={MyNew Counter init(0)}
{C inc(6)} {C inc(6)}
{C browse}

% 7.6.4

% declare
% fun {From C1 C2 C3}
%    c(methods:M1 attrs:A1)={UnWrap C1}
%    c(methods:M2 attrs:A2)={UnWrap C2}
%    c(methods:M3 attrs:A3)={UnWrap C3}
%    MA1={Arity M1}
%    MA2={Arity M2}
%    MA3={Arity M3}
%    ConfMeth={Minus {Inter MA2 MA3} MA1}
%    ConfAttr={Minus {Inter A2 A3} A1}
% in
%    if ConfMeth\=nil then
%       raise illegalInheritance(methConf:ConfMeth) end
%    end
%    if ConfAttr\=nil then
%       raise illegalInheritance(attrConf:ConfAttr) end
%    end
%    {Wrap c(methods:{Adjoin {Adjoin M2 M3} M1}
%     attrs:{Union {Union A2 A3} A1})}
% end

% 7.8

% 7.8.1

declare
class BallGame
   attr other count:0
   meth init(Other)
      other:=Other
   end
   meth ball
      count:=@count+1
      {@other ball}
   end
   meth get(X)
      X=@count
   end
end
B1={NewActive BallGame init(B2)}
B2={NewActive BallGame init(B1)}
{B1 ball}

declare X in
{B1 get(X)}
{Browse X}

% 7.8.2

declare
fun {MyNewActive Class Init}
   Obj={New Class Init}
   P
in
   thread S in
      {NewPort S P}
      for M in S do {Obj M} end
   end
   proc {$ M} {Send P M} end
end

