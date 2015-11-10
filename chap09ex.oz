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

% 9.4

declare
SlotRel={New RelationClass init}
{SlotRel
 assertall([
            slot(mon am cataloger 1)
            slot(mon am checkoutclerk 1)
            slot(mon pm checkoutclerk 1)
            slot(mon am shelver 2)            
            slot(mon pm shelver 2)

            % slot(tue am cataloger 1)
            % slot(tue am checkoutclerk 1)
            % slot(tue pm checkoutclerk 1)
            % slot(tue am shelver 2)            
            % slot(tue pm shelver 2)

            % slot(wed am cataloger 1)
            % slot(wed am checkoutclerk 1)
            % slot(wed pm checkoutclerk 1)
            % slot(wed am shelver 2)            
            % slot(wed pm shelver 2)

            % slot(thu am cataloger 1)
            % slot(thu am checkoutclerk 1)
            % slot(thu pm checkoutclerk 1)
            % slot(thu am shelver 2)            
            % slot(thu pm shelver 2)

            % slot(fri am cataloger 1)
            % slot(fri am checkoutclerk 1)
            % slot(fri pm checkoutclerk 1)
            % slot(fri am shelver 2)            
            % slot(fri pm shelver 2)
           ])}
PersonRel={New RelationClass init}
{PersonRel
 assertall([
            person(alice 6 8 2 [mon tue thu fri])
            person(bob 7 10 2 [mon tue wed thu fri])
            person(carol 3 5 1 [mon tue wed thu fri])
            person(don 6 8 2 [mon tue wed])
            person(ellen 0 2 1 [thu fri])
            person(fred 7 10 2 [mon tue wed thu fri])
           ])}
JobRel={New RelationClass init}
{JobRel
 assertall([
            job(cataloger [fred alice])
            job(checkoutclerk [bob carol fred])
            job(shelver [bob carol fred don ellen alice])
           ])}

% a

declare
fun {WeekDayG}
   {List.nth [mon tue wed thu fri] {Space.choose 5}}
end
fun {ShiftG}
   choice
      am
   []
      pm
   end
end
fun {JobG}
   choice
      cataloger
   []
      checkoutclerk
   []
      shelver
   end
end
fun {PersonG}
   {List.nth [alice bob carol don ellen fred] {Space.choose 6}}
end


declare
proc {PersonP Name Job WeekDay}
   local WeekDays Names in
      {PersonRel query(person(Name _ _ _ WeekDays))}
      {Member WeekDay WeekDays}=true
      {JobRel query(job(Job Names))}
      {Member Name Names}=true
   end
end
proc {SlotP WeekDay Shift Job}
   {SlotRel query(slot(WeekDay Shift Job _))}
end


%declare
%{Browse {SolveAll proc {$ N} {PersonP N shelver fri} end}}
%{Browse {SolveAll proc {$ N} {PersonP N cataloger mon } end}}


declare
proc {Assignment ?A}
   local WeekDay Shift Job Person in
      WeekDay={WeekDayG}
      Shift={ShiftG}
      Job={JobG}
      Person={PersonG}
      {PersonP Person Job WeekDay}
      {SlotP WeekDay Shift Job}
      A=assignment(WeekDay Shift Job Person)
   end
end


%{Browse {SolveAll Assignment}}

declare
fun {CalcAllSlotCount}
   local
      fun {Iter C Slots}
         if Slots==nil then
            C
         else S|Sr=Slots Cs in
            S=slot(_ _ _ Cs)
            {Iter C+Cs Sr}
         end
      end
      proc {SlotPP ?X} A B C D in
         {SlotRel query(slot(A B C D))}
         X=slot(A B C D)
      end
   in
      {Iter 0 {SolveAll SlotPP}}
   end
end


{Browse {CalcAllSlotCount}}
{Browse {Length {SolveAll proc {$ N} {SlotRel query(_)} end}}}

declare
proc {Assignments ?As}
   local SlotCount in
      SlotCount={CalcAllSlotCount}
      {AssignmentsIter nil {NewDictionary} {NewDictionary} ?As SlotCount}
   end
end
fun {SlotKey WeekDay Shift Job}
   {StringToAtom
    {Append
     {Append 
      {AtomToString Job} {AtomToString Shift}
     }
     {AtomToString WeekDay}}}
end
fun {DailyShiftKey WeekDay Person}
   {StringToAtom
    {Append
      {AtomToString WeekDay} {AtomToString Person}
     }}
end
proc {AssignmentsIter Trace SlotDic DailyShiftDic ?As SlotCount}
   if {Length Trace}==SlotCount then
      Trace=As
   else A AWeekDay AShift AJob Sc Sd APerson Dc Dd in
      {Assignment A}
      A=assignment(AWeekDay AShift AJob APerson)
      Sc={Dictionary.condGet SlotDic {SlotKey AWeekDay AShift AJob} 0}
      {SlotRel query(slot(AWeekDay AShift AJob Sd))}
      if Sc >= Sd then
         fail
      end
      Dc={Dictionary.condGet DailyShiftDic {DailyShiftKey AWeekDay APerson} 0}
      {PersonRel query(person(APerson _ _ Dd _))}
      if Dc >= Dd then
         fail
      end
      {CheckAssignments A Trace}
      {Dictionary.put SlotDic {SlotKey AWeekDay AShift AJob} Sc+1}
      {Dictionary.put DailyShiftDic {DailyShiftKey AWeekDay APerson} Dc+1}
      {AssignmentsIter A|Trace SlotDic DailyShiftDic As SlotCount}
   end
end
proc {CheckAssignments A Trace}
   if Trace==nil then
      skip
   else T|Tr=Trace AWeekDay AShift APerson TWeekDay TShift TPerson in
      A=assignment(AWeekDay AShift _ APerson)
      T=assignment(TWeekDay TShift _ TPerson)
      if APerson==TPerson andthen AWeekDay==TWeekDay andthen AShift==TShift then
         fail
      end
      {CheckAssignments A Tr}
   end
end

{Browse {SolveOne Assignments}}
     
% 5
declare L
L={SolveAll fun {$} choice 1 [] 2 [] 3 end end}
{Browse L}

declare S P={NewPort S}
thread for X#Y in S do {Browse p(X)} Y=unit end end
L={SolveAll fun {$}
               choice Y in {Port.sendRecv P 1 Y} {Wait Y} 1
               [] Y in {Port.sendRecv P 2 Y} {Wait Y} 2
               [] Y in {Port.sendRecv P 3 Y} {Wait Y} 3
               end end}
{Browse L}

% Port の利用まで
declare
proc {Choose ?X Ys}
   choice Ys=X|_
   [] Yr in Ys=_|Yr {Choose X Yr} end
end
class PortRelationClass
   attr d
   meth init(S)
      d:={NewDictionary}
      thread for X#Y in S do {self X} Y=unit end end
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

declare S P={NewPort S} Y
TestRel={New PortRelationClass init(S)}
{Browse {SolveAll proc {$ N} {TestRel query(test(N))} end}}
{Port.sendRecv P assert(test(1)) Y} {Wait Y}
{Browse {SolveAll proc {$ N} {TestRel query(test(N))} end}}

% 6

declare
Rules=rules(
         fun {$} X Y Xr in
            [g(stack(X|Y|Xr)) f(supports(X Y))] #
            [remove(g(stack(X|Y|Xr))) add(g(stack(Y|Xr)))]
         end
         fun {$} X Y Z Xr in
            [g(stack(X|Y|Xr))
             'not'(fun {$} U in f(supports(X U)) end)
             'not'(fun {$} U in f(supports(Y U)) end)
             f(supports(Z Y))] #
            [remove(f(supports(Z Y))) add(f(supports(X Y)))
             remove(g(stack(X|Y|Xr))) add(g(stack(Y|Xr)))]
         end
         fun {$} X Y Xr Z in
            [g(stack(X|Y|Xr)) f(supports(X Z)) notEqual(Y Z)
             'not' (fun {$} g(move(Z)) end)] #
            [add(g(move(Z)))]
         end
         fun {$} X Y Xr in
            [g(stack(_|X|Xr)) f(supports(X Y))
             'not' (fun {$} g(move(Y)) end)] #
            [add(g(move(Y)))]
         end
         fun {$} X in
            [g(stack([X])) f(supports(floor X))
             'not'(fun {$} U in f(supports(X U)) end)] #
            [remove(g(stack[X]))]
         end
         fun {$} X Y in
            [g(move(X)) f(supports(X Y))
             'not'(fun {$} g(move(Y)) end)] #
            [add(g(move(Y)))]
         end
         fun {$} X Y in
            [g(move(X))
             'not'(fun {$} U in f(supports(X U)) end)
             f(supports(Y X))] #
            [remove(f(supports(Y X))) add(f(supports(floor X)))
             remove(g(move(X)))]
         end)

% 1から作るのは面倒
declare
proc {ConditionParse Conds DB}
   proc {Iter Conds}
      case Conds
      of C|Cs then
         {Browse C}
         {Iter Cs}
      else skip
      end
   end
in
   {Iter {Conds}}
end

{ConditionParse 
 fun {$} X Y in
            [g(move(X))
             'not'(fun {$} U in f(supports(X U)) end)
             f(supports(Y X))]
 end
 nil}
{Browse a}
{fun {$} X Y in
    [g(move(X))
     'not'(fun {$} U in f(supports(X U)) end)
     f(supports(Y X))]]
end}
