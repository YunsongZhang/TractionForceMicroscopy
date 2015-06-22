function [F_opt,fvalue,exitflag,output]=deformation2force(InitialNet,FinalNet,Simu)
% This function deals with the problem of inferring the forces from the deformation of the network
% The inital and final states of the network are given, together with the Setting of the simulatio

%-----optimization options-------------------
%options.Method = 'cg';
%options.display = 'iter';
%options.optTol=max(1e-3*Simu.k,1e-6)*1e-2;    %decide the accuracy of optimization, it should be 1~2 order down than q.k/q.k_nc
%options.Maxiter=50000;
%options.MaxFunEvals=100000;
%options.DerivativeCheck='on';
%options.progTol=1e-16;          %decide the minimal step
%--------------------------------------------

newoptions=optimoptions('fminunc','Algorithm','quasi-newton','Display','iter','TolX',1e-6,'TolFun',1e-6);

F_guess=[0.0112,0.0101];
%F_guess=ForceSolutionGuess(InitialNet,FinalNet,Simu);
%tmp=Simu.force;
%F_guess=tmp(:);
%F_guess=F_guess+0.01*rand(size(F_guess));
% fvalue=force_deviation(F_guess,InitialNet,FinalNet,Simu)
%[F,~,exitflag,output]=minFunc(@prediction_deviation,F_guess,newoptions,InitialNet,FinalNet,Simu);
%[F,fvalue,exitflag,output]=fminunc(@force_deviation,F_guess,newoptions,InitialNet,FinalNet,Simu);
[F_opt,fvalue,exitflag,output]=fminunc(@fObj,F_guess,newoptions,InitialNet,FinalNet,Simu);
output
F_opt
exitflag

%forcex=F(1:2:end-1);
%forcey=F(2:2:end);
%
%force=[forcex';forcey'];

end
