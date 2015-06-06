% 1

%     状態（state）とは、必要とされる途中の計算結果を含む、値の時系列である。
%     comics 1. 見る者に情報を伝達し、かつ（または）美的な反応を喚起するために、よく考えて列にした絵画等のイメージ…。

% https://github.com/Altech/ctmcp-answers/blob/master/Section06/expr1.mkd

% 2

declare
fun {SumList Xs}
   S={NewCell 0}
   fun {Iter Xs}
      case Xs
      of nil then @S
      [] X|Xr then
         S:=@S+X
         {Iter Xr}
      end
   end
in
   {Iter Xs}         
end

{Browse {SumList [1 2 3]}}
{Browse {SumList [1 2 3 4]}}

% 3

declare
fun {MakeState Init}
   proc {Loop S V}
      case S of access(X)|S2 then
         X=V {Loop S2 V}
      [] assign(X)|S2 then
         {Loop S2 X}
      else skip end
   end
   S
in
   thread {Loop S Init} end S
end

declare S1 X Y
S={MakeState 0}
S=access(X)|assign(3)|access(Y)|S1
{Browse X}
{Browse Y}
         
declare
local
   Cs={NewCell {MakeState 0}}
in
   fun {SumList Xs}
      S={NewCell 0}
      fun {Iter Xs}
         case Xs
         of nil then
            @S
         [] X|Xr then 
            S:=@S+X
            {Iter Xr}
         end
      end
   in
      _ = {SumUp}
      {Iter Xs}
   end
   fun {SumUp} C Cr in
      @Cs = access(C)|assign(C+1)|Cr
      Cs:=Cr
      C
   end
   fun {SumCount} C Cr in
      @Cs = access(C)|assign(C)|Cr
      Cs:=Cr
      C
   end
end

{Browse {SumList [1 2 3]}}
{Browse {SumCount}}
      
   
