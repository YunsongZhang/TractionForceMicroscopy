function PlotStructure(I,Simu,plotcolor)
% used to plot all the structure
% including the network and the bead and their attachment area
% input I : all the information of the network
% input Simu: all the information of our simulation setting

%---plot the basic structure of network---------
B=I.B;
N=I.N;
numBonds=length(B);
% hFig=figure;
for i=1:numBonds
    startnode=B(i).start;
    endnode=B(i).end;
    start_x=N(startnode).x;
    start_y=N(startnode).y;
    end_x=N(endnode).x;
    end_y=N(endnode).y;
    
    if nargin<=2
        line([start_x,end_x],[start_y,end_y],'LineStyle','--','LineWidth',2,'Color','r');
    else 
        line([start_x,end_x],[start_y,end_y],'LineStyle','-','LineWidth',2,'Color',plotcolor);
    end
        
end
%-----------------------------------------------


hold on
%----plot the attached fiber to the bead if there is a bead-----
 if isfield(I,'Bb')
   for i=1:length(I.Bb)
       inner=I.Bb(i).inner;
       outer=I.Bb(i).outer;
       
       factor=1;
       
       x_inner=I.Nn(inner).x;
       y_inner=I.Nn(inner).y;
       
       x_outer=I.N(outer).x;
       y_outer=I.N(outer).y;
       
       if nargin<=2
            line([x_inner,x_outer],[y_inner,y_outer],'LineStyle','--','LineWidth',2,'Color','r');  
       else
            line([x_inner,x_outer],[y_inner,y_outer],'LineStyle','-','LineWidth',2,'Color',plotcolor);  
       end
   end
 end
%---------------------------------------------------------------

%--------plot the bead if it is there------------

if isfield(I,'bead') && ~isfield(I,'force')   % After force is in, it's not proper to plot the shape of the bead
    t=linspace(0,2*pi,200);
    xb=Simu.R*cos(t)+I.bead(1);
    yb=Simu.R*sin(t)+I.bead(2);
  %  plot(xb,yb,'b-','LineWidth',1.5);
    hold on
    plot(Simu.bead(1), Simu.bead(2),'y.','MarkerSize',5)
    plot(I.bead(1), I.bead(2), 'k-', 'MarkerSize',5)
end
%-------------------------------------------------
