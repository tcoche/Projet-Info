%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transformation Transpose
% Va decaler la note de plusieurs Demiton vers le haut ou vers le bas


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Premiere sous-fonction va le monter de deminote

declare
fun {TransUp Amount Note}
   if Amount==1 then
      case Note
      of nil then nil
      []note(name:c octave:W sharp:false duration:Y instrument:Z) then note(name:c octave:W sharp:true duration:Y instrument:Z)
      []note(name:c octave:W sharp:true duration:Y instrument:Z) then note(name:d octave:W sharp:false duration:Y instrument:Z)
      []note(name:d octave:W sharp:false duration:Y instrument:Z) then note(name:d octave:W sharp:true duration:Y instrument:Z)
      []note(name:d octave:W sharp:true duration:Y instrument:Z) then note(name:e octave:W sharp:false duration:Y instrument:Z)
      []note(name:e octave:W sharp:false duration:Y instrument:Z) then note(name:f octave:W sharp:false duration:Y instrument:Z)
      []note(name:f octave:W sharp:false duration:Y instrument:Z) then note(name:f octave:W sharp:true duration:Y instrument:Z)
      []note(name:f octave:W sharp:true duration:Y instrument:Z) then note(name:g octave:W sharp:false duration:Y instrument:Z)
      []note(name:g octave:W sharp:false duration:Y instrument:Z) then note(name:g octave:W sharp:true duration:Y instrument:Z)
      []note(name:g octave:W sharp:true duration:Y instrument:Z) then note(name:a octave:W sharp:false duration:Y instrument:Z)
      []note(name:a octave:W sharp:false duration:Y instrument:Z) then note(name:a octave:W sharp:true duration:Y instrument:Z)
      []note(name:a octave:W sharp:true duration:Y instrument:Z) then note(name:b octave:W sharp:false duration:Y instrument:Z)
      []note(name:b octave:W sharp:false duration:Y instrument:Z) then note(name:c octave:W+1 sharp:false duration:Y instrument:Z)	 
      end
   else
      case Note
      of nil then nil
      []note(name:c octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 note(name:c octave:W sharp:true duration:Y instrument:Z)}
      []note(name:c octave:W sharp:true duration:Y instrument:Z) then  {TransUp Amount-1 note(name:d octave:W sharp:false duration:Y instrument:Z)}
      []note(name:d octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 note(name:d octave:W sharp:true duration:Y instrument:Z)}
      []note(name:d octave:W sharp:true duration:Y instrument:Z) then {TransUp Amount-1 note(name:e octave:W sharp:false duration:Y instrument:Z)}
      []note(name:e octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 note(name:f octave:W sharp:false duration:Y instrument:Z)}
      []note(name:f octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 note(name:f octave:W sharp:true duration:Y instrument:Z)}
      []note(name:f octave:W sharp:true duration:Y instrument:Z) then {TransUp Amount-1 note(name:g octave:W sharp:false duration:Y instrument:Z)}
      []note(name:g octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 note(name:g octave:W sharp:true duration:Y instrument:Z)}
      []note(name:g octave:W sharp:true duration:Y instrument:Z) then {TransUp Amount-1 note(name:a octave:W sharp:false duration:Y instrument:Z)}
      []note(name:a octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 note(name:a octave:W sharp:true duration:Y instrument:Z)}
      []note(name:a octave:W sharp:true duration:Y instrument:Z) then {TransUp Amount-1 note(name:b octave:W sharp:false duration:Y instrument:Z)}
      []note(name:b octave:W sharp:false duration:Y instrument:Z) then 	{TransUp Amount-1 note(name:c octave:W+1 sharp:false duration:Y instrument:Z)}
      end
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deuxieme Sous-fonction le fait descendre de demiton

declare
 fun{TransDown Amount Note}
      if Amount==~1 then
      case Note
      of note(name:a octave:W sharp:false duration:Y instrument:Z) then note(name:g octave:W sharp:true duration:Y instrument:Z) 
      []note(name:a octave:W sharp:true duration:Y instrument:Z)  then note(name:a octave:W sharp:false duration:Y instrument:Z)
      []note(name:b octave:W sharp:false duration:Y instrument:Z) then note(name:a octave:W sharp:true duration:Y instrument:Z) 
      []note(name:c octave:W sharp:false duration:Y instrument:Z) then note(name:b octave:W sharp:false duration:Y instrument:Z)
      []note(name:c octave:W sharp:true duration:Y instrument:Z) then note(name:c octave:W sharp:false duration:Y instrument:Z)
      []note(name:d octave:W sharp:false duration:Y instrument:Z) then note(name:c octave:W sharp:true duration:Y instrument:Z)
      []note(name:d octave:W sharp:true duration:Y instrument:Z)then note(name:d octave:W sharp:false duration:Y instrument:Z)
      []note(name:e octave:W sharp:false duration:Y instrument:Z)then note(name:d octave:W sharp:true duration:Y instrument:Z)
      []note(name:f octave:W sharp:false duration:Y instrument:Z)then note(name:e octave:W sharp:false duration:Y instrument:Z)
      []note(name:f octave:W sharp:true duration:Y instrument:Z)then note(name:f octave:W sharp:false duration:Y instrument:Z)
      []note(name:g octave:W sharp:false duration:Y instrument:Z)then note(name:f octave:W sharp:true duration:Y instrument:Z)
      []note(name:g octave:W sharp:true duration:Y instrument:Z)then note(name:g octave:W sharp:false duration:Y instrument:Z)
      end
      else
	 case Note
      of note(name:a octave:W sharp:false duration:Y instrument:Z) then {TransDown Amount+1 note(name:g octave:W sharp:true duration:Y instrument:Z)}
      []note(name:a octave:W sharp:true duration:Y instrument:Z) then {TransDown Amount+1 note(name:a octave:W sharp:false duration:Y instrument:Z)}
      []note(name:b octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 note(name:a octave:W sharp:true duration:Y instrument:Z)}
      []note(name:c octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 note(name:b octave:W-1 sharp:false duration:Y instrument:Z)}
      []note(name:c octave:W sharp:true duration:Y instrument:Z)then {TransDown Amount+1 note(name:c octave:W sharp:false duration:Y instrument:Z)}
      []note(name:d octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 note(name:c octave:W sharp:true duration:Y instrument:Z)}
      []note(name:d octave:W sharp:true duration:Y instrument:Z)then {TransDown Amount+1 note(name:d octave:W sharp:false duration:Y instrument:Z)}
      []note(name:e octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 note(name:d octave:W sharp:true duration:Y instrument:Z)}
      []note(name:f octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 note(name:e octave:W sharp:false duration:Y instrument:Z)}
      []note(name:f octave:W sharp:true duration:Y instrument:Z)then {TransDown Amount+1 note(name:f octave:W sharp:false duration:Y instrument:Z)}
      []note(name:g octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 note(name:f octave:W sharp:true duration:Y instrument:Z)}
      []note(name:g octave:W sharp:true duration:Y instrument:Z)then {TransDown Amount+1 note(name:g octave:W sharp:false duration:Y instrument:Z)}	 
	 end
      end
 end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fonction Transpose Finale
declare
 fun{Transpose Amount Partition}
    local FlatPart in
       FlatPart = {FlatPartition Partition}
       case FlatPart
       of H|T then case H
		   of A|B then if Amount > 1 then {TransUp Amount A}|{Transpose Amount B}
				  
			       else {TransDown Amount A}|{Transpose Amount B}
			       end
		   else {TransUp Amount H}|{Transpose Amount T}
		   end
       else nil
       end
    end
 end
