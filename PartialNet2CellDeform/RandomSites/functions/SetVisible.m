function InitialNet=SetVisible(InitialNet,SimuSetting)
% This function determines if a node is visible in the experiment
% Here we decide it randomly
numNodes=length(InitialNet.N);

for k=1:numNodes
  if rand()<SimuSetting.VisibleProb
     InitialNet.N(k).Visible=1;
  else
     InitialNet.N(k).Visible=0;
   end
end


end
