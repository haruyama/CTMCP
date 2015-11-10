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
