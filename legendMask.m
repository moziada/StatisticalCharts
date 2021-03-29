function out = legendMask( i )
%   this function takes an image and returns a binary mask of the legend
ibin=~imbinarize(rgb2gray(i), 0.1);
ifill = imfill(ibin,'holes');
se = strel('square', 30);
out=imopen(ifill, se);
end

