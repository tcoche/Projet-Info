fun{Mix P2T Music}
   case Music
   of nil then nil
   [] H|T then case H
	       of sample(Sample) then
	       [] partition(Partition) then 
	       [] wave(FileName) then 
	       [] merge(Intens) then
	       [] reverse(Music)then 
	       [] repeat(Amount Music) then
	       end
   end
end

fun{IntenseMusic SampledList Factor}
   case SampledList
   of H|T then Factor*H|{IntenseMusic T Factor}
   [] nil then nil
   end
end

fun{Merge Intense}
   

fun{Merge Music Factor}



declare
fun {Reverse Music}
   case Music
   of nil then nil
   [] H|T then {List.reverse Music}
   end
end

declare
fun {Repeat Amount Music}
   if Amount==0 then nil
   else  Music|{Repeat Amount-1 Music}
   end
end

declare
fun{Loop Seconds Music}
   