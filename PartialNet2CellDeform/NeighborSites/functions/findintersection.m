function nodenew_LOC=findintersection(node1_LOC, node2_LOC, q)
    x1=node1_LOC(1);
    y1=node1_LOC(2);
    x2=node2_LOC(1);
    y2=node2_LOC(2);
    
    slope=(y2-y1)/(x2-x1);
    intercpt=y1-x1*slope;
    centerx=q.bead(1);
    centery=q.bead(2);
    
    [xout,yout]=linecirc(slope, intercpt, centerx, centery, q.R);
    
    node_candidate1=[xout(1),yout(1)];      %judge which one is the intersection point we need
    node_candidate2=[xout(2),yout(2)];
    
    vector0=node2_LOC-node1_LOC;
    vector1=node_candidate1-node1_LOC;
    
    if vector0*vector1'>0
        nodenew_LOC=node_candidate1;
    else
        nodenew_LOC=node_candidate2;
    end
    