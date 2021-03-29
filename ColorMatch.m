function c2indexs = ColorMatch( c1, c2 )
%   this function takes two list of colors, c1->barchart or piechart
%   colors, c2-> colors extracted from the legend and returns a new one dimentional list
%   behaves like a pointer, for example if c2indexs(i)=j so c1(i) match with c2(j)
[colors, ~]=size(c1);
c2indexs=zeros(colors, 1);
localindx=0;
for indx1 = 1 : colors
    MinDistance = inf;
    for indx2 = 1 : colors
        Rdist=c1(indx1, 1)-c2(indx2, 1);
        Gdist=c1(indx1, 2)-c2(indx2, 2);
        Bdist=c1(indx1, 3)-c2(indx2, 3);
        distance = sqrt(Rdist.^2 + Gdist.^2 + Bdist.^2);
        if distance<MinDistance
            MinDistance=distance;
            localindx=indx2;
        end
    end
    c2indexs(indx1, 1)=localindx;
end

end

