function energy=bendingE_part2(N,Nn, Ss, k, bead, L0)
%calculating shearing energy
if isempty(Ss)
    energy=0;
    return
end

len=length(Ss);
energy=0;
for i=1:len
    start_node=Ss(i).start;
    if L0(start_node)<0.02
        continue;
    else
    mid_node=Ss(i).mid;
    end_node=Ss(i).end;
    
    x_j=N(mid_node).x;
    x_i=Nn(start_node).x;
    y_j=N(mid_node).y;
    y_i=Nn(start_node).y;
    x_k=N(end_node).x;
    y_k=N(end_node).y;
    
    theta=theta2(x_i, y_i, x_j, y_j, x_k, y_k);
    energy=energy+1/2*k*theta^2;
    end
end
    
    
    
    
