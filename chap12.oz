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
proc {Rectangle ?Sol}
   sol(X Y)=Sol
in
   X::1#9 Y::1#9
   X*Y=:24 X+Y=:10 X=<:Y
   {FD.distribute naive Sol}
end
{Browse {SolveAll Rectangle}}

declare
proc {SendMoreMoney ?Sol}
   S E N D M O R Y
in
   Sol=sol(s:S e:E n:N d:D m:M o:O r:R y:Y)
   Sol:::0#9
   {FD.distinct Sol}
   S\=:0
   M\=:0
   1000*S + 100*E + 10*N + D
   + 1000*M + 100*O + 10*R + E
   =: 10000*M + 1000*O + 100*N + 10*E + Y
   {FD.distribute ff Sol}
end
{Browse {SolveAll SendMoreMoney}}


declare
proc {Palindrome ?A}
   B C X Y
in
   A::0#9999 B::0#99 C::0#99
   A=:B*C
   X::1#9 Y::0#9
   A=:X*1000+Y*100+Y*10+X
   {FD.distribute ff [X Y B C]}
end
{Browse {SolveAll Palindrome}}

declare
proc {Palindrome ?Sol}
   sol(A)=Sol
   B C X Y Z
in
   A::0#90909 B::0#90 C::0#999
   A=:B*C
   X::1#9 Y::0#9 Z::0#9
   A=:X*9091+Y*910+Z*100
   {FD.distribute ff [X Y Z]}
end
{Browse {SolveAll Palindrome}}
