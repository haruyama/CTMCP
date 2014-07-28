{Browse 9999*9999}

declare
V = 9999*9999
{Browse V*V}

declare
fun {Fact N}
   if N==0 then 1 else N * {Fact N-1} end
end
{Browse {Fact 10}}

{Browse {Fact 20}}

declare
fun {Comb N K}
   {Fact N} div ({Fact K} * {Fact N-K})
end

{Browse {Comb 10 3}}

{Browse [5 6 7 8]}

declare
L = [5 6 7 8]

{Browse L.1}
{Browse L.2}

declare
L = [5 6 7 8]
case L of H|T then {Browse H} {Browse T} end

declare Pascal AddList ShiftLeft ShiftRight
fun {Pascal N}
   if N == 1 then [1]
   else
      {AddList {ShiftLeft {Pascal N-1}} {ShiftRight {Pascal N-1}}}
   end
end

fun {ShiftLeft L}
   case L of H|T then
      H | {ShiftLeft T}
   else [0] end
end

fun {ShiftRight L}  0 | L end

fun {AddList L1 L2}
   case L1 of H1|T1 then
      case L2 of H2 | T2 then
         H1 + H2 | {AddList T1 T2}
      end
   else nil end
end

{Browse {Pascal 20}}

declare FastPascal
fun {FastPascal N}
   if N == 1 then [1]
   else L in
      L = {FastPascal N-1}
      {AddList {ShiftLeft L} {ShiftRight L}}
   end
end

{Browse {FastPascal 20}}

declare Ints
fun lazy {Ints N}
   N | {Ints N + 1}
end

declare
L={Ints 0}
{Browse L}
{Browse L.1}
case L of A|B|C|_ then {Browse A+B+C} end


declare PascalList
fun lazy {PascalList Row}
   Row | {PascalList
          {AddList {ShiftLeft Row} {ShiftRight Row}}}
end

declare
L = {PascalList [1]}
{Browse L}
{Browse L.1}
{Browse L.2.1}
{Browse L.2.2.1}
{Browse {List.take L 10}}
{Browse {List.nth L 10}}

declare PascalList2
fun {PascalList2 N Row}
   if N==1 then [Row]
   else
      Row | {PascalList2 N-1
             {AddList {ShiftLeft Row} {ShiftRight Row}}}
   end
end

{Browse {PascalList2 10 [1]}}

declare GenericPascal OpList
fun {GenericPascal Op N}
   if N==1 then [1]
   else L in
      L = {GenericPascal Op N-1}
      {OpList Op {ShiftLeft L} {ShiftRight L}}
   end
end

fun {OpList Op L1 L2}
   case L1 of H1|T1 then
      case L2 of H2|T2 then
         {Op H1 H2} | {OpList Op T1 T2}
      end
   else nil end
end

declare Add Xor
fun {Add X Y} X+Y end
fun {Xor X Y} if X==Y then 0 else 1 end end

{Browse {GenericPascal Add 10}}
{Browse {GenericPascal Xor 9}}
{Browse {GenericPascal Xor 10}}
{Browse {GenericPascal Xor 11}}

thread P in
   P = {Pascal 20}
   {Browse P}
end
{Browse 99*99}

declare X in
thread {Delay 10000} X=99 end
{Browse start} {Browse X*X}

declare X in
thread {Browse start} {Browse X*X} end
{Delay 10000} X=99

declare
C={NewCell 0}
C:=@C+1
{Browse @C}

declare
C={NewCell 0}
fun {FastPascal N}
   C:=@C+1
   {GenericPascal Add N}
end

{Browse {FastPascal 10}}
{Browse @C}

declare
local C in
   C = {NewCell 0}
   fun {Bump}
      C:=@C+1
      @C
   end
   fun {Read}
      @C
   end
end

{Browse {Bump}}
{Browse {Bump}}
{Browse {Read}}

declare
fun {NewCounter}
   C Bump Read in
   C={NewCell 0}
   fun {Bump}
      C:=@C+1
      @C
   end
   fun {Read}
      @C
   end
   counter(bump:Bump read:Read)
end

declare
Ctr1={NewCounter}
Ctr2={NewCounter}

{Ctr1.bump}
{Browse {Ctr1.bump}}
{Browse {Ctr1.read}}
{Browse {Ctr2.read}}

declare
C={NewCell 0}
thread
   C:=1
end
thread
   C:=2
end

{Browse @C}

declare
C={NewCell 0}
thread I in
   I=@C
   C:=I+1
end
thread J in
   J=@C
   C:=J+1
end

{Browse @C}

declare
C={NewCell 0}
L={NewLock}
thread
   lock L then I in
      I=@C
      C:=I+1
   end
end
thread
   lock L then J in
      J=@C
      C:=J+1
   end
end

{Browse @C}


% ex 1
declare Exp
fun {Exp N M}
   if M == 0 then
      1
   else
      N * {Exp N M-1}
   end
end

{Browse {Exp 2 10}}

declare P
P = 2*2*2*2*2
{Browse P*P}

declare P
P  =  10 * 9 * 8 * 7 * 6 * 5 * 4 * 3 * 2 * 1

{Browse P}
 
declare Comb2 RangeMulti
fun {Comb2 N K}
   if K == 0 then
      1
   else
      {RangeMulti N (N - K + 1)} div {RangeMulti K 1}
   end
end

fun {RangeMulti N M}
   if N =< M then
      N
   else
      N * {RangeMulti (N - 1) M}
   end
end

{Browse {RangeMulti 10 9}}

{Browse {Comb2 10 3}}
      
{Browse {Comb2 10 0}}

declare Comb3
fun {Comb3 N K}
   if K == 0 then
      1
   else
      if K > (N div 2) then
         {Comb2 N (N - K)}
      else 
         {Comb2 N K}
      end
   end
end

{Browse {Comb3 10 3}}
      
{Browse {Comb3 10 0}}

declare SumList
fun {SumList L}
   case L of X|L1 then X + {SumList L1}
   else 0 end
end

% {Browse {SumList {Ints 0}}}

declare Sub Mul Mul1
fun {Sub A B}  A - B end
fun {Mul A B}  A * B end
fun {Mul1 A B}  (A+1) * (B+1) end

for I in 1..10 do  {Browse {GenericPascal Sub I}} end
for I in 1..10 do  {Browse {GenericPascal Mul I}} end
for I in 1..10 do  {Browse {GenericPascal Mul1 I}} end

local X in
   X = 23
   local X in
      X = 44
   end
   {Browse X}
end

local X in
   X = {NewCell 23}
   X:=44
   {Browse @X}
end


declare Acc Accumulate
Acc = {NewCell 0}
fun {Accumulate N}
   Acc := @Acc + N
   @Acc
end

{Browse {Accumulate 5}}
{Browse {Accumulate 100}}
{Browse {Accumulate 45}}

declare
local Acc in
   Acc = {NewCell 0}
   fun {Accumulate N}
      Acc := @Acc + N
      @Acc
   end
end

{Browse {Accumulate 5}}
{Browse {Accumulate 100}}
{Browse {Accumulate 45}}

declare
S = {NewStore}
{Put S 2 [22 33]}
{Browse {Get S 2}}
{Browse {Size S}}

declare
local S in
   S = {NewStore}
   {Put S 1 [1]}
   fun {FasterPascal N}
      if {Size S} >= N then
         {Get S N}
      else  R L in
         L = {FasterPascal N-1}
         R = {AddList {ShiftLeft L} {ShiftRight L}}
         {Put S N R}
         R
      end
   end
end

{Browse {FasterPascal 5}}
{Browse {FastPascal 5}}
{Browse {FasterPascal 10}}
{Browse {FastPascal 10}}

{Browse {FasterPascal 20}}
{Browse {FastPascal 20}}

declare
fun {NewMemory}
   M C Find Get Put Size in   
   M = {NewCell nil}
   C = {NewCell 0}
   
   fun {Find N}
      fun {Iter L}
         case L
         of nil then nil
         [] H|T then if H.1 == N then H.2.1
                     else {Iter T} end
         end
      end
   in
      {Iter @M}
   end
   
   fun {Put N X}
      if {Not {Find N} == nil} then
         {Find N} := X
      else E in
         C := @C + 1
         E = [N {NewCell X}]
         M := case @M
              of nil then [E]
              else {List.append @M [E]}
              end
      end
      X
   end
   
   fun {Size}
      @C
   end

   fun {Get N}
      @{Find N}
   end
   
   memory(get:Get put:Put size:Size)
end

declare
M = {NewMemory}

{Browse {M.put 1 2}}
{Browse {M.size}}
{Browse {M.put 2 [2]}}
{Browse {M.size}}
{Browse {M.get 1}}
{Browse {M.get 2}}
{Browse {M.put 2 [3 4]}}
{Browse {M.get 2}}
{Browse {M.size}}
{Browse {M.put 3 1}}
{Browse {M.get 3}}
{Browse {M.size}}

declare
fun {NewMemory2}
   M C Find Get Put Size in   
   M = {NewCell nil}
   C = {NewCounter}
   
   fun {Find N}
      fun {Iter L}
         case L
         of nil then nil
         [] H|T then if H.1 == N then H.2.1
                     else {Iter T} end
         end
      end
   in
      {Iter @M}
   end
   
   fun {Put N X}
      if {Not {Find N} == nil} then
         {Find N} := X
      else E T in
         T = {C.bump}
         E = [N {NewCell X}]
         M := case @M
              of nil then [E]
              else {List.append @M [E]}
              end
      end
      X
   end
   
   fun {Size}
      {C.read}
   end

   fun {Get N}
      @{Find N}
   end
   
   memory2(get:Get put:Put size:Size)
end

declare
M = {NewMemory2}

{Browse {M.put 1 2}}
{Browse {M.size}}
{Browse {M.put 2 [2]}}
{Browse {M.size}}
{Browse {M.get 1}}
{Browse {M.get 2}}
{Browse {M.put 2 [3 4]}}
{Browse {M.get 2}}
{Browse {M.size}}
{Browse {M.put 3 1}}
{Browse {M.get 3}}
{Browse {M.size}}

% ex 10

declare
C={NewCell 0}
thread I in
   I=@C
   C:=I+1
end
thread J in
   J=@C
   C:=J+1
end

{Browse @C}

declare
C={NewCell 0}
thread I in
   I=@C
   {Delay 1000}
   C:=I+1
end
thread J in
   J=@C
   {Delay 1000}
   C:=J+1
end

{Browse @C}


declare
C={NewCell 0}
L={NewLock}
thread
   lock L then I in
      I=@C
      C:=I+1
   end
end
thread
   lock L then J in
      J=@C
      {Delay 100000}
      C:=J+1
   end
end

{Browse @C}

