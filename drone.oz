%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Transformation Drone
%Repete le Son un certain nombre de fois

declare
fun{Drone Sound Amount}
      if Amount==0 then nil
      else Sound|{Drone Sound Amount-1}	 
      end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TEST

{Browse {Drone a#6 3}}