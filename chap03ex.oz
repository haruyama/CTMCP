declare
fun {BinarySearch F A B}
   if {Abs A-B} < 0.0001 then A
   else M in
      M = (A+B)/2.0
      if {F M} > 0.0 then {BinarySearch F A M}
      else {BinarySearch F M B}
      end
   end
end

{Browse {BinarySearch fun{$ X} X*X - 2.0 end 0.0 2.0}}
