declare X
local
   C={NewCell 0}
in
   fun {SumList Xs S}
      C:=@C+1
      case Xs
      of nil then S
      [] X|Xr then {SumList Xr X+S}
      end
   end
   fun {SumCount} @C end
end

{Browse {SumList [1 2 3] 0}}
{Browse {SumCount}}

% 6.3

declare
X={NewCell 0}
Y=X
Y:=10
{Browse @X}

declare
X=person(age:25 name:"George")
Y=person(age:25 name:"George")
{Browse X==Y}

declare
X={NewCell 10}
Y={NewCell 10}
{Browse X==Y}
{Browse @X==@Y}

declare
X={NewCell 10}
Y=X
{Browse X==Y}

% 6.4

declare
local
   fun {NewStack} nil end
   fun {Push S E} E|S end
   fun {Pop S ?E} case S of X|S1 then E=X S1 end end
   fun {IsEmpty S} S==nil end
in
   Stack=stack(new:NewStack push:Push pop:Pop isEmpty:IsEmpty)
end

declare
proc {NewWrapper ?Wrap ?UnWrap}
   Key={NewName} in
   fun {Wrap X}
      {Chunk.new w(Key:X)}
   end
   fun {UnWrap W}
      try W.Key catch _ then raise error(unwrap(W)) end end
   end
end

declare
local Wrap Unwrap
   {NewWrapper Wrap Unwrap}
   fun {NewStack} {Wrap nil} end
   fun {Push S E} {Wrap E|{Unwrap S}} end
   fun {Pop S ?E} case {Unwrap S} of X|S1 then E=X {Wrap S1} end end
   fun {IsEmpty S} {Unwrap S}==nil end
in
   Stack=stack(new:NewStack push:Push pop:Pop isEmpty:IsEmpty)
end

declare
local
   fun {StackObject S}
      fun {Push E} {StackObject E|S} end
      fun {Pop ?E} case S of X|S1 then E=X {StackObject S1} end end
      fun {IsEmpty} S==nil end
   in
      stack(push:Push pop:Pop isEmpty:IsEmpty) end
in
   fun {NewStack} {StackObject nil} end
end

declare S1 S2 S3 E in
S1={NewStack}
{Browse {S1.isEmpty}}
S2={S1.push 23}
S3={S2.pop E}
{Browse E}

declare
fun {NewStack}
   C={NewCell nil}
   proc {Push E} C:=E|@C end
   fun {Pop} case @C of X|S1 then C:=S1 X end end
   fun {IsEmpty} @C==nil end
in
   stack(push:Push pop:Pop isEmpty:IsEmpty)
end

declare
fun {NewStack}
   C={NewCell nil}
   proc {Push E} C:=E|@C end
   fun {Pop} case @C of X|S1 then C:=S1 X end end
   fun {IsEmpty} @C==nil end
in
   proc {$ Msg}
      case Msg
      of push(X) then {Push X}
      [] pop(?E) then E={Pop}
      [] isEmpty(?B) then B={IsEmpty}
      end
   end
end

declare
local Wrap Unwrap
   {NewWrapper Wrap Unwrap}
   fun {NewStack} {Wrap {NewCell nil}} end
   proc {Push S E} C={Unwrap S} in C:=E|@C end
   fun {Pop S}
      C={Unwrap S} in case @C of X|S1 then C:=S1 X end end
   fun {IsEmpty S} @{Unwrap S}==nil end
in
   Stack=stack(new:NewStack push:Push pop:Pop isEmpty:IsEmpty)
end

declare
local Wrap Unwrap
   {NewWrapper Wrap Unwrap}
   fun {NewCollection} {Wrap {Stack.new}} end
   proc {Put C X} S={Unwrap C} in {Stack.push S X} end
   fun {Get C} S={Unwrap C} in {Stack.pop S} end
   fun {IsEmpty C} {Stack.isEmpty {Unwrap C}} end
in
   Collection=collection(new:NewCollection put:Put get:Get isEmpty:IsEmpty)
end

declare
C={Collection.new}
{Collection.put C 1}
{Collection.put C 2}
{Browse {Collection.get C}}
{Browse {Collection.get C}}

%% object
declare
fun {NewStack}
   C={NewCell nil}
   proc {Push E} C:=E|@C end
   fun {Pop} case @C of X|S1 then C:=S1 X end end
   fun {IsEmpty} @C==nil end
in
   stack(push:Push pop:Pop isEmpty:IsEmpty)
end

declare
fun {NewCollection}
   S={NewStack}
   proc {Put X} {S.push X} end
   fun {Get} {S.pop} end
   fun {IsEmpty} {S.isEmpty} end
in
   collection(put:Put get:Get isEmpty:IsEmpty)
end

declare
C={NewCollection}
{C.put 1}
{C.put 2}
{Browse {C.get}}
{Browse {C.get}}

% union

declare
proc {DoUntil BF S}
   if {BF} then skip else {S} {DoUntil BF S} end
end

declare
local Wrap Unwrap
   {NewWrapper Wrap Unwrap}
   fun {NewStack} {Wrap {NewCell nil}} end
   proc {Push S E} C={Unwrap S} in C:=E|@C end
   fun {Pop S}
      C={Unwrap S} in case @C of X|S1 then C:=S1 X end end
   fun {IsEmpty S} @{Unwrap S}==nil end
in
   Stack=stack(new:NewStack push:Push pop:Pop isEmpty:IsEmpty)
end

declare
local Wrap Unwrap
   {NewWrapper Wrap Unwrap}
   fun {NewCollection} {Wrap {Stack.new}} end
   proc {Put C X} S={Unwrap C} in {Stack.push S X} end
   fun {Get C} S={Unwrap C} in {Stack.pop S} end
   fun {IsEmpty C} {Stack.isEmpty {Unwrap C}} end
   proc {Union C1 C2}
      S1={Unwrap C1} S2={Unwrap C2} in
      {DoUntil fun {$} {Stack.isEmpty S2} end
       proc {$} {Stack.push S1 {Stack.pop S2}} end}
   end
in
   Collection=collection(new:NewCollection put:Put get:Get isEmpty:IsEmpty union:Union)
end

declare
C1={Collection.new}
C2={Collection.new}
for I in [1 2 3] do {Collection.put C1 I} end
for I in [4 5 6] do {Collection.put C2 I} end
{Collection.union C1 C2}
{Browse {Collection.isEmpty C2}}
{DoUntil fun {$} {Collection.isEmpty C1} end
proc {$} {Browse {Collection.get C1}} end}


declare
local Wrap Unwrap
   {NewWrapper Wrap Unwrap}
   fun {NewCollection} {Wrap {Stack.new}} end
   proc {Put C X} S={Unwrap C} in {Stack.push S X} end
   fun {Get C} S={Unwrap C} in {Stack.pop S} end
   fun {IsEmpty C} {Stack.isEmpty {Unwrap C}} end
   proc {Union C1 C2}
      {DoUntil fun {$} {Collection.isEmpty C2} end
      proc {$} {Collection.put C1 {Collection.get C2}} end}
   end
in
   Collection=collection(new:NewCollection put:Put get:Get isEmpty:IsEmpty union:Union)
end

declare
C1={Collection.new}
C2={Collection.new}
for I in [1 2 3] do {Collection.put C1 I} end
for I in [4 5 6] do {Collection.put C2 I} end
{Collection.union C1 C2}
{Browse {Collection.isEmpty C2}}
{DoUntil fun {$} {Collection.isEmpty C1} end
proc {$} {Browse {Collection.get C1}} end}

%% object
declare
fun {NewStack}
   C={NewCell nil}
   proc {Push E} C:=E|@C end
   fun {Pop} case @C of X|S1 then C:=S1 X end end
   fun {IsEmpty} @C==nil end
in
   stack(push:Push pop:Pop isEmpty:IsEmpty)
end

declare
fun {NewCollection}
   S={NewStack}
   proc {Put X} {S.push X} end
   fun {Get} {S.pop} end
   fun {IsEmpty} {S.isEmpty} end
   proc {Union C2}
      {DoUntil C2.isEmpty
       proc {$} {S1.push {C2.get}} end}
   end
in
   collection(put:Put get:Get isEmpty:IsEmpty union:Union)
end

declare
fun {NewCollection}
   S={NewStack}
   proc {Put X} {S.push X} end
   fun {Get} {S.pop} end
   fun {IsEmpty} {S.isEmpty} end
   proc {Union C2}
      {DoUntil C2.isEmpty
       proc {$} {This.put {C2.get}} end}
   end
   This=collection(put:Put get:Get isEmpty:IsEmpty union:Union)
in
   This
end

% 6.4.4
declare
proc {Sqr A}
   A:=@A*@A
end
local
   C={NewCell 0}
in
   C:=25
   {Sqr C}
   {Browse @C}
end

declare
proc {Sqr D}
   A={NewCell D}
in
   A:=@A+1
   {Browse @A*@A}
end
{Sqr 25}

declare
proc {Sqr A}
   D={NewCell @A}
in
   D:=@D*@D
   A:=@D
end
local
   C={NewCell 0}
in
   C:=25
   {Sqr C}
   {Browse @C}
end

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
proc {Sqr A}
   B={A}
in
   B:=@B*@B
end
local C={NewCell 0} in
   C:=25
   {Sqr fun {$} C end}
   {Browse @C}
end

% 6.4.5

declare
proc {Revocable Obj ?R ?RObj}
   C={NewCell Obj}
in
   proc {R}
      C:=proc {$ M} raise revokedError end end
   end
   proc {RObj M}
      {@C M}
   end
end

declare
fun {NewCollector}
   Lst={NewCell nil}
in
   proc {$ M}
      case M
      of add(X) then T in {Exchange Lst T X|T}
      [] get(L) then L={Reverse @Lst}
      end
   end
end
declare C R in
C={Revocable {NewCollector} R}
