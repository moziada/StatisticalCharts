function output = mainBar(i)
%   this function takes RGB image and gets the colors & bounding boxes of bar shape
%   and colors & titles of the legend and calculating the prcentege of each
%   bar shape with respect to max number and links each prcentege with it's title
%   using the colors, also it draws a bounding boxes around titles defining each
%   title percentage and bounding box declaring the max number

[barColors, barsBoxes] = barSegment(i);
i_noBars=maskOutBar(i);
[legendColors, text, textBoxes]=LegendSegment(i_noBars);
[maxNumBox, maxNumYcord] = barMetric(i);

% barsBoxes(1, 2) -> Y coordinate of upper left corner of the first bounding box
% barsBoxes(1, 4) -> hight of first bounding box
zeroY=barsBoxes(1, 2)+barsBoxes(1, 4);
% zeroY holds the Y coordinate of the bottom of bar shapes
metricHight=zeroY-maxNumYcord;
[numBars, ~]=size(legendColors);
percentage=zeros(numBars, 1);
%calculate percentage
for indx=1:numBars
    percentage(indx)=(zeroY-barsBoxes(indx, 2))/metricHight;
end

%mapping
map=ColorMatch(barColors, legendColors);
textReordered=strings(numBars, 1);
textBoxesReordered=zeros(numBars, 4);
for indx=1:numBars
    textReordered(indx, 1)=text(map(indx), 1);
    textBoxesReordered(indx, :)=textBoxes(map(indx)).BoundingBox;
end

output=textReordered+": "+percentage;
annotatedImage= insertObjectAnnotation(i,'rectangle', textBoxesReordered, percentage, 'TextBoxOpacity',0.9,'FontSize',8);
figure, imshow(annotatedImage);
hold on
rectangle('Position', maxNumBox,'EdgeColor','r', 'LineWidth', 1)

end

