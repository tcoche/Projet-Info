declare
fun{Hauteur Note}
      if Note.name==a andthen Note.sharp==false then 12*(Note.octave-4)
      elseif Note.name==a andthen Note.sharp==true then 12*(Note.octave-4)+1
      elseif Note.name==b andthen Note.sharp==false then 12*(Note.octave-4)+2
      elseif Note.name==c andthen Note.sharp==false then 12*(Note.octave-4)-9
      elseif Note.name==c andthen Note.sharp==true then 12*(Note.octave-4)-8
      elseif Note.name==d andthen Note.sharp==false then 12*(Note.octave-4)-7
      elseif Note.name==d andthen Note.sharp==true then 12*(Note.octave-4)-6
      elseif Note.name==e andthen Note.sharp==false then 12*(Note.octave-4)-5
      elseif Note.name==f andthen Note.sharp==false then 12*(Note.octave-4)-4
      elseif Note.name==f andthen Note.sharp==true then 12*(Note.octave-4)-3
      elseif Note.name==c andthen Note.sharp==true then 12*(Note.octave-4)-2
      elseif Note.name==c andthen Note.sharp==true then 12*(Note.octave-4)-1
      end
end

{Browse {Hauteur note(name:a octave:5 sharp:false duration:5 instryument:none)}}

declare
fun{Exp Amount Int}
   local fun{ExpAcc Amount Int A}
	    if Amount==0 then A
	    else {ExpAcc Amount-1 Int A*Int}
	    end
	 end
   in
      {ExpAcc Amount Int 1}
   end
end


declare
fun{Frequence Note}
   local Expo in
      Expo=({Hauteur Note} div 12)
      {Exp exp 2}*440
   end
end

declare
fun{Sample I Note}
   local pi=3.141592 in
      0.5*sin(2*pi*{Frequence Note}*I div 44100)
   end
end

declare
fun {Samples Duration  Note}
   local Dur=Duration*44100 in
      local fun{Samples1 Dur Note I}
	       if I<44100 then {Sample I  Note}|{Samples1 Dur Note I+1}
	       elseif I==44100 then nil
	       end
	    end
      in
	 {Samples1 Dur Note 0}
      end
   end
end

   
   