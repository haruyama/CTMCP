% 5.1

declare S P in
{NewPort S P}
{Browse S}
{Send P a}
{Send P b}

% 5.2

declare P in
local S in
   {NewPort S P}
   thread {ForAll S Browse} end
end
{Send P hi}
{Send P ho}

% 5.2.1

declare
fun {NewPortObject Init Fun}
   Sin Sout in
   thread {FoldL Sin Fun Init Sout} end
   {NewPort Sin}
end

declare
fun {NewPortObject2 Proc}
   Sin in
   thread for Msg in Sin do {Proc Msg} end end
   {NewPort Sin}
end

% 5.2.2

declare
fun {Player Others}
   {NewPortObject2
    proc {$ Msg}
       case Msg of ball then
          Ran={OS.rand} mod {Width Others}+1
       in
          {Delay 1000}
          {Browse Ran}
          {Send Others.Ran ball}
       end
    end}
end

declare P1 P2 P3
P1={Player others(P2 P3)}
P2={Player others(P1 P3)}
P3={Player others(P1 P2)}

{Send P1 ball}

% 5.3.1

declare
proc {ServerProc Msg}
   case Msg
   of calc(X Y) then
      Y=X*X+2.0+X+2.0
   end
end
Server={NewPortObject2 ServerProc}
proc {ClientProc Msg}
   case Msg
   of work(Y) then Y1 Y2 in
      {Send Server calc(10.0 Y1)}
      {Wait Y1}
      {Send Server calc(20.0 Y2)}
      {Wait Y2}
      Y=Y1+Y2
   end
end
Client={NewPortObject2 ClientProc}
{Browse {Send Client work($)}}

% 5.3.2
declare
proc {ClientProc Msg}
   case Msg
   of work(?Y) then Y1 Y2 in
      {Send Server calc(10.0 Y1)}
      {Send Server calc(20.0 Y2)}
      Y=Y1+Y2
   end
end
Client={NewPortObject2 ClientProc}
{Browse {Send Client work($)}}

% 5.3.3
declare
proc {ServerProc Msg}
   case Msg
   of calc(X ?Y Client) then X1 D in
      {Send Client delta(D)}
      X1=X+D
      Y=X1*X1+2.0+X1+2.0
   end
end
Server={NewPortObject2 ServerProc}
proc {ClientProc Msg}
   case Msg
   of work(?Z) then Y in
      {Send Server calc(10.0 Y Client)}
      thread Z=Y+100.0 end
   [] delta(?D) then
      D=1.0
   end
end
Client={NewPortObject2 ClientProc}
{Browse {Send Client work($)}}

% 5.3.4
declare
proc {ServerProc Msg}
   case Msg
   of calc(X Client Cont) then X1 D Y in
      {Send Client delta(D)}
      X1=X+D
      Y=X1*X1+2.0+X1+2.0
      {Send Client Cont#Y}
   end
end
Server={NewPortObject2 ServerProc}
proc {ClientProc Msg}
   case Msg
   of work(?Z) then Y in
      {Send Server calc(10.0 Client cont(Z))}
   [] cont(Z)#Y then
      Z=Y+100.0
   [] delta(?D) then
      D=1.0
   end
end
Client={NewPortObject2 ClientProc}
{Browse {Send Client work($)}}

% 5.3.5
declare
proc {ClientProc Msg}
   case Msg
   of work(?Z) then 
      C=proc {$ Y} Z=Y+100.0 end
   in
      {Send Server calc(10.0 Client cont(C))}
   [] cont(C)#Y then
      {C Y}
   [] delta(?D) then
      D=1.0
   end
end
Client={NewPortObject2 ClientProc}
{Browse {Send Client work($)}}

% 5.3.6
declare
proc {ServerProc Msg}
   case Msg
   of sqrt(X Y E) then
      try
         Y={Sqrt X}
         E=normal
      catch Exc then
         E=exception(Exc)
      end
   end
end
Server={NewPortObject2 ServerProc}
local Y E in
   {Send Server sqrt(2.0 Y E)}
   case E of exception(Exc) then raise Exc end
   else
      {Browse Y}
   end
end


local Y E in
   {Send Server sqrt(~2.0 Y E)}
   case E of exception(Exc) then raise Exc end
   else
      {Browse Y}
   end
end


% 5.3.7
declare 
proc {ServerProc Msg}
   case Msg
   of calc(X ?Y Client) then X1 D in
      {Send Client delta(D)}
      thread
         X1=X+D
         Y=X1*X1+2.0*X1+2.0
      end
   end
end
Server={NewPortObject2 ServerProc}
proc {ClientProc Msg}
   case Msg
   of work(?Y) then Y1 Y2 in
      {Send Server calc(10.0 Y1 Client)}
      {Send Server calc(20.0 Y2 Client)}
      thread Y=Y1+Y2 end
   [] delta(D) then
      D=1.0
   end
end
Client={NewPortObject2 ClientProc}
{Browse {Send Client work($)}}

% 5.3.8
declare 
proc {ServerProc Msg}
   case Msg
   of calc(X ?Y Client) then X1 D in
      {Send Client delta(D)}
      thread
         X1=X+D
         Y=X1*X1+2.0*X1+2.0
      end
   [] serverdelta(?S) then
      S=0.01
   end
end
Server={NewPortObject2 ServerProc}
proc {ClientProc Msg}
   case Msg
   of work(?Y) then Y1 Y2 in
      {Send Server calc(10.0 Y1 Client)}
      {Send Server calc(20.0 Y2 Client)}
      thread Y=Y1+Y2 end
   [] delta(?D) then S in
      {Send Server serverdelta(S)}
      thread D=1.0+S end
   end
end
Client={NewPortObject2 ClientProc}
{Browse {Send Client work($)}}

% 5.5.2

declare
fun {Timer}
   {NewPortObject2
    proc {$ Msg}
       case Msg of starttimer(T Pid) then
          thread {Delay T} {Send Pid stoptimer} end
       end
    end}
end

fun {Controller Init}
   Tid={Timer}
   Cid={NewPortObject Init
        fun {$ state(Motor F Lid) Msg}
           case Motor
           of running then
              case Msg
              of stoptimer then
                 {Send Lid 'at'(F)}
                 state(stopped F Lid)
              end
           [] stopped then
              case Msg
              of step(Dest) then
                 if F==Dest then
                    state(stopped F Lid)
                 elseif F<Dest then
                    {Send Tid starttimer(5000 Cid)}
                    state(running F+1 Lid)
                 else % F>Dest
                    {Send Tid starttimer(5000 Cid)}
                    state(running F-1 Lid)
                 end
              end
           end
        end}
in Cid
end

declare
fun {Floor Num Init Lifts}
   Tid={Timer}
   Fid={NewPortObject Init
        fun {$ state(Called) Msg}
           case Called
           of notcalled then Lran in
              case Msg
              of arrive(Ack) then
                 {Browse 'Lift at floor '#Num#': open doors'}
                 {Send Tid starttimer(5000 Fid)}
                 state(doorsopen(Ack))
              [] call then
                 {Browse 'Floor '#Num#': calls a lift!'}
                 Lran=Lifts.(1+{OS.rand} mod {Width Lifts})
                 {Send Lran call(Num)}
                 state(called)
              end
           [] called then
              case Msg
              of arrive(Ack) then
                 {Browse 'Lift at floor '#Num#': open doors'}
                 {Send Tid starttimer(5000 Fid)}
                 state(doorsopen(Ack))
              [] call then
                 state(called)
              end
           [] doorsopen(Ack) then
              case Msg
              of stoptimer then
                 {Browse 'Lift at floor '#Num#': close doors'}
                 Ack=unit
                 state(notcalled)
              [] arrive(A) then
                 A=Ack
                 state(doorsopen(Ack))
              [] call then
                 state(doorsopen(Ack))
              end
           end
        end}
in Fid end

declare
fun {ScheduleLast L N}
   if L\=nil andthen {List.last L}==N then L
   else {Append L [N]} end
end

fun {Lift Num Init Cid Floors}
   {NewPortObject Init
    fun {$ state(Pos Sched Moving) Msg}
       case Msg
       of call(N) then
          {Browse 'Lift '#Num#' needed at floor '#N}
          if N==Pos andthen {Not Moving} then
             {Wait {Send Floors.Pos arrive($)}}
             state(Pos Sched false)
          else Sched2 in
             Sched2={ScheduleLast Sched N}
             if {Not Moving} then
                {Send Cid step(N)} end
             state(Pos Sched2 true)
          end
       [] 'at'(NewPos) then
          {Browse 'Lift '#Num#' at floor '#NewPos}
          case Sched
          of S|Sched2 then
             if NewPos==S then
                {Wait {Send Floors.S arrive($)}}
                if Sched2==nil then
                   state(NewPos nil false)
                else
                   {Send Cid step(Sched2.1)}
                   state(NewPos Sched2 true)
                end
             else
                {Send Cid step(S)}
                state(NewPos Sched Moving)
             end
          end
       end
    end}
end

declare
proc {Building FN LN ?Floors ?Lifts}
   Lifts={MakeTuple lifts LN}
   for I in 1..LN do Cid in
      Cid={Controller state(stopped 1 Lifts.I)}
      Lifts.I={Lift I state(1 nil false) Cid Floors}
   end
   Floors={MakeTuple floors FN}
   for I in 1..FN do
      Floors.I={Floor I state(notcalled) Lifts}
   end
end

declare F L in
{Building 10 2 F L}
{Send F.9 call}
{Send F.10 call}
{Send L.1 call(4)}
{Send L.2 call(5)}

declare
fun {LiftShaft I state(F S M) Floors}
   Cid={Controller state(stopped F Lid)}
   Lid={Lift I state(F S M) Cid Floors}
in Lid end
proc {Building FN LN ?Floors ?Lifts}
   Lifts={MakeTuple lifts LN}
   for I in 1..LN do
      Lifts.I={LiftShaft I state(1 nil false) Floors}
   end
   Floors={MakeTuple floors FN}
   for I in 1..FN do
      Floors.I={Floor I state(notcalled) Lifts}
   end
end

declare F L in
{Building 10 2 F L}
{Send F.9 call}
{Send F.10 call}
{Send L.1 call(4)}
{Send L.2 call(5)}

% 5.6

declare
proc {NewPortObjects ?AddPortObject ?Call}
   Sin P={NewPort Sin}
   proc {MsgLoop S1 Procs}
      case S1
      of add(I Proc Sync)|S2 then Procs2 in
         Procs2={AdjoinAt Procs I Proc}
         Sync=unit
         {MsgLoop S2 Procs2}
      [] msg(I M)|S2 then
         try {Procs.I M} catch _ then skip end
         {MsgLoop S2 Procs}
      [] nil then skip end
   end
in
   thread {MsgLoop Sin procs} end
   proc {AddPortObject I Proc}
      Sync in
      {Send P add(I Proc Sync)}
      {Wait Sync}
   end
   proc {Call I M}
      {Send P msg(I M)}
   end
end

declare
[QTk]={Module.link ["x-oz://system/wp/QTk.ozf"]}

declare
fun {NewProgWindow CheckMsg}
   InfoHdl See={NewCell true}
   H D=td(title:"Progress monitor"
          label(text:nil handle:InfoHdl)
          checkbutton(
             text:CheckMsg handle:H init:true
             action:proc {$} See:={H get($)} end))
in
   {{QTk.build D} show}
   proc {$ Msg}
      if @See then {Delay 50} {InfoHdl set(text:Msg)} end
   end
end


declare AddPortObject Call
{NewPortObjects AddPortObject Call}

InfoMsg={NewProgWindow "See ping-pong"}

fun {PingPongProc Other}
   proc {$ Msg}
      case Msg
      of ping(N) then
         {InfoMsg "ping("#N#")"}
         {Call Other pong(N+1)}
      [] pong(N) then
         {InfoMsg "pong("#N#")"}
         {Call Other ping(N+1)}
      end
   end
end

{AddPortObject pingobj {PingPongProc pongobj}}
{AddPortObject pongobj {PingPongProc pingobj}}
{Call pingobj ping(0)}

% 5.6.2

% 動かない版
declare
fun {NewQueue}
   Given GivePort={NewPort Given}
   Taken TakePort={NewPort Taken}
in
   Given=Taken
   queue(put:proc {$ X} {Send GivePort X} end
         get:proc {$ X} {Send TakePort X} end)
end

declare Q in
thread Q={NewQueue} end
{Q.put 1}
{Browse {Q.get $}}
{Browse {Q.get $}}
{Browse {Q.get $}}
{Q.put 2}
{Q.put 3}

declare
fun {NewQueue}
   Given GivePort={NewPort Given}
   Taken TakePort={NewPort Taken}
   proc {Match Xs Ys}
      case Xs # Ys
      of (X|Xr) # (Y|Yr) then
         X=Y {Match Xr Yr}
      [] nil # nil then skip
      end
   end
   
in
   thread {Match Given Taken} end
   queue(put:proc {$ X} {Send GivePort X} end
         get:proc {$ X} {Send TakePort X} end)
end

declare Q in
thread Q={NewQueue} end
{Q.put 1}
{Browse {Q.get $}}
{Browse {Q.get $}}
{Browse {Q.get $}}
{Q.put 2}
{Q.put 3}

declare
fun {NewQueue}
   Given GivePort={NewPort Given}
   Taken TakePort={NewPort Taken}
in
   thread Given=Taken end
   queue(put:proc {$ X} {Send GivePort X} end
         get:proc {$ X} {Send TakePort X} end)
end

declare Q in
thread Q={NewQueue} end
{Q.put 1}
{Browse {Q.get $}}
{Browse {Q.get $}}
{Browse {Q.get $}}
{Q.put 2}
{Q.put 3}

% 5.6.3
declare
local
   proc {ZeroExit N Is}
      case Is of I|Ir then
         if N+I\=0 then {ZeroExit N+I Ir} end
      end
   end
in
   proc {NewThread P ?SubThread}
      Is Pt={NewPort Is}
   in
      proc {SubThread P}
         {Send Pt 1}
         thread
            {P} {Send Pt ~1}
         end
      end
      {SubThread P}
      {ZeroExit 0 Is}
   end
end

declare
proc {NewSPort ?S ?SSend}
   S1 P={NewPort S1} in
   proc {SSend M} X in {Send P M#X} {Wait X} end
   thread S={Map S1 fun {$ M#X} X=unit M end} end
end

%5.6.4
declare
proc {Barrier Ps}
   fun {BarrierLoop Ps L}
      case Ps of P|Pr then M in
         thread {P} M=L end
         {BarrierLoop Pr M}
      [] nil then L
      end
   end
   S={BarrierLoop Ps unit}
in
   {Wait S}
end

declare
proc {ConcFilter L F ?L2}
   Send Close
in
   {NewPortClose L2 Send Close}
   {Barrier
    {Map L
     fun {$ X}
        proc {$}
           if {F X} then {Send X} end
        end
     end}}
   {Close}
end

declare L
{ConcFilter [1 2 3] Int.isOdd L}
{Browse L}

% 5.8.1

declare
fun {StreamManager OutS1 OutS2}
   case OutS1#OutS2
   of (M|NewS1)#OutS2 then
      M|{StreamManager NewS1 OutS2}
   [] OutS1#(M|NewS2) then
      M|{StreamManager OutS1 NewS2}
   [] nil#OutS2 then
      OutS2
   [] OutS1#nil then
      OutS1
   end
end

declare
fun {StreamManager OutS1 OutS2}
   F={WaitTwo OutS1 OutS2}
in
   case F#OutS1#OutS2
   of 1#(M|NewS1)#OutS2 then
      M|{StreamManager OutS2 NewS1}
   [] 2#OutS1#(M|NewS2) then
      M|{StreamManager NewS2 OutS1}
   [] 1#nil#OutS2 then
      OutS2
   [] 2#OutS1#nil then
      OutS1
   end
end
