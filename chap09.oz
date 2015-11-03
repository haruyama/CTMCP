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

declare
L={Solve Suit}
{Browse L}

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

% 9.3

% fun {Append Ls Ms}
%    case Ls
%    of nil then Ms
%    [] X|Lr then X|{Append Lr Ms}
%    end
% end

declare
proc {Append A B ?C}
   case A
   of nil then C=B
   [] X|As then Cs in
      C=X|Cs
      {Append As B Cs}
   end
end
{Browse {Append [1 2 3] [4 5] $}}

declare
proc {Append ?A B C}
   if B==C then A=nil
   else
      case C of X|Cs then As in
         A=X|As
         {Append As B Cs}
      end
   end
end
{Browse {Append $ [4 5] [1 2 3 4 5]}}
% {Browse {Append $ [3 5] [1 2 3 4 5]}}

% 9.3.3
declare
proc {Append ?A ?B ?C}
   choice
      A=nil B=C
   [] As Cs X in
      A=X|As C=X|Cs {Append As B Cs}
   end
end

{Browse {SolveAll
         proc {$ S} X#Y=S in {Append X Y [1 2 3]} end}}

{Browse {SolveAll
         proc {$ X} {Append [1 2] [3 4 5] X} end}}

declare
proc {Touch N H}
   if N>0 then {Touch N-1 H.2} else skip end
end

declare
L={Solve proc {$ S} X#Y#Z=S in {Append X Y Z} end}
{Browse L}
{Touch 1 L}
{Touch 2 L}
{Touch 3 L}
{Touch 4 L}
{Touch 5 L}

% 9.4

declare
proc {TransVerb X0 X}
   X0=loves|X
end

{Browse {TransVerb [loves a man] $}}

declare
proc {Name X0 X}
   choice X0=john|X [] x0=mary|X end
end

proc {VerbPhrase X0 X}
   choice X1 in
      {TransVerb X0 X1} {NounPhrase X1 X}
   [] {IntransVerb X0 X}
   end
end

declare
fun {Name X0 X}
   choice
      X0=john|X john
   [] X0=mary|X mary
   end
end
fun {TransVerb S O X0 X}
   X0=loves|X
   loves(S O)
end
fun {Determiner S P1 P2 X0 X}
   choice
      X0=every|X
      all(S imply(P1 p2))
   []
      X0=a|X
      exists(S and(P1 P2))
   end
end
fun {NounPhrase N P1 X0 X}
   choice P P2 P3 X1 X2 in
      P={Determiner X P2 P1 X0 X1}
      P3={Noun N X1 X2}
      P2={RelClause N P3 X2 X}
      P
   []
      N={Name X0 X}
      P1
   end
end
fun {Noun N X0 X}
   choice
      X0=man|X
      man(N)
   []
      X0=woman|X
      woman(N)
   end
end
fun {IntransVerb S X0 X}
   X0=lives|X
   lives(S)
end
fun {Sentence X0 X}
   P P1 N X1 in
   P={NounPhrase N P1 X0 X1}
   P1={VerbPhrase N X1 X}
   P
end
fun {VerbPhrase S X0 X}
   choice O P1 X1 in
      P1={TransVerb S O X0 X1}
      {NounPhrase O P1 X1 X}
   [] {IntransVerb S X0 X}
   end
end
fun {RelClause S P1 X0 X}
   choice P2 X1 in
      X0=who|X1
      P2={VerbPhrase S X1 X}
      and(P1 P2)
   [] X0=X
      P1
   end
end


declare
fun {Goal}
   {Sentence [mary lives] nil}
end
{Browse {SolveAll Goal}}

declare
fun {Goal}
   {Sentence [every man loves mary] nil}
end
{Browse {SolveAll Goal}}

declare
fun {Goal}
   {Sentence [every man who lives loves a woman] nil}
end
{Browse {SolveAll Goal}}



declare
fun {Goal}
   {Sentence [_ _ _] nil}
end
{Browse {SolveAll Goal}}

% 9.5

declare
fun {NewParser Rules}
   proc {Parse Goal S0 S}
      case Goal
      of nil then S0=S
      [] G|Gs then S1 in
         {Parse G S0 S1}
         {Parse Gs S1 S}
      [] t(X) then S0=X|S
      else if {IsProcedure Goal} then
              {Goal}=true
              S0=S
           else Body Rs in
              Rs=Rules.{Label Goal}
              {ChooseRule Rs Goal Body}
              {Parse Body S0 S}
           end end
   end
   proc {ChooseRule Rs Goal Body}
      I={Space.choose {Length Rs}}
   in
      rule(Goal Body)={{List.nth Rs I}}
   end
in
   Parse
end

declare
Rules=r(sexpr:[fun {$} As in
                  rule(sexpr(s(As)) [t('(') seq(As) t(')')])
               end]
        seq: [fun {$}
                 rule(seq(nil) nil)
              end
              fun {$} As A in
                 rule(seq(A|As) [atom(A) seq(As)])
              end
              fun {$} As A in
                 rule(seq(A|As) [sexpr(A) seq(As)])
              end]
        atom: [fun {$} X in
                  rule(atom(X)
                       [t(X)
                        fun {$}
                           {IsAtom X} andthen X\='(' andthen X\=')'
                        end])
               end])


declare
Parse={NewParser Rules}
{Browse {SolveOne
         fun {$} E in
            {Parse sexpr(E)
             ['(' hello '(' this is an sexpr ')' ')'] nil}
            E
         end}}

% 9.6

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

declare
NodeRel={New RelationClass init}
{NodeRel
 assertall([node(1) node(2) node(3) node(4)
            node(5) node(6) node(7) node(8)])}
EdgeRel={New RelationClass init}
{EdgeRel
 assertall([edge(1 2) edge(2 1) edge(2 3) edge(3 4)
            edge(2 5) edge(5 6) edge(4 6) edge(6 7)
            edge(6 8) edge(1 5) edge(5 1)])}
proc {NodeP A} {NodeRel query(node(A))} end
proc {EdgeP A B} {EdgeRel query(edge(A B))} end

declare
proc {Q ?X} {EdgeP 1 X} end
{Browse {SolveAll Q}}

declare
proc {Q2 ?X} A B C D in
   {EdgeP A B} A<B=true
   {EdgeP B C} B<C=true
   {EdgeP C D} C<D=true
   X=path(A B C D)
end
{Browse {SolveAll Q2}}

declare
proc {PathP ?A ?B ?Path}
   {NodeP A}
   {Path2P A B [A] Path}
end
proc {Path2P ?A ?B Trace ?Path}
   choice
      A=B
      Path={Reverse Trace}
   [] C in
      {EdgeP A C}
      {Member C Trace}=false
      {Path2P C B C|Trace Path}
   end
end

declare
fun {Goal} P in
   {PathP 1 6 P}
   P
end
{Browse {SolveAll Goal}}


declare
fun {Goal} B P in
   {PathP 1 B P}
   B#P
end
{Browse {SolveAll Goal}}

{Browse {SolveAll fun {$} A P in {PathP A 7 P} A#P end}}



