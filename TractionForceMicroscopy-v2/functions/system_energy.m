function [energy, grad]=system_energy(X,I0,Simu)

% This function calculates the energy of the system and its gradient with respect to all degrees of freedom

I=SolutionTrans(X,I0);

numNodes=length(I.N);

N=I.N;
B=I.B;
Bb=I.Bb;
L0=I.L0;
S=I.S;
Ss=I.Ss;
bead=I.bead;
Nn=I.Nn;

E1=stretchingE_part1c(N,B,Simu.alpha);
E2=stretchingE_part2(N,Nn,Bb,L0, Simu.alpha, bead);
E3=bendingE_part1c(N,S,Simu.k);
E4=bendingE_part2(N, Nn, Ss, Simu.k, bead, L0);
%E5=forceE(I.Nn,Simu.force);

energy=E1+E2+E3+E4;       %  +E5;

grad1=d1_stretching_part1c(I.N, I.B, Simu.alpha);
grad2=d1_stretching_part2(I.N, I.Nn, I.Bb, I.L0, Simu.alpha, I.bead);
grad3=d1_bending_part1c(I.N, I.S, Simu.k);
grad4=d1_bending_part2(I.N, I.Nn, I.Ss, Simu.k, I.bead, I.L0);
%grad5=d1_forceE(I,Simu.force);

%grad1=[grad1;zeros(2*length(Nn),1)];
%grad3=[grad3;zeros(2*length(Nn),1)];

grad=grad1+grad2+grad3+grad4;       %     +grad5;

num=0;
for i=1:numNodes
    if I.N(i).fix_x==1
        num=num+1;
    end
    if I.N(i).fix_y==1
        num=num+1;
    end
end

to_delete=zeros(num,1);
num=1;
for i=1:numNodes
    if I.N(i).fix_x==1
        to_delete(num)=2*i-1;
        num=num+1;
    end
    if I.N(i).fix_y==1
        to_delete(num)=2*i;
        num=num+1;
    end
end



grad(to_delete)=[];
end
