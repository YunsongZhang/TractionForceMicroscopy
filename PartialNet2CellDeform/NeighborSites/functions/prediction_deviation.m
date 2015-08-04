function [f,g]=prediction_deviation(F,InitialNet,FinalNet,Simu)

g=zeros(length(F),1);

fx=F(1:2:end-1);
fy=F(2:2:end);

force=[fx';fy'];

%DeformedNet=force2deformation(force,InitialNet,Simu);
%
%temp1=node_position(InitialNet);
%temp2=node_position(FinalNet);
%
%f=sum(temp1.^2+temp2.^2);
f=force_deviation(F,InitialNet,FinalNet,Simu);

h=1e-4;

     for kk=1:length(F)
       F1=F;
       F2=F;
       F1(kk)=F1(kk)+h;
       F2(kk)=F2(kk)-h;
       tmp1=force_deviation(F1,InitialNet,FinalNet,Simu);
       tmp2=force_deviation(F2,InitialNet,FinalNet,Simu);
       g(kk)=(tmp2-tmp1)/(2*h);
     end

end

