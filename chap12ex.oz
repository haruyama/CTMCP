declare
fun {Sum N}
   if N == 1 then 1
   else N + {Sum N - 1}
   end
end
proc {AbsDiffTri2 ?Sol}
   NN={Sum 2}
in
   {FD.list NN 1#NN Sol}
   {FD.distinct Sol}
   {FD.distance {Nth Sol 3} {Nth Sol 2} '=:' {Nth Sol 1}}
   {FD.distribute ff Sol}
end
{Browse {SolveAll AbsDiffTri2}}

   
declare
fun {AbsDiffTri N}
   fun {Sum N}
      if N == 1 then 1
      else N + {Sum N - 1}
      end
   end
   fun {Tier I A M}
      if M =< A then
         I
      else
         {Tier I+1 A+I+1 M}
      end
   end
   proc {Distance Sol I}
      T={Tier 1 1 I}
   in
      {FD.distance {Nth Sol I+T+1} {Nth Sol I+T} '=:' {Nth Sol I}}
   end
in
   proc {$ Sol}
      NN={Sum N}
   in
      {FD.list NN 1#NN Sol}
      {FD.distinct Sol}
      for I in 1..(NN-N) do
         {Distance Sol I}
      end
      
      {FD.distribute ff Sol}
   end
end
{Browse {SolveAll {AbsDiffTri 3}}}
{Browse {SolveAll {AbsDiffTri 2}}}
{Browse {SolveAll {AbsDiffTri 4}}}
{Browse {SolveAll {AbsDiffTri 5}}}
{Browse {SolveAll {AbsDiffTri 6}}}
{Browse {SolveAll {AbsDiffTri 7}}}

% 2
declare
proc {Yaoya ?Sol}
   A B C D
in
   Sol=sol(a:A b:B c:C d:D)
   Sol:::1#711
   A*B*C*D=:7110000
   A+B+C+D=:711
   A=<:B
   B=<:C
   C=<:D
   {FD.distribute ff Sol}
end
{Browse {SolveAll Yaoya}}
   
% 3

declare
proc {Zebra Sol}
   B J N D P
   BB BR BW BG BY
   NE NS NJ NI NN
   JP JC JDI JV JDO
   DT DC DM DJ % DW
   PD PS PF PH PZ
in
   B=building(blue:BB red:BR white:BW green:BG yellow:BY)
   N=nation(england:NE spain:NS japan:NJ italia:NI norway:NN)
   J=job(painter:JP carver:JC diplomat:JDI violinist:JV doctor:JDO)
   D=drink(tea:DT coffee:DC milk:DM juice:DJ water:_)
   P=pet(dog:PD snail:PS fox:PF horse:PH zebra:PZ)
   Sol=[B N J D P]
   B:::1#5
   N:::1#5 % England Spain Japan Italia Norway
   J:::1#5 % Painter Carver Diplomat Violinist Doctor
   D:::1#5 % Tea Coffee Milk Juice Water
   P:::1#5 % Dog  Snail Fox Horse Zebra
   {FD.distinct B}
   {FD.distinct N}
   {FD.distinct J}
   {FD.distinct D}
   {FD.distinct P}
   % a
   NE=:BR
   % b
   NS=:PD
   % c
   NJ=:JP
   % d
   NI=:DT
   % e
   NN=:1
   % f
   BG=:DC
   % g
   BG=:BW+1
   % h
   JC=:PS
   % i
   JDI=:BY
   % j
   DM=:3
   % k
   {FD.distance NN BB '=:' 1}
   % l
   JV=:DJ
   % m
   {FD.distance PF JDO '=:' 1}
   % n
   {FD.distance PH JDI '=:' 1}
   % o
   % https://en.wikipedia.org/wiki/Zebra_Puzzle によると o に対応する項目がない
%   PZ=:BW
   
   {FD.distribute ff B}
   {FD.distribute ff J}
   {FD.distribute ff N}
   {FD.distribute ff D}
   {FD.distribute ff P}
end
{Browse {SolveAll Zebra}}
