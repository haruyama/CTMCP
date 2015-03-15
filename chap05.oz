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
          % {Browse a}
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
