function out = barMask( i )
% this function takes RGB image and returns a binary mask of the bars
ibw=rgb2gray(i);
ibin=imbinarize(ibw, 0.85);
ibin=~ibin;

se1 = strel('square', 30);
out=imopen(ibin, se1);

end

