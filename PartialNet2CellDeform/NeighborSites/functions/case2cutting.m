function to_cut=case2cutting(node1,node2,S)
    len=length(S);
    to_cut=[];
    
    for i=1:len
        start_node=S(i).start;
        mid_node=S(i).mid;
        end_node=S(i).end;
        list=[start_node, mid_node, end_node];
        
        if any(list==node1)&&any(list==node2)
            to_cut=[to_cut,i];
        end
        
    end