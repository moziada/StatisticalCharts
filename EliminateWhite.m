function out = EliminateWhite( i )
%   this function takes a masked out pie shape and changes the bright
%   pixels to black
[H, W, ~]=size(i);
i_lab=rgb2lab(i);
for h=1:H
    for w=1:W
        if(i_lab(h, w, 1)>=75 && i_lab(h, w, 2)<25 && i_lab(h, w, 3)<25)
            i(h, w, :)=0;
        end
    end
end
out=i;
end

