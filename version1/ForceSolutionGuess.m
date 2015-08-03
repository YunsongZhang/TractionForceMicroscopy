function F_guess=ForceSolutionGuess(InitialNet,FinalNet,Simu)

numAttaches=length(FinalNet.Nn);
F_guess=zeros(2*numAttaches,1);
  for k=1:numAttaches
    x=FinalNet.Nn(k).x;
    y=FinalNet.Nn(k).y;
    x0=FinalNet.Nn(k).x0;
    y0=FinalNet.Nn(k).y0;
    l0=FinalNet.L0(k);
    l=norm([x-x0,y-y0]);
    dl=l-l0;
    F_guess(2*k-1)=Simu.alpha*dl*(x-x0)/l;
    F_guess(2*k)=Simu.alpha*dl*(y-y0)/l;
end
