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
   

% 8.4

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
      % L.get した状態かチェック
      % L.get と L.release を wrap して そのスレッドで
      % get したかをを管理するのがよさそう
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
                       @buf.@last:=X
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
                       X=@buf.@first
                       first:=(@first+1) mod @n
                       i:=@i-1
                       {@m.notifyAll}
                    end
                 end}
   end
end

declare
B={New Buffer init(2)}
{B put(1)}
{B put(2)}
thread {B put(3)} {Browse 'hoge'} end
{Browse {B get($)}}

% 8.5

% 2相ロック
% http://metabolomics.jp/wiki/Aritalab:Lecture/Database/Transaction
% 『一般に２相ロックという場合、「全要求を一度に許可」するプロトコルではなく、全てのロック要求を、ロック解除より前におこなうプロトコルを指します。この場合、２相ロックでデッドロックを回避できません。』

declare
class TMClass
   attr timestamp tm
   meth init(TM) timestamp:=0 tm:=TM end
   meth Unlockall(T RestoreFlag)
      for save(cell:C state:S) in {Dictionary.items T.save} do
         (C.owner):=unit
         % 必要なら元に戻す
         if RestoreFlag then (C.state):=S end
         % セルのキューが空でないなら最初のトランザクションを
         % 実行状態に
         if {Not {C.queue.isEmpty}} then
            Sync2#T2={C.queue.dequeue} in
            (T2.state):=running
            (C.owner):=T2 Sync2=ok
         end
      end
   end
   meth Trans(P ?R TS)
      Halt={NewName}
      T=trans(stamp:TS save:{NewDictionary} body:P
              state:{NewCell running} result:R)
      proc {ExcT C X Y} S1 S2 in
         {@tm getlock(T C S1)}
         if S1==halt then raise Halt end end
         {@tm savestate(T C S2)} {Wait S2}
         {Exchange C.state X Y}
      end
      proc {AccT C ?X} {ExcT C X X} end
      proc {AssT C X} {ExcT C _ X} end
      proc {AboT} {@tm abort(T)} R=abort raise Halt end end
   in
      % トランザクション実行
      thread try Res={T.body t(access:AccT assign:AssT
                               exchange:ExcT abort:AboT)}
             in {@tm commit(T)} R=commit(Res)
             catch E then
                % Halt でなければ  abort
                if E\=Halt then {@tm abort(T)} R=abort(E) end
             end end
   end
   meth getlock(T C ?Sync)
      if @(T.state)==probation then
         % リスタート
         {self Unlockall(T true)}
         {self Trans(T.body T.result T.stamp)} Sync=halt
      elseif @(C.owner)==unit then
         (C.owner):=T Sync=ok
      elseif T.stamp==@(C.owner).stamp then
         Sync=ok
      else /* T.stamp\=@(C.owner).stamp */ T2=@(C.owner) in
         {C.queue.enqueue Sync#T T.stamp}
         (T.state):=waiting_on(C)
         if T.stamp<T2.stamp then
            % T のほうが優先の場合
            case @(T2.state) of waiting_on(C2) then
               % リスタート
               Sync2#_={C2.queue.delete T2.stamp} in
               {self Unlockall(T2 true)}
               {self Trans(T2.body T2.result T2.stamp)}
               Sync2=halt
            [] running then
               (T2.state):=probation
            [] probation then skip end
         end
      end
   end
   meth newtrans(P ?R)
      timestamp:=@timestamp+1 {self Trans(P R @timestamp)}
   end
   meth savestate(T C ?Sync)
      if {Not {Dictionary.member T.save C.name}} then
         (T.save).(C.name):=save(cell:C state:@(C.state))
      end Sync=ok
   end
   meth commit(T) {self Unlockall(T false)} end
   meth abort(T) {self Unlockall(T true)} end
end

declare
fun {NewPrioQueue}
   Q={NewCell nil}
   proc {Enqueue X Prio}
      fun {InsertLoop L}
         case L of pair(Y P)|L2 then
            if Prio<P then pair(X Prio)|L
            else pair(Y P)|{InsertLoop L2} end
         [] nil then [pair(X Prio)] end
      end
   in Q:={InsertLoop @Q} end
   fun {Dequeue}
      pair(Y _)|L2=@Q
   in
      Q:=L2 Y
   end
   fun {Delete Prio}
      fun {DeleteLoop L}
         case L of pair(Y P)|L2 then
            if P==Prio then X=Y L2
            else pair(Y P)|{DeleteLoop L2} end
         [] nil then nil end
      end X
   in Q:={DeleteLoop @Q} X end
   fun {IsEmpty} @Q==nil end
in
   queue(enqueue:Enqueue dequeue:Dequeue
         delete:Delete isEmpty:IsEmpty)
end

declare
proc {NewTrans ?Trans ?NewCellT}
   TM={NewActive TMClass init(TM)} in
   fun {Trans P ?B} R in
      {TM newtrans(P R)}
      case R of abort then B=abort unit
      [] abort(Exc) then B=abort raise Exc end
      [] commit(Res) then B=commit Res end
   end
   fun {NewCellT X}
      cell(name:{NewName} owner:{NewCell unit}
           queue:{NewPrioQueue} state:{NewCell X})
   end
end

    
declare Trans NewCellT C1 C2 in
{NewTrans Trans NewCellT}
C1={NewCellT 0}
C2={NewCellT 0}
{Trans proc {$ T _}
          {T.assign C1 {T.access C1}+1}
          {T.assign C2 {T.access C2}-1}
       end _ _}
{Browse {Trans fun {$ T} {T.access C1}#{T.access C2} end _}}

declare
D={MakeTuple db 100}
for I in 1..100 do D.I={NewCellT I} end
fun {Rand} {OS.rand} mod 100 + 1 end
proc {Mix} {Trans
            proc {$ T _}
               I={Rand} J={Rand} K={Rand}
               A={T.access D.I} B={T.access D.J} C={T.access D.K}
            in
               {T.assign D.I A+B-C}
               {T.assign D.J A-B+C}
               if I==J orelse I==K orelse J==K then {T.abort} end
               {T.assign D.K ~A+B+C}
            end _  _}
end
S={NewCellT 0}
fun {Sum}
   {Trans
    fun {$ T} {T.assign S 0}
       for I in 1..100 do
          {T.assign S {T.access S}+{T.access D.I}} end
       {T.access S}
       end _}
end
{Browse {Sum}}
for I in 1..1000 do thread {Mix} end end
{Browse {Sum}}
{Browse {Trans fun {$ T} {T.access D.1}#{T.access D.2} end _}}
