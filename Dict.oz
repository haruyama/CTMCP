functor
export new:NewDict put:Put condGet:CondGet entries:Entries
define
   fun {NewDict} leaf end

   fun {Put Ds Key Value}
      case Ds
      of leaf then tree(Key Value leaf leaf)
      [] tree(K _ L R) andthen K==Key then
         tree(K Value L R)
      [] tree(K V L R) andthen K>Key then
         tree(K V {Put L Key Value} R)
      [] tree(K V L R) andthen K<Key then
         tree(K V L {Put R Key Value})
      end
   end

   fun {CondGet Ds Key Default}
      case Ds
      of leaf then Default
      [] tree(K V _ _) andthen K==Key then V
      [] tree(K _ L _) andthen K>Key then
         {CondGet L Key Default}
      [] tree(K _ _ R) andthen K<Key then
         {CondGet R Key Default}
      end
   end

   fun {Entries Ds}
      proc {EntriesD Ds S1 ?Sn}
         case Ds
         of leaf then
            S1=Sn
         [] tree(K V L R) then S2 S3 in
            {EntriesD L S1 S2}
            S2=K#V|S3
            {EntriesD R S3 Sn}
         end
      end
   in {EntriesD Ds $ nil} end
end
