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

