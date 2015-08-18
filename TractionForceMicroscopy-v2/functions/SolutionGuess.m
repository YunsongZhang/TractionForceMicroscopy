function X_guess=SolutionGuess(I,Simu)
% This function prepares information from the system in the form of 1D array
% The first part of X will be the positions of all free-moving nodes (x,y in turn)
% The second part of X will be the position of the center of the bead
% The third part of X will be the positions of crossings between all attached fibers and the bead boudary
   force=Simu.force;
   alpha=Simu.alpha;
   X=[];
   numNodes=length(I.N);
   Force_abs=sqrt(force(1,:).^2+force(2,:).^2);

   for i=1:numNodes
       if I.N(i).fix_x==0
         X(end+1)=I.N(i).x;
       end

       if I.N(i).fix_y==0
         X(end+1)=I.N(i).y;
       end
    end

    X(end+1)=I.bead(1);
    X(end+1)=I.bead(2);
    
    numAttaches=length(I.Nn);
    for i=1:numAttaches
      X(end+1)=I.Nn(i).x-0*I.Nn(i).nx*Force_abs(i)/alpha;
      X(end+1)=I.Nn(i).y-0*I.Nn(i).ny*Force_abs(i)/alpha;
    end      
    
    X_guess=X';
end
