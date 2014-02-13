function image = drawLine(image, point1, point2, color, npoints)
%Function that takes in an RGB image, two 2x1 array representing points
%that need to be connected, a colour and a specified number of points. It 
%will produce an image with the specified circle superimposed.
%Suggested value for npoints is 100-2000, the more the better!

    %Find linear space for x coordinates of the two points
    xLin = linspace(point1(2), point2(2), npoints);
    
    %Find linear space for y coordinate of the two points
    yLin = linspace(point1(1), point2(1), npoints);
    
    %Adjust all coordinates so that they are consistent with the specified
    %center and round them. Furthermore, change any value that is 0 to 1 to
    %avoid calling a zero or negative index.
    xLin = round(xLin);
    xLin(xLin <= 0) = 1;
    yLin= round(yLin);
    yLin(yLin <= 0) = 1;
    
    %Colour specifier
    colourSpec = zeros(1,3);
    if (color == 'r')
        colourSpec(1,1) = 255;
    end
    
    %Go through computed XY coordinates, changing them to the specified colour.
    for i=1:npoints
        image(yLin(i),xLin(i),1) = colourSpec(1);
        image(yLin(i),xLin(i),2) = colourSpec(2);
        image(yLin(i),xLin(i),3) = colourSpec(3);
    end
    
end

