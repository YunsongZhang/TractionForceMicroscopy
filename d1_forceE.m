function d1=d1_forceE(I0,force)
% calculate the gradient of the energy due to external force
numNodes=length(I0.N);
numAttaches=length(I0.Nn);

temp=-force(:);
d1=[zeros(2*numNodes+2,1);temp];

end

