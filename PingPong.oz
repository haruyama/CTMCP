functor
import
   Browser(browse:Browse)
   Application
define
   proc {Ping N}
      if N==0 then {Browse 'ping terminated'}
      else {Delay 500} {Browse ping} {Ping N-1} end
   end
   proc {Pong N}
      {For 1 N 1
       proc {$ I} {Delay 600} {Browse pong} end}
      {Browse 'pong terminated'}
   end
   X1 X2
in
   {Browse 'game started'}
   thread {Ping 50} X1=unit end
   thread {Pong 50} X2=unit end
   {Wait X1} {Wait X2}
   {Application.exit 0}
end
