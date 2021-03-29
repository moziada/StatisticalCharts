function [compsColores, percentage]  = pieSegment( i )
%   this function takes RGB image and mask out the pie shape using
%   ExtractPie & EliminateWhite functions and then creates a binary mask
%   from the masked out pie shape and returns the color and percentage of each
%   component in the pie shape respectively

pie=ExtractPie(i);
pie=EliminateWhite(pie);
bwpie=rgb2gray(pie);
ed=edge(bwpie, 'sobel');
se = strel('disk', 1);
ed=imdilate(ed, se);
pieMask=imbinarize(bwpie, 0.05);

se2 = strel('disk', 4);
invPieMask=imerode(pieMask,se2);
invPieMask=~invPieMask;
ed=ed-invPieMask;
ed=imbinarize(ed);
segmentedPie=pieMask-ed;

%open the components
se3 = strel('square', 5);
segmentedPie=imerode(segmentedPie, se3);
se4 = strel('square', 4);
segmentedPie=imdilate(segmentedPie, se4);

[L, componentsNum]=bwlabel(segmentedPie);   %connected components
compsPixels=zeros(componentsNum, 1);
percentage=zeros(componentsNum, 1);
compsColores=zeros(componentsNum, 3);

imR=squeeze(i(:,:,1));
imG=squeeze(i(:,:,2));
imB=squeeze(i(:,:,3));

nonzeropixels=sum(sum(L(:,:)~=0), 2);
for lbl=1:componentsNum
    compsPixels(lbl, 1)=sum(sum(L(:,:)==lbl), 2);
    percentage(lbl, 1)=(compsPixels(lbl, 1)/nonzeropixels)*100;
    compsColores(lbl, 1)=median(imR(L==lbl));
    compsColores(lbl, 2)=median(imG(L==lbl));
    compsColores(lbl, 3)=median(imB(L==lbl));
end

end

