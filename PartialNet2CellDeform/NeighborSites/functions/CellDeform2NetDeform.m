
function FinalNet=CellDeform2NetDeform(CellDeformation,InitialNet,SimuSetting)
%-----optimization options-------------------
options.Method = 'cg';
options.display = 'off';
% options.optTol=max(1e-3*SimuSetting.k,1e-6)*1e-2;    %decide the accuracy of optimization, it should be 1~2 order down than q.k/q.k_nc
options.optTol=1e-5;
options.Maxiter=50000;
options.MaxFunEvals=100000;
options.DerivativeCheck='off';
options.progTol=1e-16;          %decide the minimal step
%--------------------------------------------


numAttachedFibers=length(InitialNet.Nn);
       for num=1:numAttachedFibers
          InitialNet.Nn(num).x=InitialNet.Nn(num).x0+CellDeformation(1,num);
          InitialNet.Nn(num).y=InitialNet.Nn(num).y0+CellDeformation(2,num);
       end

%-----Guess the solution----------------
numNodes=length(InitialNet.N);
X_guess=[];
for i=1:numNodes
       if InitialNet.N(i).fix_x==0
         X_guess(end+1)=InitialNet.N(i).x;
       end

       if InitialNet.N(i).fix_y==0
         X_guess(end+1)=InitialNet.N(i).y;
       end
    end

    X_guess(end+1)=InitialNet.bead(1);
    X_guess(end+1)=InitialNet.bead(2);
%-----------------------------------------
     X_guess=X_guess';
[Energy,E_grad]=system_energy(X_guess,InitialNet,SimuSetting);
%
[X,~,exitflag,output]=minFunc(@system_energy,X_guess,options,InitialNet,SimuSetting);

FinalNet=SolutionTrans(X,InitialNet);

end
