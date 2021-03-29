function [legendColores, text, textBoxes] = LegendSegment( i )
%   this function takes RGB image and uses a binary mask of the legend part and returnes the
%   legend colors, titles insinde the legend and bounding boxes for the
%   titles

imR=squeeze(i(:,:,1));
imG=squeeze(i(:,:,2));
imB=squeeze(i(:,:,3));

iarea=legendMask(i);
se = strel('disk', 5);
iMask=uint8(imerode(iarea,se));

iSeg=i.*iMask;
iMask3channels=[iMask iMask iMask];
iSeg(iMask3channels==0)=255;
iSegbinarized=imbinarize(rgb2gray(iSeg), 0.9);
legendcolorsMask=~iSegbinarized;
se2 = strel('square', 5);
legendcolorsMask=imopen(legendcolorsMask,se2);
[Lcolors, colorsNum]=bwlabel(legendcolorsMask);
legendcolorsCenters=regionprops(Lcolors,'centroid');
legendcolorsCenters = vertcat(legendcolorsCenters.Centroid);

se3 = strel('rectangle',[3 25]);
se4 = strel('square', 2);
se5 = strel('rectangle',[4 30]);

textMask=~iSegbinarized-legendcolorsMask;
textlabels=imclose(textMask, se3);
textlabels=imopen(textlabels, se4);
textlabels=imdilate(textlabels, se5);
[Ltextlabels, texNum]=bwlabel(textlabels);
textCenters=regionprops(Ltextlabels,'centroid');
textCenters = vertcat(textCenters.Centroid);
textBoxes=regionprops(Ltextlabels,'BoundingBox');

lblOfColor=0;
legendColores=zeros(colorsNum, 3);
text=strings(colorsNum, 1);
%this loop and nested loop made to match each text with it's closest color
%based on the distance from their centers
for txtlbl = 1 : texNum
    MinDistance = inf;
    cx_txt = textCenters(txtlbl, 1);
    cy_txt = textCenters(txtlbl, 2);
    for colorlbl=1:colorsNum
        cx_color = legendcolorsCenters(colorlbl, 1);
        cy_color = legendcolorsCenters(colorlbl, 2);
        distance = sqrt((cx_txt - cx_color).^2 + (cy_txt - cy_color).^2);
        if distance<MinDistance
            MinDistance=distance;
            lblOfColor=colorlbl;
        end
    end
    %saving the 3 channels of the closest color to the text
    legendColores(txtlbl, 1)=median(imR(Lcolors==lblOfColor));
    legendColores(txtlbl, 2)=median(imG(Lcolors==lblOfColor));
    legendColores(txtlbl, 3)=median(imB(Lcolors==lblOfColor));
    
    %recognising the text
    TxtMask=(Ltextlabels==txtlbl);
    TxtMask=imbinarize(TxtMask-(Lcolors==lblOfColor));  %subtract the mask of color legend
    TxtMask=[TxtMask TxtMask TxtMask];      %make the mask 3 channels
    textimg=i;
    textimg(TxtMask==0)=255;
    txtTmp=ocr(textimg);
    text(txtlbl)=txtTmp.Text(1:end-2);      %array text=ocr text - last 2 digits
end

end

