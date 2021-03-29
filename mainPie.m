function output = mainPie( i )
%   this function takes RGB image and gets the colors & percentage of pie shape
%   and colors & titles of the legend and links each prcentege with it's title
%   using the colors, also it draws a bounding boxes around titles defining each
%   title percentage

[pieColors, percentage]=pieSegment(i);
[legendColors, text, textBoxes]=LegendSegment(i);
map=ColorMatch(pieColors, legendColors);

[num, ~]=size(text);
textReordered=strings(num, 1);
BoxesReordered=zeros(num, 4);
for indx=1:num
    textReordered(indx, 1)=text(map(indx), 1);
    BoxesReordered(indx, :)=textBoxes(map(indx)).BoundingBox;
end
output=textReordered+": "+percentage+"%";
annotatedImage= insertObjectAnnotation(i,'rectangle', BoxesReordered, percentage, 'TextBoxOpacity',0.9,'FontSize',8);
figure, imshow(annotatedImage);

end
