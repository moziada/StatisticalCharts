function [colores, boxes] = barSegment(i)
%this function takes RGB image and return the colors ond bounding boxes of
%the bar shapes

mask=barMask(i);
[L, componentsNum]=bwlabel(mask);       %connected components

imR=squeeze(i(:,:,1));
imG=squeeze(i(:,:,2));
imB=squeeze(i(:,:,3));
colores=zeros(componentsNum, 3);
for lbl=1:componentsNum
    colores(lbl, 1)=median(imR(L==lbl));
    colores(lbl, 2)=median(imG(L==lbl));
    colores(lbl, 3)=median(imB(L==lbl));
end

boxes = regionprops(L,'BoundingBox');
boxes = vertcat(boxes.BoundingBox);

end

