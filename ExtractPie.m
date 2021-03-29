function out = ExtractPie( i )
%   this function takes RGB image i and mask out the pie shape from the
%   image
[H, W, ~] = size(i) ;
igray=rgb2gray(i);
ed=edge(igray, 'canny');
se = strel('disk', 4);
ed=imdilate(ed, se);
%find circles and mark them
[centers, rads] = imfindcircles(ed,[90 200]);
[X,Y] = meshgrid(1:W, 1:H);
%circle equation
circlePixels = (X - centers(1)).^2 + (Y - centers(2)).^2 < rads(1).^2;
for h=1:H
    for w=1:W
        if(circlePixels(h, w)==0)
            i(h, w, :)=0;
        end
    end
end
out=i;
end

