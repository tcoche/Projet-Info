local
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % Translate a note to the extended notation.
   % (On n'a pas d'impact sur la durée ou l'instrument)
   
   fun {NoteToExtended Note}
      case Note
      of Name#Octave then
         note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
      [] Atom then
         case {AtomToString Atom}
         of [_] then
            note(name:Atom octave:4 sharp:false duration:1.0 instrument:none)
         [] [N O] then
            note(name:{StringToAtom [N]}
                 octave:{StringToInt [O]}
                 sharp:false
                 duration:1.0
                 instrument: none)
	 else silence(duration : 0.0)
       	 end
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extend un chord
% input : chord
% output : <extended chord>
   
   fun {ChordToExtended Chord}
      case Chord
      of nil then nil 
      [] H|T then {NoteToExtended H}|{ChordToExtended T}
      end
   end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extend note ET chord
% sans devoir vérifier avec quel type on a à faire
% input : l'argument Sound = note|chord
% output : la version Extended de l'argument	

%	!!!!!!! case of Note ou Chord ca marche pas !!!! faut changer
% de toute façon cette fonction est inutile
   fun {SoundToExtended Sound}
      case Sound
      of Name#Octave then {NoteToExtended Sound}
      [] H|T then {ChordToExtended Sound}
      [] Atom then {NoteToExtended Sound}
      [] nil then nil
      end
   end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% c'est la fonction qu'on doit implementer pour le projet, elle est deja presente plus bas
   fun {FlatPartition Partition}
      case Partition
      of H|T then {SoundToExtended H}|{FlatPartition T}
      [] nil then nil
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Declaration d'une variable S qui nous donne la durée de chaque
   % note en fonction du la longeur de la liste. Va changer la durée
   % de la note ou de l'accord.

   fun {Duration Dur Partition}
      local
	 S=(Dur div {List.Length Partition})
	 fun {Duration1 Partition}
	    case {FlatPartition Partition}
	    of nil then nil
	    [] H|T then case H
			of A|B then {ExtendedDuration A A.duration*S}
			   {Duration1  Factor B}
			else {ExtendedDuration H H.duration*S}
			   {Duration1 Factor T}
			end
	    end
	 end
      in
	 {Duration1 Partition}
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {ExtendedDuration Note Duration}
   case Note
      of Name#Octave then
         note(name:Name octave:Octave sharp:true duration:Duration instrument:none)
      [] Atom then
         case {AtomToString Atom}
         of [_] then
            note(name:Atom octave:4 sharp:false duration:Duration instrument:none)
         [] [N O] then
            note(name:{StringToAtom [N]}
                 octave:{StringToInt [O]}
                 sharp:false
                 duration:Duration
                 instrument: none)
	 else silence(duration : 0.0)
       	 end
   end
   end
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  fun {Stretch Factor Partition}
   case {FlatPartition Partition}
   of nil then nil
   [] H|T then case H
	       of A|B then {ExtendedDuration A A.duration*Factor}
		  {Stretch Factor B}
	       else {ExtendedDuration H H.duration*Factor}
		  {Stretch Factor T}
	       end
   end
  end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun{Drone Sound Amount}
      if Amount==0 then nil
      else Sound|{Drone Sound Amount-1}	 
      end
   end
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

declare
fun {TransUp Amount Note}
   if Amount==1 then
      case {NoteToExtended Note}
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
      case {NoteToExtended Note}
      of nil then nil
      []note(name:c octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 c#W}
      []note(name:c octave:W sharp:true duration:Y instrument:Z) then  {TransUp Amount-1 [d W]}
      []note(name:d octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 d#W}
      []note(name:d octave:W sharp:true duration:Y instrument:Z) then {TransUp Amount-1 [e W]}
      []note(name:e octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 [f W]}
      []note(name:f octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 f#W}
      []note(name:f octave:W sharp:true duration:Y instrument:Z) then {TransUp Amount-1 [g W]}
      []note(name:g octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 g#W}
      []note(name:g octave:W sharp:true duration:Y instrument:Z) then {TransUp Amount-1 [a W]}
      []note(name:a octave:W sharp:false duration:Y instrument:Z) then {TransUp Amount-1 a#W}
      []note(name:a octave:W sharp:true duration:Y instrument:Z) then {TransUp Amount-1 [b W]}
      []note(name:b octave:W sharp:false duration:Y instrument:Z) then 	 {TransUp Amount-1 [c W+1]}
      end
   end
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 fun{TransDown Amount Note}
      if Amount==~1 then
      case {NoteToExtended Note}
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
 case {NoteToExtended Note}
      of note(name:a octave:W sharp:false duration:Y instrument:Z) then {TransDown Amount+1 g#W}
      []note(name:a octave:W sharp:true duration:Y instrument:Z) then TransDown Amount+1 [a W]}
      []note(name:b octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 a#W}
      []note(name:c octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 [b W-1]}
      []note(name:c octave:W sharp:true duration:Y instrument:Z)then {TransDown Amount+1 [c W]}
      []note(name:d octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 c#W}
      []note(name:d octave:W sharp:true duration:Y instrument:Z)then {TransDown Amount+1 [d W]}
      []note(name:e octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 d#W}
      []note(name:f octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 [e W]}
      []note(name:f octave:W sharp:true duration:Y instrument:Z)then {TransDown Amount+1 [f W]}
      []note(name:g octave:W sharp:false duration:Y instrument:Z)then {TransDown Amount+1 f#W}
      []note(name:g octave:W sharp:true duration:Y instrument:Z)then {TransDown Amount+1 [g W]}	 
   end

´%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   fun{Transpose Amount Partition}
      if Amount<0 then {TransDown Amount Note}
	 else {TransUp Amount Note}
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {PartitionToTimedList Partition}
      
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {Mix P2T Music}
      % TODO
      {Project.readFile 'wave/animaux/cow.wav'}
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   Music = {Project.load 'joy.dj.oz'}
   Start

   % Uncomment next line to insert your tests.
   % \insert 'tests.oz'
   % !!! Remove this before submitting.
in
   Start = {Time}

   % Uncomment next line to run your tests.
   % {Test Mix PartitionToTimedList}

   % Add variables to this list to avoid "local variable used only once"
   % warnings.
   {ForAll [NoteToExtended Music] Wait}
   
   % Calls your code, prints the result and outputs the result to `out.wav`.
   % You don't need to modify this.
   {Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}
   
   % Shows the total time to run your code.
   {Browse {IntToFloat {Time}-Start} / 1000.0}
end


					 
   