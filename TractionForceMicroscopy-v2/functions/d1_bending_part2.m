function d1=d1_bending_part2(N, Nn, Ss, k, bead, L0)

numNodes=length(N);
numAttaches=length(Nn);

if isempty(Ss)
    return
end

temp1=zeros(2*numNodes,1);
temp2=0;
temp3=0;
temp4=zeros(2*numAttaches,1);


len=length(Ss);

for i=1:len
    start_node=Ss(i).start;  %i
    if L0(start_node)<0.02
        continue;
    else
    mid_node=Ss(i).mid;      %j
    end_node=Ss(i).end;      %k
    
    %---start i,mid j,end k
    x_j=N(mid_node).x;
    y_j=N(mid_node).y;
    x_i=Nn(start_node).x;
    y_i=Nn(start_node).y;
    x_k=N(end_node).x;
    y_k=N(end_node).y;
    %------------------------------------------
    [delta_theta, phi]=theta2(x_i,y_i,x_j,y_j,x_k,y_k);
    
    common_factor=-k*delta_theta/(sqrt(1-phi^2)+eps);
    
    xij=x_i-x_j;
    yij=y_i-y_j;
    xkj=x_k-x_j;
    ykj=y_k-y_j;
    yik=y_i-y_k;
    
    c1=x_k*(-yij)+x_j*(yik)+x_i*(ykj);    %simplifed expression known from mathematica
    c2=(xij)^2+(yij)^2+eps;
    c3=(xkj)^2+(ykj)^2+eps;
    c4=(-c1)/(c2^(3/2)*c3^(1/2));
    c5=x_k^2*yij+x_j^2*yik+(x_i^2+yij*yik)*(-ykj)+2*x_j*(x_k*(-yij)+x_i*ykj);
    c6=x_i^2*(-xkj)+x_j^2*x_k-x_k*yij^2+x_i*(-x_j^2+x_k^2+ykj^2)-x_j*(x_k^2-yik*(yij+ykj));
    c7=(c2*c3)^(3/2);
    c8=(-c1)/(c2^(1/2)*c3^(3/2));
    c9=c1/(c3^(1/2)*c2^(3/2));
    
    
    %-------------------------------------------------------------------------------------------------------
    temp2=temp2+common_factor*(yij)*c4;
    
                                                %derivatives with respect to y_i
    temp3=temp3-common_factor*(xij)*c4;  
    %-------------------------------------------------------------------------------------------------------
    position_j=2*mid_node-1;    %derivatives with respect to x_j
    
    temp1(position_j)=temp1(position_j)+common_factor*c1*c5/c7;
    
                                                %derivatives with respect to y_j
    temp1(position_j+1)=temp1(position_j+1)+common_factor*(-c1)*c6/c7;
    %-------------------------------------------------------------------------------------------------------    
    position_k=2*end_node-1;   %derivatives with respect to x_k
    temp1(position_k)=temp1(position_k)+common_factor*(-ykj)*c8;
    
                                                %derivatives with respect to y_k
    temp1(position_k+1)=temp1(position_k+1)+common_factor*(-xkj)*(-c8);


    position_i=2*start_node-1;   %derivatives with respect to x_k
    temp4(position_i)=temp4(position_i)+common_factor*(-yij)*c9;
    
                                                %derivatives with respect to y_i
    temp4(position_i+1)=temp4(position_i+1)+common_factor*(-xij)*(-c9);
    end
end

%d1=[temp1;temp2;temp3;temp4];
% d1=[temp1;0;0;temp4];
d1=[temp1;0;0];
end
