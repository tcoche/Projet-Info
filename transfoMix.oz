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
   case L1
   of H|T then H+L2.1|{AddList T L2.2}
   [] nil then nil
   end
end

{AddList [1 2 3] [1 2 3]}

declare
fun{IntenseMusic Facteur Music}
   case Music
   of H|T then H*Facteur|{IntenseMusic Facteur T}
   [] nil then nil
   end
end

{Browse {IntenseMusic 0.5 [1.0 2.0 3.0]}}


   %Merge recois une List de Music avec des facteur d'intesité du style [0.5#Music1 0.2 #Music2 0.3#Music3]
   %Doit retourner l'adition de leurs Sample dans le style d'une addition de vecteur.
declare
fun{Merge IntenseMusics}
   case IntenseMusics
   of H|T then case H
	       of Facteur#Music then case Music
					of A|B then {AddList H T.1}+{Merge T.2}
   else 0
   end
end

	       

declare P=[1.0 2.0 3.0]
{Browse {Merge [0.5#P 0.3#P 0.2#P]}}


   
				    
   