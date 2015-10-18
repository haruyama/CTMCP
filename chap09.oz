declare
fun {Soft} choice beige [] coral end end
fun {Hard} choice mauve [] ochre end end
proc {Contrast C1 C2}
   choice C1={Soft} C2={Hard} [] C1={Hard} C2={Soft} end
end
fun {Suit}
   Shirt Pants Socks
in
   {Contrast Shirt Pants}
   {Contrast Pants Socks}
   if Shirt==Socks then fail end
   suit(Shirt Pants Socks)
end

declare
L={Solve fun {$} choice 1 [] 2 [] 3 end end}
{Browse L}
{Browse L.1}

declare
fun {SolveOne F}
   L={Solve F}
in
   if L==nil then nil else [L.1] end
end

{Browse {SolveOne Suit}}

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

{Browse {SolveAll Suit}}

% 9.2

declare
fun {Digit}
   choice 0 [] 1 [] 2 [] 3 [] 4 [] 5 [] 6 [] 7 [] 8 [] 9 end
end
{Browse {SolveAll Digit}}

declare
fun {TwoDigit}
   10*{Digit}+{Digit}
end
{Browse {SolveAll TwoDigit}}

declare
fun {StrangeTwoDigit}
   {Digit}+10*{Digit}
end
{Browse {SolveAll StrangeTwoDigit}}

declare
proc {Palindrome ?X}
   X=(10*{Digit}+{Digit})*(10*{Digit}+{Digit})
   (X>0)=true
   (X>=1000)=true
   (X div 1000) mod 10 = (X div 1) mod  10
   (X div 100) mod 10 = (X div 10) mod  10
end
{Browse {SolveAll Palindrome}}

declare
fun {Queens N}
   fun {MakeList N}
      if N==0 then nil else _|{MakeList N-1} end
   end

   proc {PlaceQueens N ?Cs ?Us ?Ds}
      if N>0 then Ds2
         Us2=_|Us
      in
         Ds=_|Ds2
         {PlaceQueens N-1 Cs Us2 Ds2}
         {PlaceQueen N Cs Us Ds}
      else skip end
   end

   proc {PlaceQueen N ?Cs ?Us ?Ds}
      choice
         Cs=N|_ Us=N|_ Ds=N|_
      [] _|Cs2=Cs _|Us2=Us _|Ds2=Ds in
         {PlaceQueen N Cs2 Us2 Ds2}
      end
   end
   Qs={MakeList N}
in
   {PlaceQueens N Qs _ _}
   Qs
end
   
{Browse {SolveOne fun {$} {Queens 8} end}}
{Browse {Length {SolveAll fun {$} {Queens 8} end}}}
