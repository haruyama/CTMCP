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
C:={New2 Counter}
{C init(0)}
{C browse}
