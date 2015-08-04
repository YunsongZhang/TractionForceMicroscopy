function I=put_bead_in(I, q)
%----------------------------------
%1.if both ends of a bond is within the bead, delete the bond.
%2.if both ends of a bond is outside the bead, continue.
%3.if only one end of a bond is within the bead, use the intersection point
%of bond and boundary of bead as a new end. 
%----------------------------------
bead=q.bead;
B=I.B;
N=I.N;
S=I.S;
numBonds=length(B);
TO_DELETE=[];
Nn=[];
Bb=[];
Kk=[];         %has the same size of Bb, store the spring constant
L0=[];
Ss=[];
TO_DELETE_S=[];      %the group of bending component to be deleted

for i=1:numBonds
    node1=B(i).start;
    node2=B(i).end;
    node1_LOC=[N(node1).x,N(node1).y];
    node2_LOC=[N(node2).x,N(node2).y];
    distance1=norm(node1_LOC-q.bead);
    distance2=norm(node2_LOC-q.bead);
    if distance1>q.R&&distance2>q.R
        continue;                                               %case1
    elseif distance1<=q.R&&distance2<=q.R
        TO_DELETE=[TO_DELETE,i];              %case2  
        to_cut=case2cutting(node1,node2,S);    %cut the bending terms containing the deleted bonds
        TO_DELETE_S=[TO_DELETE_S,to_cut];
    elseif distance1<q.R&&distance2>q.R
        inner_end=node1;
        outer_end=node2;
        nodenew_LOC=findintersection(node1_LOC, node2_LOC, q);
        tmpx=nodenew_LOC(1)-q.bead(1);
        tmpy=nodenew_LOC(2)-q.bead(2);
        nx=-tmpx/norm([tmpx,tmpy]);
        ny=-tmpy/norm([tmpx,tmpy]);
        
        Nn(end+1).x=nodenew_LOC(1);    %relative location to center of the circle
        Nn(end).y=nodenew_LOC(2);
        Nn(end).nx=nx;
        Nn(end).ny=ny;   
        Nn(end).x0=nodenew_LOC(1);      %what is the function of x0, y0?
        Nn(end).y0=nodenew_LOC(2);
%case3
%change the information in bond       
        Bb(end+1).inner=length(Nn);         %subfield inner gives the index in Nn, not N!
        Bb(end).outer=node2;
        L=norm(nodenew_LOC-node2_LOC);
        L0(end+1)=L;
        TO_DELETE=[TO_DELETE,i]; 
%change the information in bending components
        [num, third_node]=search_S(inner_end, outer_end, S);
        if length(num)~=length(third_node)
            error('wrong output of function search_S!')
        end
        
        if isempty(num)==0
            TO_DELETE_S=[TO_DELETE_S,num];
            for j=1:length(third_node)
                Ss(end+1).start=length(Nn);      %subfield start gives the index in Nn, not N!
                Ss(end).mid=node2;
                Ss(end).end=third_node(j);
            end
        end
            
        
    else
        inner_end=node2;
        outer_end=node1;        
        nodenew_LOC=findintersection(node2_LOC, node1_LOC, q);
        tmpx=nodenew_LOC(1)-q.bead(1);
        tmpy=nodenew_LOC(2)-q.bead(2);
        nx=-tmpx/norm([tmpx,tmpy]);
        ny=-tmpy/norm([tmpx,tmpy]);
        Nn(end+1).x=nodenew_LOC(1);
        Nn(end).y=nodenew_LOC(2);
        Nn(end).nx=nx;
        Nn(end).ny=ny;
        Nn(end).x0=nodenew_LOC(1);
	    Nn(end).y0=nodenew_LOC(2);
%change the information in bond    
        Bb(end+1).inner=length(Nn);
        Bb(end).outer=node1;
        L=norm(nodenew_LOC-node1_LOC);
%         Kk(end+1)=q.k/L;          %this may cause failure in
%         optimization. removed in future version
        L0(end+1)=L;
%case3
        TO_DELETE=[TO_DELETE,i]; 
        %change the information in bending components
        [num, third_node]=search_S(inner_end, outer_end, S);
        if length(num)~=length(third_node)
            error('wrong output of function search_S!')
        end
        
        if isempty(num)==0
            TO_DELETE_S=[TO_DELETE_S,num];
            for j=1:length(third_node)
                Ss(end+1).start=length(Nn);      %subfield start gives the index in Nn, not N!
                Ss(end).mid=node1;
                Ss(end).end=third_node(j);
            end
        end
        
    end
end

B(TO_DELETE)=[];
S(TO_DELETE_S)=[];


I.N=N;
I.B=B;
I.Nn=Nn;
I.Bb=Bb;
% I.Kk=Kk;
I.L0=L0;
I.S=S;
I.Ss=Ss;
I.bead=bead;
        
