function f=force_deviation(F,InitialNet,FinalNet,Simu)


fx=F(1:2:end-1);
fy=F(2:2:end);

force=[fx';fy'];

Simu.force=force;
DeformedNet=force2deformation(InitialNet,Simu);

temp1=node_position(DeformedNet);
temp2=node_position(FinalNet);



f=norm(temp1-temp2)^2;

end
