% 6.1

%     状態（state）とは、必要とされる途中の計算結果を含む、値の時系列である。
%     comics 1. 見る者に情報を伝達し、かつ（または）美的な反応を喚起するために、よく考えて列にした絵画等のイメージ…。

% https://github.com/Altech/ctmcp-answers/blob/master/Section06/expr1.mkd

% 6.2

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

% 6.3

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

% 6.4

% https://github.com/Altech/ctmcp-answers/blob/master/Section06/expr4.oz

% 6.5

% https://github.com/Altech/ctmcp-answers/blob/master/Section06/expr5.mkd

% 6.6

% https://github.com/Altech/ctmcp-answers/blob/master/Section06/expr6.mkd

% 6.7

declare
fun {Revocable Obj}
   C={NewCell Obj}
   proc {Revoke}
      C:=proc {$ M} raise revokedError end end
   end
   proc {Call M}
      {@C M}
   end
in
   revocable(revoke:Revoke call:Call)
end

% 6.8

リストを再生成しないので後者のほうが良い

% 6.9

declare
proc {Sqr A}
   {A}:=@{A}*@{A}
end
local C={NewCell 0} in
   C:=25
   {Sqr fun {$} C end}
   {Browse @C}
end

declare
A={MakeTuple array 10}
for J in 1..10 do A.J={NewCell 0} end
proc {Swap X Y} T in
   T=@{X}
   {X}:=@{Y}
   {Y}:=T
end
I={NewCell 0}
I:=1
(A.1):=2
(A.2):=3
{Swap fun {$} I end fun {$} A.@I end}
{Browse @I}
{Browse @(A.1)}
{Browse @(A.2)}

% 6.10

declare
A={MakeTuple array 10}
for J in 1..10 do A.J={NewCell 0} end
proc {Swap X Y}
   XX = {X}
   YY = {Y}
   T
in
   T=@XX
   XX:=@YY
   YY:=T
end
I={NewCell 0}
I:=1
(A.1):=2
(A.2):=3
{Swap fun {$} I end fun {$} A.@I end}
{Browse @I}
{Browse @(A.1)}
{Browse @(A.2)}


declare
proc {Sqr A}
   B = {fun lazy {$} {A} end}
in
   B:=@B*@B
end
local C={NewCell 0} in
   C:=25
   {Sqr fun {$} C end}
   {Browse @C}
end

% 6.12

declare
fun {NewExtensibleArray L H Init}
   A={NewCell {NewArray L H Init}}#Init
   proc {CheckOverflow I}
      Arr=@(A.1)
      Low={Array.low Arr}
      High={Array.high Arr}
   in
      if I>High then
         High2=Low+{Max I 2*(High-Low)}
         Arr2={NewArray Low High2 A.2}
      in
         for K in Low..High do Arr2.K:=Arr.K end
         (A.1):=Arr2
      elseif I < Low then
         Low2=Low-{Max I 2*(High-Low)}
         Arr2={NewArray Low2 High A.2}
      in
         for K in Low..High do Arr2.K:=Arr.K end
         (A.1):=Arr2
      end
   end
   proc {Put I X}
      {CheckOverflow I}
      @(A.1).I:=X
   end
   fun {Get I}
      {CheckOverflow I}
      @(A.1).I
   end
in extArray(get:Get put:Put)
end

declare
A={NewExtensibleArray 10 50 3}
{Browse {A.get 50}}
{A.put 100 1}
{Browse {A.get 100}}
{Browse {A.get 5}}
{A.put 5 1}
{Browse {A.get 5}}

% 6.13

declare
fun {NewGeneralDictionay Init}
   D={NewCell nil}
   proc {Add Key Value}
      D:=Key#Value|@D
   end
   fun {Get Key}
      fun {Iter Xs}
         case Xs
         of K#V|Xr then
            if K==Key then
               V
            else
               {Iter Xr}
            end
         else
            Init
         end
      end
   in
      {Iter @D}
   end
in
   dict(add:Add get:Get)
end
   
               
declare
D={NewGeneralDictionay 0}
{D.add "hoge" 1}
{Browse {D.get "hoge"}}
{Browse {D.get "aaa"}}
