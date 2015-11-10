declare
fun {SolveOne F}
   L={Solve F}
in
   if L==nil then nil else [L.1] end
end

declare
fun {SolveAll F}
   L={Solve F}
   proc {TouchAll L}
      if L==nil then skip else {TouchAll L.2} end
   end
in
   {TouchAll L}
   L
end

declare
proc {Choose ?X Ys}
   choice Ys=X|_
   [] Yr in Ys=_|Yr {Choose X Yr} end
end
class RelationClass
   attr d
   meth init
      d:={NewDictionary}
   end
   meth assertall(Is)
      for I in Is do {self assert(I)} end
   end
   meth assert(I)
      if {IsDet I.1} then
         Is={Dictionary.condGet @d I.1 nil} in
         {Dictionary.put @d I.1 {Append Is [I]}}
      else
         raise databaseError(nonground(I)) end
      end
   end
   meth query(I)
      if {IsDet I} andthen {IsDet I.1} then
         {Choose I {Dictionary.condGet @d I.1 nil}}
      else
         {Choose I {Flatten {Dictionary.items @d}}}
      end
   end
end


% 9.3
declare
DataRel={New RelationClass init}
{DataRel
 assertall([
            data(tokyo sanfrancisco 5131 true)
            data(tokyo detroit 6398 true)
            data(tokyo ny 6754 true)
            data(tokyo hawaii 3881 true)
            data(tokyo la 5451 true)
            data(tokyo paris 6206 true)
            data(tokyo shanhai 1123 true)
            data(tokyo sydney 4872 true)
            data(sanfrancisco atranta 2136 true)
            data(sanfrancisco denver 966 true)
            data(ny sanfrancisco 2566 true)
            data(ny la 2475 true)
           ])}

declare
fun {Plan City1 City2}
   {Plan2P City1 City2 [City1] 0}
end
fun {Plan2P City1 City2 Trace Distance}
   choice
      City1=City2
      Distance#{Reverse Trace}
   [] City3 D in
      {DataRel query(data(City1 City3 D _))}
      {Member City3 Trace}=false
      {Plan2P City3 City2 City3|Trace Distance+D}
   end
end

declare
{Browse {SolveAll fun {$} {Plan tokyo la} end}}


declare
fun {BestPlan City1 City2}
   fun {Iter S R}
      if S==nil then
         R
      else Xr DR D P in
         S=D#P|Xr
         R=DR#_
         if D < DR then
            {Iter Xr D#P}
         else
            {Iter Xr R}
         end
      end
   end
in
   {Iter {SolveAll fun {$} {Plan City1 City2} end} 10000000#nil}
end

{Browse {BestPlan tokyo la}}





% c
% ダイクストラ法
