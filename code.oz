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
   declare
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
	 fun{Duration1 Partition}
	     case {FlatPartition Partition}
	     of nil then nil
	     [] H|T then  {Record.make {SoundToExtended H} duration S}
		{Duration1 T}
	     end
	 end
      in
	 {Duration1 Partition}
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun{Stretch Factor Partition}
      case {FlatPartition Partition}
      of nil then nil
      [] H|T then {Record.make {SoundToExtended H} duration duration*Factor}
      end
   end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun{Drone Sound Amount}
      local
	 fun{DroneAcc Sound Amount A}
	    if Amount==0 then nil
	    else {DroneAcc Sound Amount-1 A|Sound}
	    end
	 in
	    if Amount>0 then {DroneAcc Sound Amount Sound}
	    else nil
	    end
	 end
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun{TransUp Amount Note}
      if Amount=1 then
      case {NoteToExtended Note}
      of note(name:a octave:Octave sharp:false instrument:none) then note(name:a octave:Octave sharp:true instrument:none) 
      []note(name:a octave:Octave sharp:true instrument:none) then note(name:b octave:Octave sharp:false instrument:none)
      []note(name:b octave:Octave sharp:false instrument:none)then note(name:c octave:Octave+1 sharp:false instrument:none)
      []note(name:c octave:Octave sharp:false instrument:none)then note(name:c octave:Octave sharp:true instrument:none)
      []note(name:c octave:Octave sharp:true instrument:none)then note(name:d octave:Octave sharp:false instrument:none)
      []note(name:d octave:Octave sharp:false instrument:none)then note(name:d octave:Octave sharp:true instrument:none)
      []note(name:d octave:Octave sharp:true instrument:none)then note(name:e octave:Octave sharp:false instrument:none)
      []note(name:e octave:Octave sharp:false instrument:none)then note(name:f octave:Octave sharp:false instrument:none)
      []note(name:f octave:Octave sharp:false instrument:none)then note(name:f octave:Octave sharp:true instrument:none)
      []note(name:f octave:Octave sharp:true instrument:none)then note(name:g octave:Octave sharp:false instrument:none)
      []note(name:g octave:Octave sharp:false instrument:none)then note(name:g octave:Octave sharp:true instrument:none)
      []note(name:g octave:Octave sharp:true instrument:none)then note(name:a octave:Octave sharp:false instrument:none)
      end
      else
 case {NoteToExtended Note}
      of note(name:a octave:Octave sharp:false instrument:none) then {Transup Amount-1 note(name:a octave:Octave sharp:true instrument:none)} 
      []note(name:a octave:Octave sharp:true instrument:none) then TransUp Amount-1 note(name:b octave:Octave sharp:false instrument:none)}
      []note(name:b octave:Octave sharp:false instrument:none)then {TransUp Amount-1 note(name:c octave:Octave+1 sharp:false instrument:none)}
      []note(name:c octave:Octave sharp:false instrument:none)then {TransUp Amount-1 note(name:c octave:Octave sharp:true instrument:none)}
      []note(name:c octave:Octave sharp:true instrument:none)then {TransUp Amount-1 note(name:d octave:Octave sharp:false instrument:none)}
      []note(name:d octave:Octave sharp:false instrument:none)then {TransUp Amount-1 note(name:d octave:Octave sharp:true instrument:none)}
      []note(name:d octave:Octave sharp:true instrument:none)then {TransUp Amount-1 note(name:e octave:Octave sharp:false instrument:none)}
      []note(name:e octave:Octave sharp:false instrument:none)then {TransUp Amount-1 note(name:f octave:Octave sharp:false instrument:none)}
      []note(name:f octave:Octave sharp:false instrument:none)then {TransUp Amount-1 note(name:f octave:Octave sharp:true instrument:none)}
      []note(name:f octave:Octave sharp:true instrument:none)then {TransUp Amount-1 note(name:g octave:Octave sharp:false instrument:none)}
      []note(name:g octave:Octave sharp:false instrument:none)then {TransUp Amount-1  note(name:g octave:Octave sharp:true instrument:none)}
      []note(name:g octave:Octave sharp:true instrument:none)then {TransUp Amount-1 note(name:a octave:Octave sharp:false instrument:none)}	 
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 fun{TransDown Amount Note}
      if Amount=~1 then
      case {NoteToExtended Note}
      of note(name:a octave:Octave sharp:false instrument:none) then note(name:g octave:Octave sharp:true instrument:none) 
      []note(name:a octave:Octave sharp:true instrument:none) then note(name:a octave:Octave sharp:false instrument:none)
      []note(name:b octave:Octave sharp:false instrument:none)then note(name:a octave:Octave sharp:true instrument:none)
      []note(name:c octave:Octave sharp:false instrument:none)then note(name:b octave:Octave-1 sharp:false instrument:none)
      []note(name:c octave:Octave sharp:true instrument:none)then note(name:c octave:Octave sharp:false instrument:none)
      []note(name:d octave:Octave sharp:false instrument:none)then note(name:c octave:Octave sharp:true instrument:none)
      []note(name:d octave:Octave sharp:true instrument:none)then note(name:d octave:Octave sharp:false instrument:none)
      []note(name:e octave:Octave sharp:false instrument:none)then note(name:d octave:Octave sharp:true instrument:none)
      []note(name:f octave:Octave sharp:false instrument:none)then note(name:e octave:Octave sharp:false instrument:none)
      []note(name:f octave:Octave sharp:true instrument:none)then note(name:f octave:Octave sharp:false instrument:none)
      []note(name:g octave:Octave sharp:false instrument:none)then note(name:f octave:Octave sharp:true instrument:none)
      []note(name:g octave:Octave sharp:true instrument:none)then note(name:g octave:Octave sharp:false instrument:none)
      end
      else
 case {NoteToExtended Note}
      of note(name:a octave:Octave sharp:false instrument:none) then {TransDown Amount+1 note(name:g octave:Octave sharp:true instrument:none)} 
      []note(name:a octave:Octave sharp:true instrument:none) then TransDown Amount+1 note(name:a octave:Octave sharp:false instrument:none)}
      []note(name:b octave:Octave sharp:false instrument:none)then {TransDown Amount+1 note(name:a octave:Octave sharp:true instrument:none)}
      []note(name:c octave:Octave sharp:false instrument:none)then {TransDown Amount+1 note(name:b octage:Octave-1 sharp:false instrument:none)}
      []note(name:c octave:Octave sharp:true instrument:none)then {TransDown Amount+1 note(name:c octave:Octave sharp:false instrument:none)}
      []note(name:d octave:Octave sharp:false instrument:none)then {TransDown Amount+1 note(name:c octave:Octave sharp:true instrument:none)}
      []note(name:d octave:Octave sharp:true instrument:none)then {TransDown Amount+1 note(name:d octave:Octave sharp:false instrument:none)}
      []note(name:e octave:Octave sharp:false instrument:none)then {TransDown Amount+1 note(name:d octave:Octave sharp:true instrument:none)}
      []note(name:f octave:Octave sharp:false instrument:none)then {TransDown Amount+1 note(name:e octave:Octave sharp:false instrument:none)}
      []note(name:f octave:Octave sharp:true instrument:none)then {TransDown Amount+1 note(name:f octave:Octave sharp:false instrument:none)}
      []note(name:g octave:Octave sharp:false instrument:none)then {TransDown Amount+1  note(name:f octave:Octave sharp:true instrument:none)}
      []note(name:g octave:Octave sharp:true instrument:none)then {TransDown Amount+1 note(name:g octave:Octave sharp:false instrument:none)}	 
   end

´%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   fun{Transpose Amount Partition}
      local
	 fun{TransposeAcc Amount Partition A}
   
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


					 
   