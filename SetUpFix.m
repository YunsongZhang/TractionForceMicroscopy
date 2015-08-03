function I=SetUpFix(I)
%tell which nodes/coordinates to be fixed based on the q.mode

numNodes=length(I.N);
 for i=1:numNodes
     row=I.N(i).row;
     column=I.N(i).column;
     if row==1||row==I.L+1||column==1||column==I.L
        I.N(i).fix_x=1;
        I.N(i).fix_y=1;
     else
        I.N(i).fix_x=0;
        I.N(i).fix_y=0;
     end
 end
    
