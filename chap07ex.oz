% 1

declare
fun {New2 Class}
   TInit = {NewName}
in
   {New
    class $ from Class
       meth !TInit skip end
    end
    TInit}
end

declare
class Counter
   attr val
   meth init(Value)
      val:=Value
   end
   meth browse
      {Browse @val}
   end
   meth inc(Value)
      val:=@val+Value
   end
end


declare
C={New2 Counter}
{C init(0)}
{C browse}

% 5
declare
class Server
   meth init skip end
   meth calc(X Y)
      Y=X*X+2.0*X+2.0
   end
end

declare
class Server
   meth init skip end
   meth calc(X Y)
      Y=X*X+2.0*X+2.0
   end
end
class Client
   attr server
   meth init(S)
      server:=S
   end
   meth calc(X Y)
      {@server calc(X Y)}
   end
end

declare
S={NewActive Server init}
C={NewActive Client init(S)}
{Browse {C calc(2.0 $)}}
