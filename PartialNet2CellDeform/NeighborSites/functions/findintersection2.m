function nodenew_LOC=findintersection2(node1_LOC,node2_LOC,q)
  %Here the ellipse is approximated as a polygon
  tmp=linspace(0,2*pi,1001);
  x1=q.Ra*cos(tmp)+q.bead(1);
  y1=q.Rb*sin(tmp)+q.bead(2);  
  
  x2=[node1_LOC(1),node2_LOC(1)];
  y2=[node1_LOC(2),node2_LOC(2)];
  
  [xc,yc]=polyxpoly(x1,y1,x2,y2);
  
  nodenew_LOC=[xc(1),yc(1)];
  
  
end
  
  
  
  
  
  
  