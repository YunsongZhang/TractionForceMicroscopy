function node_pos=node_position(Net)
% This function puts positions of all nodes in the form of a matrix

tmp_cell=struct2cell(Net.N);
tmp_mat=cell2mat(tmp_cell(4:5,:,:));
temp1=tmp_mat(:);


tmp_cell=struct2cell(Net.Nn);
tmp_mat=cell2mat(tmp_cell(1:2,:,:));
temp2=tmp_mat(:);


node_pos=[temp1;temp2];

end
