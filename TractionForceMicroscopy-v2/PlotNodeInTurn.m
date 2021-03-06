clear all; clc; close all;

addpath(genpath('./'))

load('Cell2Net_optimPSO_n1.mat');
% 
PlotStructure(FinalNet,SimuSetting);
% 
% for i=1:length(InitialNet.Nn)
%     x=InitialNet.Nn(i).x;
%     y=InitialNet.Nn(i).y;
%     plot(x,y,'ok');
%     pause
% end
Cart_optim=polar2cart(Optim_result);

DeformedNet=CellDeform2NetDeform(Cart_optim,InitialNet,SimuSetting);

PlotStructure(DeformedNet, SimuSetting, [0.7,0.7,0.7])
% PlotStructure(DeformedNet, SimuSetting, 'k')