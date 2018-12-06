%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Calcule de la hauteur que nous devons avoir pour la formule de la frequence
   %la fonction va verifier la valeur du nom de la note et si celle ci est Sharp
   %et va calculer la hauteur en fonction des valeurs obtenues
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
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Calcule la Frequence de la Note avec la formule 2^h/12*440
    %h est la hauteur calculer avec la formule ci-dessus
declare
fun{Frequence Note}
   local Expo in
      Expo=({Int.toFloat {Hauteur Note}}/12.0) 
      {Pow 2.0 Expo}*440.0  %On aplique la formule 2^h/12*440
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Calcule l'echantillon de la Note avec la formule a_i=1/2*sin(2pi*f*I/44100)
   %Nous changeons la formule en changeant le denominateur vers 44100*duration car ceci nous permettra de Note de nimporte quel duree
declare
fun{Sample I Note Freq Denom}
   0.5*{Float.sin (2.0*3.14159*(Freq*I)/Denom)} %On utilise la formule de l'echantillon
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Cette fonction va renvoyer une liste d'echantillons qui corespondent a une Note d'une certaine duree
declare
fun {Samples Note}
   local Dur=Note.duration*44100.0  in %On multiplie la duree par 44100 car 1 seconde=44100 echantillons
      local fun{Samples1 Dur Note I}
	       if I=={Float.toInt Dur}+1 then nil
	       else case Note
		    of silence(duration:D) then 0.0|{Samples1 Dur Note I+1}  %Si la note est silencieuse on retourne une liste de 0
		    else local Freq={Frequence Note}in
			    {Sample {Int.toFloat I} Note Freq Dur}|{Samples1 Dur Note I+1} %retourne une liste d'echantillons
			 end
		    end
	       end
	    end
      in
	 {Samples1 Dur Note 1}
      end
   end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Cette fontion Wave va chercher un fichier dans votre ordinateur, pour ensuite lire ce fichier grace a la fonction Project.readFile

declare
fun {Wave FileName}
   {Project.readFile FileName} %FileName est le chemin empreinte sur l'ordinateur pour retrouver le fichier
end


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
   [] H|T then {List.reverse Music} %Renvoie une liste inversee
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Le filtre repeat va repeter la liste de Musique un certain nombre de fois.
%Il va parcourir toute la liste un certain nombre de fois et creer une nouvelle liste chaque fois que la liste va etre parcouru.

declare
fun {Repeat Amount Music}
   local Mus=Music in %l'argument Music de depart doit etre stocke pour pouvoir le rappeler
      local fun{Repeat1 Amount Music} 
	       if Amount==0 then nil
	       else case Music
		    of H|T then H|{Repeat1 Amount T}
		    []nil then {Repeat1 Amount-1 Mus} %des qu'on arrive a la fin de la liste on rappel la liste initial pour repeter celle-ci
		    end
	       end
	    end
      in
	 {Repeat1 Amount Mus}
      end
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%AddList est une sous-fonctions pour savoir faire Merge plus facilement.
%AddList va sommer deux listes qui ne sont pas forcement de meme longueur.

declare
fun{AddList L1 L2}
   local M1={List.length L1} M2= {List.length L2} L={Min M1 M2} in %Nous declarons des variables pour avoir la longueur de L1 L2
	                                                              %et nous Stockons la valeurs minimal entre les deux dans L
      local fun{AddList1 L1 L2 L}
	       if L==0 then if M1>M2 then case L1      %Pour gerer les cas de liste nil nous allons dabord verifier quelle liste est la plus longue
					  of H|T then H |{AddList1 T nil L}
					  [] nil then nil
					  end
			    else case L2
				 of H|T then H+0.0|{AddList1 nil T L}
				 []nil then nil
				 end
			    end
	       else case L1     %Les deux listes sont encore rempli de valeurs et nous pouvons donc les additionner elements par elements
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IntenseMusic est une fonction pour creer des musiques intensifier par un cerain facteur.
%la fonction va parcourir la liste et multiplier chaque element par le facteur donner en argument

declare
fun{IntenseMusic Facteur Music}
   case Music
   of Atom then case Atom
		of H|T then H*Facteur|{IntenseMusic Facteur T} %Multiplie chaque element de la liste par le facteur
		[] nil then nil
		end
   else nil
   end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Merge recois une List de Music avec des facteur d'intesite du style [0.5#Music1 0.2 #Music2 0.3#Music3]
   %Doit retourner l'adition de leurs Sample dans le style d'une addition de vecteurs

declare
fun{Merge IntenseMusics}
   local fun{Merge1 IntenseMusics L}	    %L est une nouvelle liste qui sera additioner a la prochaine liste a chaque fois grace a la fonction AddList
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Le filtre Loop va repeter une musique pour un certain temps 
%Si la duree de Loop s'arrete au milieu d'une musique la Musique s'arrete en meme temps

declare
fun{Loop Duration Music}
   local  Dur={Float.toInt Duration*44100.0} Mus=Music in   %Un argument Dur qui vaut le nombre d'echantillons que vaut cette duree
      local fun{Loop1 Dur Music}
	       if Dur==0 then nil  %Quand on atteint la fin de la duree la liste s'arrete
	       else case Music
		    of H|nil then H|{Loop1 Dur-1 Mus} %Si on atteint la fin de la liste d'echantillon on recommence la liste du premier element
		    [] H|T then H|{Loop1 Dur-1 T} 
		    end
	       end      
	    end
      in
	 {Loop1 Dur Music}
      end   	 
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Le filtre Clip sert a mettre une valeur minimum ou maximum aux echantillons d'une Liste.
%Si cette valeur est depassee alors la valeur de l'echantillon en question va etre changer
%vers le valeur maximum ou minimum en fonction de sa valeur

declare
fun{Clip Low High Music}
   if High<Low then Error   %S'assure que Low est plus petit que High
   else   case Music
	  of H|T then if H<Low then Low|{Clip Low High T}	%Verifie la valeur de l'element si celle-ci est plus petite que Low elle va
			                                        %etre remplacee par la valeur de low		 
		      elseif H>High then High|{Clip Low High T}
		      else H|{Clip Low High T}
		      end
	  [] nil then nil
	  end
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%La fonction Echo va creer un echo dans la musique.
%La musique et une copie de celle ci vont donc s'aditionner
%avec un delais definie pour le debut de la copie et une intensite reduite.

declare
fun {Echo Delay Decay Music}
   local Del={Float.toInt Delay*44100.0} Mus=Music in   %declare un argument pour la duree en quantite d'echantillons Del et une variable Mus pour garder la liste original
      local fun {Echo1 Del Decay Music}
	       if Del==0 then {Merge [Decay#Mus 1.0#Music]} % Fonction Merg sur les deux List des que le delai de l'echo est atteint
	       else case Music
		    of H|T then H|{Echo1 Del-1 Decay T} 
		    [] nil then nil
		    end
	       end
	    end
      in
	 {Echo1 Del Decay Music}
      end
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fade va faire en sorte de demarrer une musique avec une intensite 0 et de faire en sorte qu'en une certaine duree l'intensite de la musique soit normale.
%La fonction va aussi faire en sorte que la 
%

declare
fun{Fade In Out Music}
   local DurIn = In*44100.0 DurOut = Out*44100.0 L={List.length Music}-{Float.toInt DurOut} FactIn=1.0/DurIn FactOut=1.0/DurOut in %cree plusieurs arguments
      local fun{Fade1 DurIn DurOut FactIn F Music A L}                                                                   %pour la duree de FadeIn et FadeOut, 
	       if A<{Float.toInt DurIn} then case Music                                                                  %un argument pour savoir quand commencer
					     of H|T then H*FactIn|{Fade1 DurIn DurOut FactIn+FactIn F T A+1 L}           %FadeOut et deux arguments pour savoir la
					     [] nil then nil                                                             %quel facteur ajouter a chaque echantillon
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Ce filtre permet de isoler une parti de la Musique en commencant a une certaine seconde Start et en s'arretant apres Finish secondes
   % Si la duree de finish est plus grande que celle de la musique celle ci pcera completer de silence

declare
fun{Cut Start Finish Music}
   local S={Float.toInt Start*44100.0} F={Float.toInt Finish*44100.0} in
      local fun{Cut1 S F Music A}  %fonction avec un accumulateur qui nous donne la place dans la liste
	       case Music
	       of H|T then if A<S then {Cut1 S F T A+1} %La fonction avance jusqu'au premiere echantillon que l'on souhaite
			   elseif A<F then H|{Cut1 S F T A+1} %cree une liste avec les echantillon des que le fonction arrive a la seconde Start
			   else nil % S'arrete des que nous arrivons a la seconde Stop
			   end
	       []nil then if A<F then 0|{Cut1 S F nil A+1} %Rempli le reste de la liste avec du silence si Stop est plus long que la musique
			  else nil
			     end
	       end
	    end
      in
	 {Cut1 S F Music 0}
      end
   end
end


local
   fun{Mix P2T Music}
      case Music
      of nil then nil
      [] H|T then case H
		  of samples(SamplesList) then SamplesList|{Mix P2T T}
		  [] partition(Partition) then 
		  [] wave(file:FileName) then {Wave FileName}|{Mix P2T T}
		  [] merge(IntenseMusics) then {Merge IntenseMusics}|{Mix P2T T}
		  [] reverse(Music)then {Reverse Music}|{Mix P2T T}
		  [] repeat(amount:Integer Music) then {Repeat Integer Music}|{Mix P2T T}
		  [] loop(duration:Duration Music) then {Loop Duration}|{Mix P2T T}
		  [] clip(low:Low high:High Music) then {Clip Low High Music}|{Mix P2T T}
		  [] echo(delay:Duration decay:Factor Music) then {Echo Duration Factor Music}|{Mix P2T T}
		  [] fade(in:In out:Out Music) then {Fade In Out Music}|{Mix P2T T}
		  [] cut(start:Start stop:Stop Music) then {Cut Start Stop Music}|{Mix P2T T}
		  end
      end
   end
in
   {Mix P2T Music}
end

   
				    
   