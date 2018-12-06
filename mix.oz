fun{Mix P2T Music}
   case Music
   of nil then nil
   [] H|T then case H
	       of samples(note:Note)) then {Samples Note}
	       [] partition(Partition) then {Partition P2T}
	       [] wave(file:FileName) then {Wave FileName}
	       [] merge(IntenseMusics) then {Merge IntenseMusics}
	       [] reverse(Music)then {Reverse Music}
	       [] repeat(amount:Integer Music) then {Repeat Integer Music}
	       [] loop(duration:Duration Music) then {loop Duration}
	       [] clip(low:Low high:High Music) then {Clip Low High Music}
	       [] echo(delay:Duration decay:Factor Music) then {Echo Duration Factor Music}
	       [] fade(in:In out:Out Music) then {Fade In Out Music}
	       [] cut(start:Start stop:Stop Music) then {Cut Start Stop Music}
	       end
   end
end



%Cette fontion Wave va chercher un fichier dans votre ordinateur, pour ensuite lire ce fichier grace a finction Project.readFile
%la complexite temporelle de cette fonction est Theta=1 car elle va aller chercher le fichier directement 
declare
fun {Wave FileName}
{Project.readFile FileName}
end

{Browse {Wave 'C:/Users/Theop/Desktop/ozplayer/wave/animals/cow.wav'}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                                             %
%                       CHAQUE FILTRE RECOIS UNE MUSIQUE QUI EST UNE LISTE DE SAMPLE                                          %
%                                                                                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Le filtre reverse va jouer la musique a l'envers (retourner la liste: le premier element devient le dernier etc.).
%Nous pouvons utiliser la fonction reverse qui est deja implementee dans Mozart. Si la liste est vide, il renverra une liste vide
declare
fun {Reverse Music}
   case Music
   of nil then nil
   [] H|T then {List.reverse Music}
   end
end

%Le filtre repeat va repeter la liste de Musique un certain nombre de fois.
%Il va parcourir toute la liste un certain nombre de fois et créer une nouvelle liste chaque fois que la liste va etre parcouru.

declare
fun {Repeat Amount Music}
   local Mus=Music in
      local fun{Repeat1 Amount Music} 
	       if Amount==0 then nil
	       else case Music
		    of H|T then H|{Repeat1 Amount T}
		    []nil then {Repeat1 Amount-1 Mus}
		    end
	       end
	    end
      in
	 {Repeat1 Amount Mus}
      end
   end
end


{Browse {Repeat 5 [1.0 2.0 3.0]}}

%AddList est une sous-fonctions pour savoir faire Merge plus facilement.
%AddList va sommer deux listes qui ne sont pas forcement de meme longueur.

declare
fun{AddList L1 L2}
   local M1={List.length L1} M2= {List.length L2} L={Min M1 M2} in
      local fun{AddList1 L1 L2 L}
	       if L==0 then if M1>M2 then case L1
					  of H|T then H+0.0|{AddList1 T nil L}
					  [] nil then nil
					  end
			    else case L2
				 of H|T then H+0.0|{AddList1 nil T L}
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


{Browse {AddList [1.0 2.0 ] [1.0 2.0 3.0]}}
{Browse {AddList nil [1.0 2.0 3.0]}}

%IntenseMusic est une fonction pour creer des musiques intensifier par un cerain facteur.
%la fonction va parcourir la liste et multiplier chaque element par le facteur donner en argument

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


   %Merge recois une List de Music avec des facteur d'intesite du style [0.5#Music1 0.2 #Music2 0.3#Music3]
   %Doit retourner l'adition de leurs Sample dans le style d'une addition de vecteurs

declare
fun{Merge IntenseMusics}
   local fun{Merge1 IntenseMusics L}	    
	    case IntenseMusics
	    of H|T then case H
			of Facteur#Music then case Music
					      of Atom then case Atom
							   of A|B then {Merge1 T {AddList {IntenseMusic Facteur Music} L}}
							   [] nil then {Merge1 T {AddList {IntenseMusic Facteur Music} L}}
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
declare O=nil
declare T=[1.0 2.0]
{Browse {Merge [0.5#P 0.3#O 0.5#T]}}

%Le filtre Loop va repeter une musique pour un certain temps 
%Si la duree de Loop s'arrete au milieu d'une musique la Musique s'arrete en meme temps
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
 
%Le filtre Clip sert a mettre une valeur minimum ou maximum aux echantillons d'une Liste.
%Si cette valeur est depassee alors la valeur de l'echantillon en question va etre changer
%vers le valeur maximum ou minimum en fonction de sa valeur
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

%La fonction Echo va creer un echo dans la musique.
%La musique et une copie de celle ci vont donc s'aditionner
%avec un delais definie pour le debut de la copie et une intensité reduite.

 declare
fun {Echo Delay Decay Music}
   local Del=Delay*44100.0 Mus=Music in
      local fun {Echo1 Del Decay Music}
	 if Del==0.0 then {Merge [Decay#Mus 1.0#Music]}
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

{Browse {Echo 0.0 0.5 [1.0 2.0 3.0]}}

%Fade va faire en sorte de demarrer une musique avec une intensite 0 et de faire en sorte qu'en une certaine duree l'intensite de la musique soit normale.
%La fonction va aussi faire en sorte que la 
%
declare
fun{Fade In Out Music}
   local DurIn = In*44100.0 DurOut = Out*44100.0 L={List.length Music}-{Float.toInt DurOut} FactIn=1.0/DurIn FactOut=1.0/DurOut in
      {Browse L}
      local fun{Fade1 DurIn DurOut FactIn F Music A L}
	       if A<{Float.toInt DurIn} then case Music
			       of H|T then H*FactIn|{Fade1 DurIn DurOut FactIn+FactIn F T A+1 L}
			       [] nil then nil
			       end
	       elseif A<L then case Music
			       of H|T then H|{Fade1 DurIn DurOut FactIn FactOut T A+1 L}
			       []nil then nil
			       end
	       else case Music
		    of H|T then H*F|{Fade1 DurIn DurOut FactIn F-FactOut T A+1 L}
		    []nil then nil
		    end
	       end
	    end
      in
	 {Fade1 DurIn DurOut FactIn 1.0 Music 0 L}
      end
   end
end


declare P=[1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0]
{Browse {List.length P}}
{Browse {Fade 0.0 0.00005 P}}

declare
fun{Cut Start Finish Music}
   local S={Float.toInt Start*44100.0} F={Float.toInt Finish*44100.0} in
      local fun{Cut1 S F Music A}
	       case Music
	       of H|T then if A<S then {Cut1 S F T A+1}
			   elseif A<F then H|{Cut1 S F T A+1}
			   else nil
			   end
	       []nil then if A<F then 0|{Cut1 S F nil A+1}
			  else nil
			  end
	       end
	    end
      in
	 {Cut1 S F Music 0}
      end
   end
end

{Browse {Cut 0.00004 0.00012 [1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0]}}
	       
	       
      
      
   
				    
   