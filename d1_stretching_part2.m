function d1=d1_stretching_part2(N, Nn, Bb, L0, alpha, bead)
numNodes=length(N);
numAttaches=length(Nn);

temp1=zeros(2*numNodes,1);
temp2=0;
temp3=0;
temp4=zeros(2*numAttaches,1);

	
for i=1:numAttaches
    startnode=Bb(i).inner;
    endnode=Bb(i).outer;
    
    x_i=Nn(startnode).x;
    y_i=Nn(startnode).y;
    x_j=N(endnode).x;
    y_j=N(endnode).y;
    
    l=norm([x_i-x_j,y_i-y_j]);

    temp=L0(i)-l;
    
    stiff=alpha;

    position_j=2*endnode-1;
    temp1(position_j)=temp1(position_j)+temp*((x_i - x_j)/l)*stiff;
    temp1(position_j+1)=temp1(position_j+1)+temp*((y_i - y_j)/l)*stiff;
    position_i=2*startnode-1;
    temp4(position_i)=temp4(position_i)+temp*(-(x_i - x_j)/l)*stiff;
    temp4(position_i+1)=temp4(position_i+1)+temp*(-(y_i - y_j)/l)*stiff;


    temp2=temp2+temp*(-(x_i - x_j)/l)*stiff;
    temp3=temp3+temp*(-(y_i - y_j)/l)*stiff;
    
end

%d1=[temp1;temp2;temp3;temp4];
 d1=[temp1;0;0;temp4];
end
