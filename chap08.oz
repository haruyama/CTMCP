declare
fun {NewStack}
   Stack={NewCell nil}
   proc {Push X}
      S in
      {Exchange Stack S X|S}
   end
   fun {Pop}
      X S in
      {Exchange Stack X|S S}
      X
   end
in
   stack(push:Push pop:Pop)
end

declare
S={NewStack}
{S.push 1}
{S.push 2}
{Browse {S.pop}}
{Browse {S.pop}}

declare
fun {NewStack}
   Stack={NewCell nil}
   proc {Push X}
      S in
      {Exchange Stack S X|S}
   end
   fun {Pop}
      X S in
      try {Exchange Stack X|S S}
      catch failure(...) then raise stackEmpty end end
      X
   end
in
   stack(push:Push pop:Pop)
end

declare
S={NewStack}
{S.push 1}
{S.push 2}
{Browse {S.pop}}
{Browse {S.pop}}
try
   {Browse {S.pop}}
catch stackEmpty then {Browse stackEmpty} end

declare
fun {SlowNet1 Obj D}
   proc {$ M}
      thread
         {Delay D} {Obj M}
      end
   end
end

declare
fun {SlowNet2 Obj D}
   C={NewCell unit} in
   proc {$ M}
      Old New in
      {Exchange C Old New}
      thread
         {Delay D} {Wait Old} {Obj M} New=unit
      end
   end
end

% 8.3.1

declare
fun {NewQueue}
   X in
   q(0 X X)
end
fun {Insert q(N S E) X}
   E1 in
   E=X|E1 q(N+1 S E1)
end
fun {Delete q(N S E) X}
   S1 in
   S=X|S1 q(N-1 S1 E)
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
fun {NewQueue}
   X C={NewCell q(0 X X)}
   proc {Insert X}
      N S E1 in
      q(N S X|E1)=@C
      C:=q(N+1 S E1)
   end
   fun {Delete}
      N S1 E X in
      q(N X|S1 E)=@C
      C:=q(N-1 S1 E)
      X
   end
in
   queue(insert:Insert delete:Delete)
end

declare
Q={NewQueue}
{Q.insert 1}
{Q.insert 2}
{Browse {Q.delete}}
{Browse {Q.delete}}

declare
fun {NewQueue}
   X C={NewCell q(0 X X)}
   L={NewLock}
   proc {Insert X}
      N S E1 in
      lock L then
         q(N S X|E1)=@C
         C:=q(N+1 S E1)
      end
   end
   fun {Delete}
      N S1 E X in
      lock L then
         q(N X|S1 E)=@C
         C:=q(N-1 S1 E)
      end
      X
   end
in
   queue(insert:Insert delete:Delete)
end

declare
Q={NewQueue}
{Q.insert 1}
{Q.insert 2}
{Browse {Q.delete}}
{Browse {Q.delete}}

declare
class Queue
   attr queue
   prop locking
   meth init
      X in
      queue:=q(0 X X)
   end
   meth insert(X)
      lock N S E1 in
         q(N S X|E1)=@queue
         queue:=q(N+1 S E1)
      end
   end
   meth delete(X)
      lock N S1 E in
         q(N X|S1 E)=@queue
         queue:=q(N-1 S1 E)
      end
   end
end

declare
Q={New Queue init}
{Q insert(1)}
{Q insert(2)}
{Browse {Q delete($)}}
{Browse {Q delete($)}}

declare
fun {NewQueue}
   X C={NewCell q(0 X X)}
   proc {Insert X}
      N S E1 N1 in
      {Exchange C q(N S X|E1) q(N1 S E1)}
      N1=N+1
   end
   fun {Delete}
      N S1 E N1 X in
      {Exchange C q(N X|S1 E) q(N1 S1 E)}
      N1=N-1
      X
   end
in
   queue(insert:Insert delete:Delete)
end

declare
Q={NewQueue}
{Q.insert 1}
{Q.insert 2}
{Browse {Q.delete}}
{Browse {Q.delete}}

% 8.3.2

declare
fun {NewQueue}
   X C={NewCell q(0 X X)}
   L={NewLock}
   proc {Insert X}
      N S E1 in
      lock L then
         q(N S X|E1)=@C
         C:=q(N+1 S E1)
      end
   end
   fun {Delete}
      N S1 E X in
      lock L then
         q(N X|S1 E)=@C
         C:=q(N-1 S1 E)
      end
      X
   end
   fun {Size}
      lock L then @C.1 end
   end
in
   queue(insert:Insert delete:Delete size:Size)
end
class TupleSpace
   prop locking
   attr tupledict
   meth init tupledict:={NewDictionary} end
   meth EnsurePresent(L)
      if {Not {Dictionary.member @tupledict L}}
      then @tupledict.L:={NewQueue} end
   end
   meth Cleanup(L)
      if {@tupledict.L.size}==0
      then {Dictionary.remove @tupledict L} end
   end
   meth write(Tuple)
      lock L={Label Tuple} in
         {self EnsurePresent(L)}
         {@tupledict.L.insert Tuple}
      end
   end
   meth read(L ?Tuple)
      lock
         {self EnsurePresent(L)}
         {@tupledict.L.delete Tuple}
         {self Cleanup(L)}
      end
      {Wait Tuple}
   end
   meth readnonblock(L ?Tuple B)
      lock
         {self EnsurePresent(L)}
         if {@tupledict.L.size} > 0 then
            {@tupledict.L.delete Tuple} B=true
         else B=false end
         {self Cleanup(L)}
      end
   end
end

declare
TS={New TupleSpace init}
{TS write(foo(1 2 3))}
thread {Browse {TS read(foo $)}} end
local T B in {TS readnonblock(foo T B)} {Browse T#B} end

declare
fun {NewQueue2}
   X TS={New TupleSpace init}
   proc {Insert X}
      N S E1 in
      {TS read(q q(N S X|E1))}
      {TS write(q(N+1 S E1))}
   end
   fun {Delete}
      N S1 E X in
      {TS read(q q(N X|S1 E))}
      {TS write(q(N-1 S1 E))}
      X
   end
in
   {TS write(q(0 X X))}
   queue(insert:Insert delete:Delete)
end

declare
Q={NewQueue2}
{Q.insert 1}
{Q.insert 2}
{Browse {Q.delete}}
{Browse {Q.delete}}

% 8.3.3

declare
fun {SimpleLock}
   Token={NewCell unit}
   proc {Lock P}
      Old New in
      {Exchange Token Old New}
      {Wait Old}
      {P}
      New=unit
   end
in
   'lock'('lock':Lock)
end

declare
fun {CorrectSimpleLock}
   Token={NewCell unit}
   proc {Lock P}
      Old New in
      {Exchange Token Old New}
      {Wait Old}
      try {P} finally  New=unit end
   end
in
   'lock'('lock':Lock)
end

declare
fun {NewLock2}
   Token={NewCell unit}
   CurThr={NewCell unit}
   proc {Lock P}
      if {Thread.this}==@CurThr then
         {P}
      else Old New in
         {Exchange Token Old New}
         {Wait Old}
         CurThr:={Thread.this}
         try {P} finally
            CurThr:=unit
            New=unit
         end
      end
   end
in
   'lock'('lock':Lock)
end
   

% 8.4.2

declare
fun {NewQueue}
   X C={NewCell q(0 X X)}
   L={NewLock}
   proc {Insert X}
      N S E1 in
      lock L then
         q(N S X|E1)=@C
         C:=q(N+1 S E1)
      end
   end
   fun {Delete}
      N S1 E X in
      lock L then
         q(N X|S1 E)=@C
         C:=q(N-1 S1 E)
      end
      X
   end
   fun {Size}
      lock L then @C.1 end
   end
   fun {DeleteAll}
      lock L then
         X q(_ S E)=@C in
         C:=q(0 X X)
         E=nil S
      end
   end
   fun {DeleteNonBlock}
      lock L then
         if {Size}>0 then [{Delete}] else nil end
      end
   end
in
   queue(insert:Insert delete:Delete size:Size
         deleteAll:DeleteAll deleteNonBlock:DeleteNonBlock)
end

declare
fun {NewGRLock}
   Token1={NewCell unit}
   Token2={NewCell unit}
   CurThr={NewCell unit}
   proc {GetLock}
      if {Thread.this}\=@CurThr then Old New in
         {Exchange Token1 Old New}
         {Wait Old}
         Token2:=New
         CurThr:={Thread.this}
      end
   end
   proc {ReleaseLock}
      CurThr:=unit
      unit=@Token2
   end
in
   'lock'(get:GetLock release:ReleaseLock)
end

declare
fun {NewMonitor}
   Q={NewQueue}
   L={NewGRLock}
   proc {LockM P}
      {L.get} try {P} finally {L.release} end
   end
   proc {WaitM}
      X in
      {Q.insert X} {L.release} {Wait X} {L.get}
   end
   proc {NotifyM}
      U={Q.deleteNonBlock} in
      case U of [X] then X=unit else skip end
   end
   proc {NotifyAllM}
      L={Q.deleteAll} in
      for X in L do X=unit end
   end
in
   monitor('lock':LockM wait:WaitM notify:NotifyM
           notifyAll:NotifyAllM)
end

declare
class Buffer
   attr m buf first last n i
   meth init(N)
      m:={NewMonitor}
      buf:={NewArray 0 N-1 null}
      first:=0 last:=0 n:=N i:=0
   end
   meth put(X)
      {@m.'lock' proc {$}
                    if @i>=@n then {@m.wait} {self put(X)}
                    else
                       @buf.last:=X
                       last:=(@last+1) mod @n
                       i:=@i+1
                       {@m.notifyAll}
                    end
                 end}
   end
   meth get(X)
      {@m.'lock' proc {$}
                    if @i==0 then {@m.wait} {self get(X)}
                    else
                       X=@buf.first
                       first:=(@first+1) mod @n
                       i:=@i-1
                       {@m.notifyAll}
                    end
                 end}
   end
end

      
