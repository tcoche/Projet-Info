declare
fun{Hauteur Note}
   if Note.name==a then if  Note.sharp then 12*(Note.octave-4)+1
			else 12*(Note.octave-4)
			end
   elseif Note.name==b then 12*(Note.octave-4)+2
   elseif Note.name==c then if Note.sharp then 12*(Note.octave-4)-8
			    else 12*(Note.octave-4)-9
			    end
   elseif Note.name==d then if Note.sharp then 12*(Note.octave-4)-6
			    else 12*(Note.octave-4)-6
			    end
   elseif Note.name==e then 12*(Note.octave-4)-5
   elseif Note.name==f then if Note.sharp then 12*(Note.octave-4)-3
			    else 12*(Note.octave-4)-4
			    end
   elseif Note.name==c then if Note.sharp then 12*(Note.octave-4)-1
			       else 12*(Note.octave-4)-2
			    end
   else 0
   end
end

{Browse {Hauteur note(name:c octave:4 sharp:true duration:1.0 instrument:none)}} %Doit renvoyer -8
{Browse {Hauteur note(name:a octave:4 sharp:false duration:1.0 instrument:none)}} %Doit renvoyer 0
{Browse {Hauteur note(name:a octave:6 sharp:false duration:1.0 instrument note)}} %Doit renvoyer 24

declare
fun{Frequence Note}
   local Expo in
      Expo=({Int.toFloat {Hauteur Note}}/12.0)
       {Pow 2.0 Expo}*440.0
   end
end

{Browse {Frequence note(name:a octave:4 sharp:false duration:1.0 instrument:none)}} %Doit renvoyer 440
{Browse {Frequence note(name:c octave:4 sharp:true duration:1.0 instrument:none)}} %Doit renvoyer 277.18
{Browse {Frequence note(name:a octave:6 sharp:false duration:1.0 instrument note)}} %Doit renvoyer 1760

declare
fun{Sample I Note}
   0.5*{Float.sin (2.0*3.14159*({Frequence Note}*I)/(44100.0*Note.duration))}
end

{Browse {Sample 4.0  note(name:c octave:4 sharp:true duration:1.0 instrument:none)}} %Doit renvoyer 0.079
{Browse {Sample 4.0 note(name:a octave:4 sharp:false duration:1.0 instrument:none)}} %Doit renvoyer 0.124
{Browse {Sample 4.0 note(name:a octave:6 sharp:false duration:1.0 instrument note)}} %Doit renvoyer 0.422

declare
fun {Samples Duration  Note}
   local Dur=Duration*44100.0 in
      local fun{Samples1 Dur Note I}
	       if I=={Float.toInt Dur}+1 then nil
	       else {Sample {Int.toFloat I} Note}|{Samples1 Dur Note I+1}
	       end
	    end
      in
	 {Samples1 Dur Note 1}
      end
   end
end

{Browse {Samples 0.00005 note(name:a octave:4 sharp:false duration:1.0 instrument:none)}} %Doit renvoyer une liste de deux element de Sample
{Browse {Samples 1.0  note(name:c octave:4 sharp:true duration:1.0 instrument:none)}} %Doit renvoyer 44100 elements de Sample