proc {Max X Y ?Z}
   if X>=Y then Z=X else Z=Y end
end

declare C
{Max 1 2 C}
{Browse C}

local P Q in
   proc {Q X} {Browse stat(X)} end
   proc {P X} {Q X} end
   local Q in
      proc {Q X} {Browse dyn(X)} end
      {P hello}
   end
end

local X Y Z in
   f(X b) = f(a Y)
   f(Z a) = Z
   {Browse [X Y Z]}
end

declare X Y Z in
a(X c(Z) Z) = a(b(Y) Y d(X))
{Browse X#Y#Z}

declare L1 L2 L3 Head Tail in
L1 = Head|Tail
Head = 1
Tail = 2|nil

L2 = [1 2]
{Browse L1==L2}

L3='|'(1:1 2:'|'(2 nil))
{Browse L1==L3}

declare L1 L2 X in
L1=[X]
L2=[X]
{Browse L1==L2}

declare L1 L2 X in
L1=[1 a]
L2=[X b]
{Browse L1==L2}
