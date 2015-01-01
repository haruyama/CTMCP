declare
fun {Gen L H}
   {Delay 1000}
   if L>H then nil else L|{Gen L+1 H} end
end
Xs = {Gen 1 10}
Ys = {Map Xs fun {$ X} X*X end}
{Browse Ys}

declare
fun {Gen L H}
   {Delay 1000}
   if L>H then nil else L|{Gen L+1 H} end
end
thread Xs = {Gen 1 10} end
thread Ys = {Map Xs fun {$ X} X*X end} end
{Browse Ys}

declare X Y
thread X=1 end
thread Y=2 end
thread X=Y end

declare X Y
local X1 Y1 S1 S2 S3 in
   thread
      try X1=1 S1=ok catch _ then S1=error end
   end
   thread
      try Y1=2 S2=ok catch _ then S2=error end
   end
   thread
      try X1=Y1 S3=ok catch _ then S3=error end
   end
   if S1==error orelse S2==error orelse S3==error then
      X=1
      Y=1
   else X=X1 Y=Y1 end
   {Browse S1}
   {Browse S2}
   {Browse S3}
end
{Browse X}
{Browse Y}

% 4.2

declare
thread
   proc {Count N} if N>0 then {Count N-1} end end
in
   {Count 1000000}
   {Browse done}
end
{Browse main}

declare X in
X = thread 10*10 end + 100 * 100
{Browse X}

declare X1 X2 Y1 Y2 in
thread {Browse X1} end
thread {Browse Y1} end
thread X1=all|roads|X2 end
thread Y1=all|roams|Y2 end
thread X2=lead|to|rome|_ end
thread Y2=lead|to|rhodes|_ end

declare X0 X1 X2 X3 in
thread
   Y0 Y1 Y2 Y3 in
   {Browse [Y0 Y1 Y2 Y3]}
   Y0=X0+1
   Y1=X1+Y0
   Y2=X2+Y1
   Y3=X3+Y2
   {Browse complated}
end
{Browse [X0 X1 X2 X3]}

X0=0
X1=1
X2=2
X3=3

declare L in
thread {ForAll L Browse} end

declare L1 L2 in
thread L=1|L1 end
thread L1=2|3|L2 end
thread L2=4|nil end

declare
fun {PMap Xs F}
   case Xs of nil then nil
   [] X|Xr then thread {F X} end|{PMap Xr F} end
end

declare F Xs Ys Zs
{Browse thread {PMap Xs F} end}

Xs=1|2|Ys
fun {F X} X*X end

Ys=3|Zs
Zs=nil

% declare F Xs Ys Zs
% {Browse {PMap Xs F}}

% Xs=1|2|Ys
% fun {F X} X*X end

% Ys=3|Zs
% Zs=nil

declare
fun {Fib X}
   if X=<2 then 1
   else thread {Fib X-1} end + {Fib X-2} end
end

{Browse {Fib 26}}

{Browse {Thread.this}}
{Browse {Thread.state {Thread.this}}}
