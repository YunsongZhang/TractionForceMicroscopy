function f=functionObj(F)

load ./CompareData1.mat
%global Initial
%global Final
%global ProblemSetting

fx=F(1:2:end-1);
fy=F(2:2:end);
force=[fx;fy];

SimuSetting.force=force;
DeformedNet=force2deformation(InitialNet,SimuSetting);

temp1=node_position(DeformedNet);
temp2=node_position(FinalNet);

f=norm(temp1-temp2)^2;

end
