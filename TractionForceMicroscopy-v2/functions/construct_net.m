function I=construct_net(SimuSetting,display)
%make some change to construct_network, in order to make boundary condition
%consistent
%set up an unstrained network for future calculation
%--L:the width and height  %only put even number!
L=SimuSetting.L;
p=SimuSetting.p;
p_nc=SimuSetting.p_nc;
k=SimuSetting.k;
k_nc=SimuSetting.k_nc;

if mod(L,2)==1
    disp('error in input network size,only even number allowed!');
    return
end
%--bond occupation probablility: p
%--angle-containing crosslinker occupation probability:p_nc---

%--set up triangle lattice-------------------------------
%--save network information in struct N------------------
N=struct();
N.row=[];
N.column=[];
%--bond is a vector of size of 6. 
%----6------1
%---5--node--2
%----4------3
%----the value of bond-----------------------------------
%bond exist---------------1
%bond does not exist------0
%undecided---------------(-1)
N.bond=-1*ones(6,1);
%--give row and collume, P will tell you the number of the node--
P=zeros(L+1,L);   %L+1 row, L column
num=1;
for i=1:L+1
    for j=1:L
        P(i,j)=num;
        N(num).row=i;
        N(num).column=j;
        num=num+1;
    end
end
numNodes=length(N);
for i=1:numNodes
    if mod(N(i).row,2)==1
        N(i).x=N(i).column;
    else
        N(i).x=N(i).column+1/2;
    end
    N(i).y=(N(i).row-1)*sqrt(3)/2;
end
% --------plot the node in lattice-----------------
% for i=1:L+1
%     for j=1:L
%         plot(N(P(i,j)).x,N(P(i,j)).y,'ok');
%         hold on
%     end
% end
% xlim([0,L+2])
% ylim([-1,floor(sqrt(3)/2*(L+1))+1])
% --------B record the information of bond--------
B=struct();
B.start=[];
B.end=[];
%----6------1
%---5--node--2
%----4------3
%-------------some nodes on the boundary is impossible to have bond
%in some direction
for i=1:numNodes
    row=N(i).row;
    column=N(i).column;
    N(i).bond=-1*ones(6,1);
    if column-1==0
        N(i).bond(5)=-2;%the bond is impossible to exist--(-2)
    elseif column==L
        N(i).bond(2)=-2;
    end
    %------------------------------
    if row==1
        N(i).bond(4)=-2;
        N(i).bond(3)=-2;
        N(i).bond(2)=-2;
        N(i).bond(5)=-2;
    elseif row==L+1
        N(i).bond(6)=-2;
        N(i).bond(1)=-2;
        N(i).bond(2)=-2;
        N(i).bond(5)=-2;
    end
    %------------------------------
    if column==1&&mod(row,2)==1
        N(i).bond(6)=-2;
        N(i).bond(4)=-2;
    elseif column==L&&mod(row,2)==0
        N(i).bond(1)=-2;
        N(i).bond(3)=-2;
    end
    %set the boundary condition---------
    if (row==1||row==L+1)
        if column~=1
        N(i).bond(5)=0;
        end
        if column~=L
        N(i).bond(2)=0;
        end
    end
    %--------------------------------------
end
%----------------------------------------------------------------
%----6------1
%---5--node--2
%----4------3
%-------------decide the bond------------------------------------


num=1;
for i=1:numNodes
    row=N(i).row;
    column=N(i).column;
    for j=1:6
        if N(i).bond(j)~=-1
            continue;
        else
            ran=rand();
            if ran<p
                N(i).bond(j)=1;
            else
                N(i).bond(j)=0;
            end
        end
    end
    %---we only need to give 1,2,6 to the following node---
    %------------------------------
    if N(i).bond(2)==1
        endnode=P(row,column+1);
        N(endnode).bond(5)=1;
        B(num).start=i;
        B(num).end=endnode;
        num=num+1;
    end
    if N(i).bond(2)==0
        endnode=P(row,column+1);
        N(endnode).bond(5)=0;
    end
    %------------------------------
    if N(i).bond(6)==1&&mod(row,2)==0
        endnode=P(row+1,column);
        N(endnode).bond(3)=1;
        B(num).start=i;
        B(num).end=endnode;
        num=num+1;
    elseif N(i).bond(6)==1&&mod(row,2)==1
        endnode=P(row+1,column-1);
        N(endnode).bond(3)=1;
        B(num).start=i;
        B(num).end=endnode;
        num=num+1;
    end
    if N(i).bond(6)==0&&mod(row,2)==0
        endnode=P(row+1,column);
        N(endnode).bond(3)=0;
    elseif N(i).bond(6)==0&&mod(row,2)==1
        endnode=P(row+1,column-1);
        N(endnode).bond(3)=0;
    end
    %-------------------------------
    if N(i).bond(1)==1&&mod(row,2)==0
        endnode=P(row+1,column+1);
        N(endnode).bond(4)=1;
        B(num).start=i;
        B(num).end=endnode;
        num=num+1;
    elseif N(i).bond(1)==1&&mod(row,2)==1
        endnode=P(row+1,column);
        N(endnode).bond(4)=1;
        B(num).start=i;
        B(num).end=endnode;
        num=num+1;
    end
    if N(i).bond(1)==0&&mod(row,2)==0
        endnode=P(row+1,column+1);
        N(endnode).bond(4)=0;
    elseif N(i).bond(1)==0&&mod(row,2)==1
        endnode=P(row+1,column);
        N(endnode).bond(4)=0;
    end
end

%------------------------------------------------------------------
%----6------1
%---5--node--2
%----4------3
%-----------decide bending term. angle=180degree-------------------
S=struct();
S.start=[];
S.end=[];
S.mid=[];
if k~=0
    num=1;
    for i=1:numNodes
        bond=N(i).bond;
        exist=find(bond==1);
        row=N(i).row;
        column=N(i).column;
        if (~isempty(find(exist==2)))&&(~isempty(find(exist==5)))
            S(num).start=P(row,column-1);
            S(num).mid=i;
            S(num).end=P(row,column+1);
            num=num+1;
        end
        if (~isempty(find(exist==1)))&&(~isempty(find(exist==4)))
            if mod(row,2)==1
                S(num).start=P(row+1,column);
                S(num).mid=i;
                S(num).end=P(row-1,column-1);
                num=num+1;
            else
                S(num).start=P(row+1,column+1);
                S(num).mid=i;
                S(num).end=P(row-1,column);
                num=num+1;
            end
        end
        if (~isempty(find(exist==3)))&&(~isempty(find(exist==6)))
            if mod(row,2)==1
                S(num).start=P(row+1,column-1);
                S(num).mid=i;
                S(num).end=P(row-1,column);
                num=num+1;
            else
                S(num).start=P(row+1,column);
                S(num).mid=i;
                S(num).end=P(row-1,column+1);
                num=num+1;
            end
        end
    end
end
%------------------------------------------------------------------
if display==1
    plot_network(N,B);
end
%----decide angle constraining term--------------------------------
%----6------1
%---5--node--2
%----4------3
%A=struct();
%A.start=[];
%A.mid=[];
%A.end=[];
%if k_nc~=0
%    num=1;
%    for i=1:numNodes
%        bond=N(i).bond;
%        for j=1:6
%            k=j+1;
%            if k==7
%                k=1;
%            end
%            if bond(j)==1&&bond(k)==1
%                if rand()<p_nc
%                A(num).start=locate_neighor(N,P,i,j);
%                A(num).end=locate_neighor(N,P,i,k);
%                A(num).mid=i;
%                num=num+1;
%                end
%            end
%        end    
%    end
%    if display==1
%        plot_angle(N,A);
%        disp('ok');
%    end
%end

I.N=N;
I.B=B;
I.S=S;
I.P=P;
I.L=L;
%I.A=A;
