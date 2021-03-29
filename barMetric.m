function [box, minY] = barMetric( i )
%this function takes RGB image and returns box is bounding box of max number
%in the vertical axis, minY is Y coordinate of max value centre

[H, W, C]=size(i);
metricW=uint16(W*0.075);     %margin from the left determined from observations
newi=i;
for h=1:H
    for w=1:W
        if w>metricW
            newi(h, w, :)=[255, 255, 255];
        end
    end
end
inewbw=rgb2gray(newi);
ibin=imbinarize(inewbw, 0.8);
ibin=~ibin;
ibin=ibin-barMask(i);

se1=strel('disk', 10);
se2=strel('rectangle',[20 2]);
se3=strel('square', 2);
inoise=imopen(ibin, se2);

ibin=ibin-inoise;
ibin=imclose(ibin, se1);    %just the numbers of the metric
ibin=imopen(ibin, se3);

[L, Num]=bwlabel(ibin);     %connected components
centers=regionprops(L,'centroid');
centers= vertcat(centers.Centroid);      %centres of lables

minY=inf;
indx=0;
%finding the min center Y-axis -> max number
for lbl=1:Num
    if centers(lbl, 2)<minY
        minY=centers(lbl, 2);
        indx=lbl;
    end
end

mask=zeros(H, W);
mask(L==indx)=1;        %mask of max number
se4=strel('rectangle',[6 6]);
mask=imdilate(mask, se4);
s = regionprops(mask,'BoundingBox');
box = vertcat(s(1).BoundingBox);        %bounding box of max number

end

