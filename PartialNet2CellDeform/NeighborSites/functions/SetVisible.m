function InitialNet=SetVisible(InitialNet,SimuSetting)
% This function determines if a node is visible in the experiment
numNodes=length(InitialNet.N);

for k=1:numNodes
  tmp=[InitialNet.N(k).x,InitialNet.N(k).y]-SimuSetting.bead;
  if norm(tmp)<SimuSetting.VisibleRange
     InitialNet.N(k).Visible=1;
  else
     InitialNet.N(k).Visible=0;
   end
end


end
