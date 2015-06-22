function [num, third_node]=search_S(inner_node, outer_node, S)
%search bending component which contains inner_node, outer_node, return the
%number of this bending component and the number of the third node in
%bending component
%outer_node has to be the mid node in the bending component. 

    len=length(S);
    
    num=[];
    third_node=[];
    
    for i=1:len
        start_node=S(i).start;
        mid_node=S(i).mid;
        end_node=S(i).end;
        
        if outer_node~=mid_node
            continue;
        elseif start_node==inner_node
            third_node=[third_node,end_node];
            num=[num,i];
        elseif end_node==inner_node
            third_node=[third_node,start_node];
            num=[num,i];
        end
        
    end
    