% This code deals with an inverse problem about the network model for traction force microscopy
% We first construct a force pattern and deform the network
% Then we use ONLY the information of changes in the network to see if we can reproduce the displacements of all the attached nodes on the membrane of the cell
clearvars -except job*
%clear all;
clc;
close all

addpath(genpath('./'));
mexAllcfiles
rng(1467)
%setting up parameters------
tic
SimuSetting.L=30;
SimuSetting.p=0.85;  %0.65;
SimuSetting.p_nc=0;
SimuSetting.k=0.02;
SimuSetting.k_nc=0;
SimuSetting.alpha=1;
SimuSetting.R=1.5;
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
        %disp('increasing radius')
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

%------construct displacement patterns-------------------------------
     numAttachedFibers=length(InitialNet.Nn);
     d_abs=0.5;   % uniform displacement pattern, with magnitude to be d_abs
     CellDeformation=[];
     Angle=[];
       for num=1:numAttachedFibers
           CellDeformation(:,end+1)=d_abs*[InitialNet.Nn(num).nx;InitialNet.Nn(num).ny];  
           Angle(end+1)=cart2pol(InitialNet.Nn(num).nx,InitialNet.Nn(num).ny);
       end
%--------------------------------------------------------------------------------------

%---------Calculate the FinalNet deformation------------------------
  FinalNet=CellDeform2NetDeform(CellDeformation,InitialNet,SimuSetting);
%----------------------------------------------
   
    figure(2)
    PlotStructure(FinalNet,SimuSetting);
  
% figure(1)
% shg
% figure(2)
% shg

toc
save('./CellDeform2NetDeform_angle.mat'); % save the structure change data
dis=[d_abs*ones(size(Angle)),Angle];
funObj_angle(dis)  % To make sure our target function works properly

%-----Here we start to do the inverse problem------------------
% a particle swarm algorithm is applied here
% No initial guess is needed, we only need to provide a range in which possible solutions may sit
savename=sprintf('./Cell2Net_optimPSO.mat'); % The file where optimization results are saved

lb=[0*ones(1,numAttachedFibers),-pi*ones(1,numAttachedFibers)];
ub=[0.8*ones(1,numAttachedFibers),pi*ones(1,numAttachedFibers)];
InitialSwarmSpan=ub;

rng('shuffle')
PSOoptions=optimoptions('particleswarm','Display','iter','UseParallel',true,'InitialSwarmSpan',InitialSwarmSpan,'SwarmSize',100,'InertiaRange',[1e-8,2]);
[Optim_result,fval,exitflag,output]=particleswarm(@funObj_angle,2*numAttachedFibers,lb,ub,PSOoptions);
%Optim_result is a vector 2*numAttachedFibers in length, the first numAttachedFibers components are the magnitude of the displacements of each node on cell membrane, while the rest numAttachedFibers components are the directions of their displacements
save(savename);

