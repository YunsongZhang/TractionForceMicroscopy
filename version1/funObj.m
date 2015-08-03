function f=funObj(F);
% The object function for global minimization
% no guess value needed!

global InitialNet
global FinalNet
global SimuSetting

fx=F(1:2:end-1);
fy=F(2:2:end);

force=[fx';fy'];

SimuSetting1=SimuSetting;
SimuSetting1.force=force;

DeformedNet=force2deformation(InitialNet,SimuSetting1);

temp1=node_position(DeformedNet);
temp2=node_position(FinalNet);



f=norm(temp1-temp2)^2;
end
