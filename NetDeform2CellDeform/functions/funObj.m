function f=funObj(displacement)

load('./CellDeform2NetDeform.mat','InitialNet','FinalNet','SimuSetting');
CellDeformation=[displacement(1:2:end-1);displacement(2:2:end)];

DeformedNet=CellDeform2NetDeform(CellDeformation,InitialNet,SimuSetting);

temp1=node_position(DeformedNet);
temp2=node_position(FinalNet);



f=norm(temp1-temp2)^2;
end
