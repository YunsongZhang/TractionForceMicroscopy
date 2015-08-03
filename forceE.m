function E5=forceE(Nn,force)
% This function considers the effects of external forces 

Energy=0;
numAttaches=length(Nn);
  for i=1:numAttaches
      displacement=[Nn(i).x-Nn(i).x0,Nn(i).y-Nn(i).y0];
      F=force(:,i);
      F=F';
      Energy=Energy-sum(F.*displacement);
  end

  E5=Energy;

end


