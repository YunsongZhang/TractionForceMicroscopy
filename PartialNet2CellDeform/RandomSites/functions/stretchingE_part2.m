function energy=stretchingE_part2(N, Nn, Bb, L0, alpha, bead)
    energy=0;
    size=length(Bb);
    
    for i=1:size
        inner=Bb(i).inner;    %Bb(i).inner=inner=i;
        outer=Bb(i).outer;
        
        x_inner=Nn(inner).x;
        y_inner=Nn(inner).y;

        x_outer=N(outer).x;
        y_outer=N(outer).y;
        
        L1=norm([x_inner-x_outer,y_inner-y_outer]);
        deltaL=L0(i)-L1;
        
        stiff=alpha;
        
        energy=energy+1/2*stiff*deltaL^2;
    end
