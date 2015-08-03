function Final=force2deformation(InitialNet,SimuSetting)
% This function outputs the energy-minimized state of given force pattern 



%-----optimization options-------------------
options.Method = 'cg';
options.display = 'off';
options.optTol=max(1e-3*SimuSetting.k,1e-6)*1e-2;    %decide the accuracy of optimization, it should be 1~2 order down than q.k/q.k_nc
options.Maxiter=50000;
options.MaxFunEvals=100000;
options.DerivativeCheck='off';
options.progTol=1e-16;          %decide the minimal step
%--------------------------------------------

X_guess=SolutionGuess(InitialNet,SimuSetting);
[X,~,exitflag,output]=minFunc(@system_energy,X_guess,options,InitialNet,SimuSetting);

Final=SolutionTrans(X,InitialNet);
%GuessNet=SolutionTrans(X_guess,InitialNet);


end
