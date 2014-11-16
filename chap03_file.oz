% http://mozart.github.io/mozart-v1/doc-1.4.0/op/node6.html

%declare [Open]={Module.link ['/usr/share/mozart/cache/x-oz/system/Open.ozf']}
%declare [Open]={Module.link ['x-oz://system/Open.ozf']}
declare
F={New Open.file init(name:'chap03.oz' flags:[read])}
{F read(list:{Browse} size:all)}
{F close}

declare [Open]={Module.link ['x-oz://system/Open.ozf']}
F={New Open.file  
   init(name:  'foo.txt' 
        flags: [write create]
        mode:  mode(owner: [read write]  
                    group: [read write]))}
{F write(vs:'This comes in the file.\n')}
{F write(vs:'The result of 43*43 is '#43*43#'.\n')}
{F write(vs:"Strings are ok too.\n")}
{F close}

declare [QTk]={Module.link ['x-oz://system/wp/QTk.ozf']}
D=td(button(text:"Press me"
            action:proc {$} {Browse ouch} end))
W={QTk.build D}
{W show}

declare
fun {Fact N}
   if N==0 then 1 else N*{Fact N-1} end
end
F100={Fact 100}
F100Gen1=fun {$} F100 end
F100Gen2=fun {$} {Fact 100} end
FNGen1 = fun {$ N} F={Fact N} in fun {$} F end end
FNGen2 = fun {$ N} fun {$} {Fact N} end end
{Pickle.save [F100Gen1 F100Gen2 FNGen1 FNGen2] 'factfile'}

declare [F1 F2 F3 F4]={Pickle.load 'factfile'} in
{Browse {F1}}
{Browse {F2}}
{Browse {{F3 100}}}
{Browse {{F4 100}}}

declare F1 F2 F3 F4 in
{Browse {F1}}
{Browse {F2}}
{Browse {{F3 100}}}
{Browse {{F4 100}}}
[F1 F2 F3 F4]={Pickle.load 'factfile'}
