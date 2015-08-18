function Cart=polar2cart(Polar)
%transform from polar coordiante to cart coordinate
    numAttachedFibers=floor(length(Polar)/2);
    mag=Polar(1:numAttachedFibers);
    theta=Polar((numAttachedFibers+1):end);
    Cart=[mag.*cos(theta);mag.*sin(theta)];