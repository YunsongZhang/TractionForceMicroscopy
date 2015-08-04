function f=funObj_angle(displacement)
%This is the target function of our optimization
%The first half components of input displacement are the magnitudes of displacements
%The second half components of input displacement are the directions of displacements

load('./CellDeform2NetDeform_angle.mat','InitialNet','FinalNet','SimuSetting');
numAttachedFibers=floor(length(displacement)/2);
mag=displacement(1:numAttachedFibers);
theta=displacement((numAttachedFibers+1):end);
CellDeform=[mag.*cos(theta);mag.*sin(theta)];

DeformedNet=CellDeform2NetDeform(CellDeform,InitialNet,SimuSetting);

temp1=node_position(DeformedNet);
temp2=node_position(FinalNet);
%Here I insert a module to pick a part of the degrees of freedom of which we know from observations
pick_prob=0.8;
rng(1467)
box=(rand(size(temp1))<pick_prob);
temp1(box==0)=0;
temp2(box==0)=0;


f=norm(temp1-temp2)^2;
end
