function F=SolutionTrans(X,I)
% This function does the inverse task of function SolutionGuess
    F=I;

    numNodes=length(F.N);
    num=1;
        
    for i=1:numNodes
        if F.N(i).fix_x==0
            F.N(i).x=X(num);
            num=num+1;
        end
        if F.N(i).fix_y==0
            F.N(i).y=X(num);
            num=num+1;
        end
    end
    
    F.bead=[X(num),X(num+1)];
        num=num+2;

%       numAttaches=length(F.Nn);
%       for i=1:numAttaches
%           F.Nn(i).x=X(num);
% 	  F.Nn(i).y=X(num+1);
% 	  num=num+2;
%        end

end
