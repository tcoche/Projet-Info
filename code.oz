local
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

   fun {SoundToExtended Sound}
      case Sound
      of Note then {NoteToExtended Sound}
      [] Chord then {ChordToExtended Sound}
      [] nil then nil   % Normalement ce cas est deja pris en compte dans []Chord car nil = Chord
      end
   end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {FlatPartition Partition}
      case Partition
      of H|T then {SoundToExtended H}|{FlatPartition T}
      [] nil then nil
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
   fun {DurationChange duration Partition}
      local
	 S=(duration div {List.Length Partition}}
	 fun{Duration1 duration Partition }
	     case {FlatPartition Partition}
	     of nil then nil
	     [] H|T then case H
			 of Note then {NoteToExtended H}
			    {Array.put H duration S}
			     {Duration1 Sec T}
			 []Chord then case H
				      of A|B then {NoteToExtended A}
					 {Array.put A duration S}
					 {Duration1 Sec T}
				      [] nil then nil
				      end
			 end
	     end
	 end
      in
	 {Duration1 duration Partition}
      end
   end
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun{Stretch factor Partition}
       case {FlatPartition Partition}
	     of nil then nil
	     [] H|T then case H
			 of Note then {NoteToExtended H}
			    {Array.put H duration duration*factor}
			     {Stretch factor T}
			 []Chord then case H
				      of A|B then {NoteToExtended A}
					 {Array.put A duration duration*factor}
					 {Stretch factor T}
				      [] nil then nil
				      end
			 end
	     end
   end
      
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


					 
   
