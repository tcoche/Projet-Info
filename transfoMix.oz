fun{Mix P2T Music}
   case Music
   of nil then nil
   [] H|T then case H
	       of sample(Samples) then
	       [] partition(Partition) then 
	       [] wave(FileName) then 
	       [] merge(IntenseMusic) then
	       [] reverse(Music)then {Reverse Music}
	       [] repeat(amount:Integer Music) then {Repeat Integer Music}
	       [] loop(duration:Duration Music) then {loop Duration}
	       [] clip(low:Sample high:Sample Music) then
	       [] echo(delay:Duration Music) then 
	       [] fade(in:Duration out:Duration Music) then
	       [] cut(start:Duration end:Duration Music) then
	       end
   end
end

declare
[Project] = {Link ['Project2018.ozf']}
declare
fun {Wave FileName}
{Project.readFile FileName}
end

{Browse {Wave 'C:/Users/Theop/Desktop/ozplayer/wave/animals/cow.wav'}}

%L'argument Music est une list de Sample

declare
fun {Reverse Music}
   case Music
   of nil then nil
   [] H|T then {List.reverse Music}
   end
end

%L'argument de Repeat est une liste de Sample

declare
fun {Repeat Amount Music}
   if Amount==0 then nil
   else  Music|{Repeat Amount-1 Music}
   end
end

declare
fun{Loop Seconds Music}


declare
fun{AddList L1 L2}
   local M1={List.length L1} M2={List.length L2} L={Min M1 M2} in
      local fun{AddList1 L1 L2 L}
	       if L==0 then if M1>M2 then case L1
					  of H|T then H+0|{AddList1 T nil L}
					  [] nil then nil
					  end
			    else case L2
				 of H|T then H+0|{AddList1 nil T L}
				 []nil then nil
				 end
			    end
	       else case L1
		    of H|T then H+L2.1|{AddList1 T L2.2 L-1}
		    []nil then nil
		    end
	       end
	    end
      in
	 {AddList1 L1 L2 L}
      end
   end
end


{Browse {AddList [1 2] [1 2 3]}}




   if L2\=nil then case L1		      
		   of H|T then H+L2.1|{AddList T L2.2}
		   [] nil then nil
		   end
   else L1
   end
end

{AddList [1 2 3] [1 2 3]}

declare
fun{IntenseMusic Facteur Music}
   case Music
   of Atom then case Atom
		of H|T then H*Facteur|{IntenseMusic Facteur T}
		[] nil then nil
		else error
		end
   else nil
   end
end

   

{Browse {IntenseMusic 0.5 ([1.0 2.0 3.0])}}


   %Merge recois une List de Music avec des facteur d'intesité du style [0.5#Music1 0.2 #Music2 0.3#Music3]
   %Doit retourner l'adition de leurs Sample dans le style d'une addition de vecteur.
   % (Pas encore opti pour les liste de differentes longueurs)

declare
fun{Merge IntenseMusics}
   local fun{Merge1 IntenseMusics L}	    
	    case IntenseMusics
	    of H|T then case H
			of Facteur#Music then case Music
					      of Atom then case Atom
							   of A|B then {Merge1 T {AddList {IntenseMusic Facteur Music} L}}
							   else L
							   end
					      else L
					      end
			else L
			end
	    else L
	    end
	 end
   in
      {Merge1 IntenseMusics nil}
   end
end

	       

declare P=[1.0 2.0 3.0]
{Browse {Merge [0.5#P 0.3#P 0.1#P]}}

declare
fun{Loop Duration Music}
   local  Dur={Float.toInt Duration*44100.0} Mus=Music in
      local fun{Loop1 Dur Music}
	       if Dur==0 then nil
	       else case Music
		    of H|nil then H|{Loop1 Dur-1 Mus}
		       
		    [] H|T then H|{Loop1 Dur-1 T}
		    end
	       end      
	    end
      in
	 {Loop1 Dur Music}
      end   	 
   end
end

{Browse {Loop 0.00018 [958.4 785.5 885.6]}}
 
declare
fun{Clip Low High Music}
   if High<Low then Error
   else   case Music
	  of H|T then if H<Low then Low|{Clip Low High T}			 
		      elseif H>High then High|{Clip Low High T}
		      else H|{Clip Low High T}
		      end
	  [] nil then nil
	  end
   end
end


{Browse {Clip 200.0 800.0 [440.0 525.0 954.2 198.3 ] }}

 declare
fun {Echo Delay Decay Music}
   local Del=Delay*44100.0 Mus=Music in
      local fun {Echo1 Del Decay Music}
	 if Del==0.0 then {Merge [Decay#Mus 1#Music]}
	 else case Music
	      of H|T then H|{Echo1 Del-1.0 Decay T}
	      [] nil then nil
	      end
	    end
	 end
      in
	 {Echo1 Del Decay Music}
      end
   end
end

{Browse {Echo 0.00002 0.5 [1 2 3]}}

declare
fun{FadeIn Duration Music}
   local D=Duration*44100 Facteur=1.0/D in
      local fun{FadeIn1 D Facteur Music}
	       if D==0 then Music
	       else case Music
		    of H|T then Facteur*H|{FadeIn1 D Facteur+Facteur T}
		    []nil then nil
		    end
	       end
	    end
      in
	 {FadeIn1 D 0 Music}
      end
   end
end

declare
fun{FadeOut Duration Music}
   local D=Duration*44100.0 F=1.0/D L={List.length Music}-D in
      local fun{FadeOut1 D Facteur L Music A}
	       if D==0 then nil
	       else case Music
		  of H|T then if A<L then H|{FadeOut1 D Facteur L T A+1}
			      else Facteur*H|{FadeOut1 D Facteur-F L T (A+1)}
			      end
		  [] nil then nil
		  end
	       end
	    end
      in
	 {FadeOut1 D 1.0 L Music 0}
      end
   end
end

      


declare
fun{Fade Start Out Music}
   local L={List.Length Music}-(Out*44100) in
      local fun{Fade1 Start Out Music A}
	       
	       
	       
      
      
   
				    
   