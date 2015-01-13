%%%%%%%%%%%%%%%%%%%%%%%%%%% Chapter 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simple file input/output

% Authors: Peter Van Roy and Seif Haridi
% May 19, 2003

% This is the File module, which defines some simple file
% input/output abstractions.
% ReadList, ReadListLazy, and WriteList are self-contained
% and will read and write a complete file to and from a list.
% WriteOpen, Write, and WriteClose are incremental; the first call
% must be WriteOpen, followed by any number of Write calls,
% followed by one WriteClose call.

functor
import
   Open Finalize
export
   readList:ReadList
   readListLazy:ReadListLazy
   readOpen:ReadOpen readBlock:ReadBlock readClose:ReadClose
   writeList:WriteList
   writeOpen:WriteOpen write:Write writeClose:WriteClose
define
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Reading

   % Read complete file S into character list L
   proc {ReadList S ?L}
      F={New Open.file init(name:S)}
   in
      {F read(list:L size:all)}
      {F close}
   end
     
   % Same as above, but the read is lazy
   fun {ReadListLazy S}
      F={New Open.file init(name:S)}
      fun lazy {ReadNext}
         L T I
      in
         {F read(list:L tail:T size:1024 len:I)}
         if I==0 then T=nil {F close} else T={ReadNext} end
         L
      end
   in
      {Finalize.register F proc {$ F} {F close} end}
      {ReadNext}
   end

   % Incremental file read operations
   R={NewCell unit}

   % Open file S for reading 
   proc {ReadOpen S}
      R:={New Open.file init(name:S)}
   end

   % Read one block with length I in the difference list L#T
   proc {ReadBlock ?I ?L ?T}
      {@R read(list:L tail:T size:1024 len:I)}
   end

   % Close the opened file
   proc {ReadClose}
      if @R\=unit then {@R close} end
      R:=unit
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Writing

   % Write character list L into file S
   proc {WriteList S L}
      F={New Open.file init(name:S flags:[create write truncate])}
   in
      {F write(vs:L)}
      {F close}
   end

   % Incremental file write operations
   W={NewCell unit}

   % Open file S for writing
   proc {WriteOpen S}
      W:={New Open.file init(name:S flags:[create write truncate])}
   end

   proc {WriteAppend S}
      W:={New Open.file init(name:S flags:[create write])}
   end

   % Append character list L to the opened file
   proc {Write L}
      {@W write(vs:L)}
   end

   % Close the opened file
   proc {WriteClose}
      if @W\=unit then {@W close} end
      W:=unit
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
