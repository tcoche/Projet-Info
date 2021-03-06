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
fun{Sample I Note Freq Denom}
   0.5*{Float.sin (2.0*3.14159*(Freq*I)/Denom)}
end

{Browse {Sample 4.0  note(name:c octave:4 sharp:true duration:1.0 instrument:none) 277.18 44100.0}} %Doit renvoyer 0.079
{Browse {Sample 4.0 note(name:a octave:4 sharp:false duration:1.0 instrument:none) 440.0 44100.0}} %Doit renvoyer 0.124
{Browse {Sample 4.0 note(name:a octave:6 sharp:false duration:1.0 instrument note) 1760.0 44100.0}} %Doit renvoyer 0.422

declare
fun {Samples Note}
   local Dur=Note.duration*44100.0  in
      local fun{Samples1 Dur Note I}
	       if I=={Float.toInt Dur}+1 then nil
	       else case Note
		    of silence(duration:D) then 0.0|{Samples1 Dur Note I+1}
		    else local Freq={Frequence Note}in
			    {Sample {Int.toFloat I} Note Freq Dur}|{Samples1 Dur Note I+1}
			 end
		    end
	       end
	    end
      in
	 {Samples1 Dur Note 1}
      end
   end
end


{Browse {Samples note(name:a octave:4 sharp:false duration:0.00005 instrument:none)}} %Doit renvoyer une liste de deux element de Sample
{Browse {Samples note(name:c octave:4 sharp:true duration:1.0 instrument:none)}} %Doit renvoyer 44100 elements de Sample
{Browse {Samples silence(duration:0.0005)}} %Doit renvoyer une liste de deux element de Sample