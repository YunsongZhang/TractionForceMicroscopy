% This code deals with an inverse problem about the network model for traction force microscopy
% We first construct a force pattern and deform the network
% Then we use ONLY the information of changes in the network to see if we can reproduce the force pattern
clear all;
clc;
close all

addpath(genpath('./'));
mexAllcfiles
rng(1467)
%setting up parameters------
tic
SimuSetting.L=30;
SimuSetting.p=0.65;
SimuSetting.p_nc=0;
SimuSetting.k=0.02;
SimuSetting.k_nc=0;
SimuSetting.alpha=1;
SimuSetting.R=2.5;
SimuSetting.bead=[SimuSetting.L/2,SimuSetting.L/4*sqrt(3)];
SimuSetting.shape=1;  % stands for circle, can be reassigned for other shape

%--- construct a blank network with no bead inserted in--------
BlankNet=construct_net(SimuSetting, 0);
%   N: nodes (its 6 bonds+ order (row & column) +position (x,y) )
%   B: information of all bonds,each bond is counted twice
%   S: prepared for the bending terms
%   P: a number assigned to each of the node in the lattice
%   L: scale of the lattice
%-------------------------------------------------------------- 

%-----Insert the bead in and revise the network-----------------------------
 InitialNet=PutBeadIn(BlankNet,SimuSetting);  
 % After the function put_bead_in, now the struct I has the following
 % extra components:
 %     Nn: infomation on all crossings of attached fibers and the bead boundary 
 %     Bb: shows which outer node corresponds to each attached fiber
 %     L0: the natural lengths of each link between all pairs of "attachment point" on the cell membrane and corresponding network nodes
 %     Ss: the revised information about bending terms
 %   bead: the position of the center of the bead
%------------------------------------------------------------------------


%-----enlarge the bead in case some attached fiber is too short to cause numeric singularity-----
    while any(cell2mat({InitialNet.L0})<1e-2)
        SimuSetting.R=SimuSetting.R+1e-2;
        I=put_bead_in(InitialNet,SimuSetting);
        %flag=flag+1;
    %             disp('increasing radius')
    end
%-----------------------------------------------------------------------------------------------

%----------------------------------------------------------------------------------------------
  InitialNet=SetUpFix(InitialNet);
  % At this step, there is two extra components in InitialNet.N:
  % fix_x and fix_y to determine if the nodes are free to move
%
      %--------------
        figure(1)
        PlotStructure(InitialNet,SimuSetting);
    %------
%-------------------------------------------------------------------------------------------------    


%----construct force patterns here-----------------------------------------------------
    numAttachedFibers=length(InitialNet.Nn);
    F_abs=0.01;
        for num=1:numAttachedFibers
	    force(:,num)=[F_abs*InitialNet.Nn(num).nx;F_abs*InitialNet.Nn(num).ny];
	end

    SimuSetting.force=force;
    
%--------------------------------------------------------------------------------------
   
   FinalNet=force2deformation(InitialNet,SimuSetting);

  
   
    figure(2)
    PlotStructure(FinalNet,SimuSetting);
  
figure(1)
shg
figure(2)
shg

toc
SimuSetting.force0=SimuSetting.force;
save('./CompareData1.mat');

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------Recover the force pattern-----------------------
% Here I applied the built-in Matlab toolbox for "Global Optimization"
% Simulated Annealing algorithm is applied
% I set numIters iterations, after each of which I put the optimized values of forces as the inital guess for the next iteration
% It turns out the smaller the 'ReannealInterval' , the better the optimization will be!
load ./CompareData1.mat

save_directory='./0612';
if ~exist(save_directory)
  mkdir(save_directory)
end

savename=sprintf('%s/SAfull07.mat',save_directory);

tic
numIters=10;
numAttaches=length(FinalNet.Nn);

F_guess=SimuSetting.force0(:);
F_guess=F_guess';
F_guess=F_guess+(1e-3)*rand(size(F_guess));


lb=-0.02*ones(1,2*numAttaches);
ub=0.02*ones(1,2*numAttaches);

fval0=functionObj(F_guess)

%%
options=saoptimset('Display','iter','InitialTemperature',fval0,'AnnealingFcn',@annealingboltz,'ReannealInterval',5,'StallIterLim',1000,'TolFun',1e-8);
[F_optim{1},fval{1},exitflag{1},output{1}]=simulannealbnd(@functionObj,F_guess,lb,ub,options);


for nIters=1:numIters-1
F_guess=F_optim{nIters};
options=saoptimset('Display','iter','InitialTemperature',fval{nIters},'AnnealingFcn',@annealingboltz,'ReannealInterval',5,'StallIterLim',1000,'TolFun',1e-8);
[F_optim{nIters+1},fval{nIters+1},exitflag{nIters+1},output{nIters+1}]=simulannealbnd(@functionObj,F_guess,lb,ub,options);
save(savename);
end


toc
