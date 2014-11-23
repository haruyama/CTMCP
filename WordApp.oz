functor
import
   Dict
   Open
   QTk at 'x-oz://system/wp/QTk.ozf'
define
   fun {WordChar C}
      (&a=<C andthen C=<&z) orelse
      (&A=<C andthen C=<&Z) orelse (&0=<C andthen C=<&9)
   end

   fun {WordToAtom PW} {StringToAtom {Reverse PW}} end

   fun {IncWord D W} {Dict.put D W {Dict.condGet D W 0}+1} end

   fun {CharsToWords PW Cs}
      case Cs
      of nil andthen PW==nil then
         nil
      [] nil then
         [{WordToAtom PW}]
      [] C|Cr andthen {WordChar C} then
         {CharsToWords {Char.toLower C}|PW Cr}
      [] _|Cr andthen PW==nil then
         {CharsToWords nil Cr}
      [] _|Cr then
         {WordToAtom PW}|{CharsToWords nil Cr}
      end
   end

   fun {CountWords D Ws}
      case Ws of W|Wr then {CountWords {IncWord D W} Wr}
      [] nil then D end
   end

   fun {WordFreq Cs}
      {CountWords {Dict.new} {CharsToWords nil Cs}} end

   L
   F={New Open.file init(name:stdin flags:[read])}
   {F read(list:L size:all)}
   {F close}
   E={Dict.entries {WordFreq L}}
   S={Sort E fun {$ A B} A.2>B.2 end}
   H Des=td(title:'Word frequency cont'
            text(handle:H tdscrollbar:true glue:nswe))
   W={QTk.build Des} {W show}
   for X#Y in S do {H insert('end' X#': '#Y#' times\n')} end
end





