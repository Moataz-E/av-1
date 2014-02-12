function image = drawCircle(image,center,r,color,npoints)
%Function that takes in an RGB image, a 2x1 array representing a center, a
%radius, a colour and a specified number of points, it will produce an
%image with the specified circle superimposed.
%Suggested value for npoints is 100-2000, the more the better!

    %theta value to find all points on the circumference of the circle
    theta=linspace(0,2*pi,npoints);

    %Array containing just the radius value, needed to compute all of the 
    %points
    points = ones(1,npoints) .* r;

    %Find the coordinates that form the circle's circumference
    [X,Y] = pol2cart(theta,points);

    %Adjust all coordinates so that they are consistent with the specified
    %center and round them. Furthermore, change any value that is 0 to 1 to
    %avoid calling a zero or negative index.
    X= round(X+center(1));
    X(X <= 0) = 1;
    Y= round(Y+center(2));
    Y(Y <= 0) = 1;

    %Colour specifier
    colourSpec = zeros(1,3);
    if (color == 'r')
        colourSpec(1,1) = 255;
    end

    %Go through computed XY coordinates, changing them to the specified colour.
    for i=1:npoints
        image(Y(i),X(i),1) = colourSpec(1);
        image(Y(i),X(i),2) = colourSpec(2);
        image(Y(i),X(i),3) = colourSpec(3);
    end
end