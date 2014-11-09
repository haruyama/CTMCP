% 3
% a < b とは問題文にないのでそのチェックが必要

declare
fun {BinarySearch F A B}
   if {Abs A-B} < 0.0001 then A
   else M in
      M = (A+B)/2.0
      if {F M} > 0.0 then {BinarySearch F A M}
      elseif {F M} == 0. then M
      else {BinarySearch F M B}
      end
   end
end

{Browse {BinarySearch fun{$ X} X*X - 2.0 end 0.0 2.0}}

% 4

declare
fun {Fact N}
   fun {FactIter N A}
      if N==1 then A
      else {FactIter N-1 N*A} end
   end
in
   {FactIter N 1}
end

{Browse {Fact 10}}

%5

declare
fun {SumList Xs}
   fun {SumListIter Ys A}
      case Ys
      of nil then A
      [] Y|Yr then {SumListIter Yr A+Y} end
   end
in
   {SumListIter Xs 0}
end

{Browse {SumList [1 2 3 4 5]}}

% 6
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer6.oz

% 7
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer7.oz

% 8
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer8.oz

declare
fun {Append Xs Ys}
   fun {ReverseAppendIter Xs Ys}
      case Xs
      of nil then Ys
      [] X|Xr then {ReverseAppendIter Xr X|Ys} end
   end
   fun {Reverse Xs}
      fun {ReverseIter Xs A}
         case Xs
         of nil then A
         [] X|Xr then {ReverseIter Xr X|A} end
      end
   in
      {ReverseIter Xs nil}
   end
in
   {ReverseAppendIter {Reverse Xs} Ys}
end

{Browse {Append [1 2 3] [4 5]}}

% 9

declare
fun {Append Xs Ys}
   case Xs
   of nil then Ys
   else Xs.1 | {Append Xs.2 Ys}
   end
end

{Browse {Append [1 2 3] [4 5]}}

% 12
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer12.oz

% 13
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer13.oz
      
% 14
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer14.oz

% 15
% https://github.com/Altech/ctmcp-answers/blob/master/Section03/exer15.oz

declare
fun {QuickSort Ls}
   fun {QuickSortIter Ls E}
      case Ls
      of nil then E
      [] L|Lr then Ys Zs in
         {Devide Lr L Ys Zs}
         {QuickSortIter Ys L|{QuickSortIter Zs E}}
      end
   end
   proc {Devide Ls P ?Ys ?Zs}
      case Ls
      of nil then Ys=nil Zs=nil
      [] L|Lr then
         if L < P then Ys = L|{Devide Lr P $ Zs}
         else Zs=L|{Devide Lr P Ys $}
         end
      end
   end
in
   {QuickSortIter Ls nil}
end

{Browse {QuickSort [3 2 1 4 5 6 0 1]}}
